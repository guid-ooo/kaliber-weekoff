#!/usr/bin/env python3
"""
keynote_dmx_bridge.py — fire QLab cues from #tags in Keynote presenter notes.

Polls Keynote for the current slide and fires every #tag in its presenter
notes. Slides marked "Skip" never fire, even if tagged.

A tag is the QLab cue NUMBER (the Q# column), not the cue name:

    #samenvatting        -> starts the cue numbered "samenvatting"
    #demo #shoutouts     -> both, in the order written

    python3 keynote_dmx_bridge.py --list      # show tagged slides, check detection
    python3 keynote_dmx_bridge.py             # run, print cues
    python3 keynote_dmx_bridge.py --backend osc
    python3 keynote_dmx_bridge.py --selftest  # parser check, no Keynote

macOS will ask for Automation permission the first time (Terminal -> Keynote).
System Settings > Privacy & Security > Automation if you ever need to reset it.
"""

import argparse
import re
import socket
import subprocess
import sys
import time
import unicodedata

QLAB_PORT = 53000

# --------------------------------------------------------------------------
# AppleScript
# --------------------------------------------------------------------------

# Reads the current slide's notes directly. Deliberately no index: during
# playback Keynote numbers slides by playback position, not document position,
# so any table keyed on document order desyncs on a deck with skipped slides.
POLL_SCRIPT = '''
if application "Keynote" is not running then return "NOT_RUNNING"
tell application "Keynote"
    if (count of documents) is 0 then return "NO_DOC"
    tell front document
        set c to current slide
        set n to slide number of c
        set sk to "0"
        try
            if skipped of c then set sk to "1"
        end try
        set nts to ""
        try
            set nts to presenter notes of c as string
        end try
    end tell
    return (n as string) & "|" & sk & "<<<" & nts
end tell
'''

# For --list only: document position, skip state and notes. A skipped slide
# never becomes the current slide, so it can never fire.
INDEX_SCRIPT = '''
if application "Keynote" is not running then return "NOT_RUNNING"
tell application "Keynote"
    if (count of documents) is 0 then return "NO_DOC"
    tell front document
        set out to ""
        repeat with i from 1 to count of slides
            set nts to ""
            try
                set nts to presenter notes of slide i as string
            end try
            set sk to "0"
            try
                if skipped of slide i then set sk to "1"
            end try
            set out to out & "<<<SLIDE " & i & "|" & sk & ">>>" & nts
        end repeat
        return out
    end tell
end tell
'''

SENTINEL = re.compile(r"<<<SLIDE (\d+)\|([01])>>>")


class KeynoteError(RuntimeError):
    pass


def osa(script, timeout=5.0):
    try:
        p = subprocess.run(
            ["osascript", "-e", script],
            capture_output=True, timeout=timeout,
        )
    except subprocess.TimeoutExpired:
        raise KeynoteError("osascript timed out")
    if p.returncode != 0:
        raise KeynoteError(p.stderr.decode(errors="replace").strip())
    return p.stdout.decode(errors="replace").rstrip("\n")


# --------------------------------------------------------------------------
# Text handling
# --------------------------------------------------------------------------

def normalize(s):
    """Keynote hands back smart quotes, NBSPs and soft breaks. Flatten them."""
    s = unicodedata.normalize("NFKC", s)
    s = s.replace("\u00a0", " ").replace("\u2028", "\n").replace("\u2029", "\n")
    s = s.replace("\u2018", "'").replace("\u2019", "'")
    s = s.replace("\u201c", '"').replace("\u201d", '"')
    return s


# OSC reserves # * , ? [ ] { } / in address patterns, so a cue number is
# limited to what can safely sit in /cue/<here>/start.
TAG_RE = re.compile(r"#([A-Za-z][A-Za-z0-9_.-]*)")


def parse_notes(notes):
    """Return the cue numbers tagged in one slide's notes, in order, deduped."""
    seen = []
    for m in TAG_RE.finditer(normalize(notes)):
        cue = m.group(1).lower()
        if cue not in seen:
            seen.append(cue)
    return seen


def build_index():
    raw = osa(INDEX_SCRIPT)
    if raw in ("NOT_RUNNING", "NO_DOC"):
        raise KeynoteError(raw)

    index = {}
    parts = SENTINEL.split(raw)
    # parts == ['', '1', '0', notes1, '2', '1', notes2, ...]
    for i in range(1, len(parts) - 2, 3):
        index[int(parts[i])] = {
            "skipped": parts[i + 1] == "1",
            "cues": parse_notes(parts[i + 2]),
        }
    return index


def poll():
    """Return (playback position, skipped?, cue tags on the current slide)."""
    raw = osa(POLL_SCRIPT)
    if raw in ("NOT_RUNNING", "NO_DOC"):
        return None, False, []
    head, _, notes = raw.partition("<<<")
    num, _, sk = head.partition("|")
    return int(num), sk == "1", parse_notes(notes)


# --------------------------------------------------------------------------
# Output backends
# --------------------------------------------------------------------------

def _pad(b):
    return b + b"\x00" * (4 - len(b) % 4)


def osc_message(addr):
    return _pad(addr.encode()) + _pad(b",")


class ConsoleBackend:
    name = "console"

    def fire(self, cues, slide):
        stamp = time.strftime("%H:%M:%S")
        print(f"[{stamp}] slide {slide:>3}  ->  " + "  ".join(cues))


class QLabBackend:
    """Drives QLab over AppleScript. No passcode, no network settings."""

    name = "qlab"
    BUNDLE = 'application id "com.figure53.QLab.5"'

    def fire(self, cues, slide):
        body = "\n".join(
            f'        try\n'
            f'            start (first cue whose q number is "{c}")\n'
            f'        on error\n'
            f'            set missing to missing & "{c} "\n'
            f'        end try'
            for c in cues
        )
        script = (f'set missing to ""\n'
                  f'tell {self.BUNDLE}\n'
                  f'    tell front workspace\n{body}\n'
                  f'    end tell\n'
                  f'end tell\n'
                  f'return missing')
        try:
            missing = osa(script).strip()
        except KeynoteError as e:
            print(f"[warn] QLab: {e}", file=sys.stderr)
            return
        fired = [c for c in cues if c not in missing.split()]
        if fired:
            print(f"[qlab] slide {slide} -> " + "  ".join(fired))
        if missing:
            print(f"[warn] slide {slide}: no cue numbered {missing.strip()}", file=sys.stderr)


class OSCBackend:
    name = "osc"

    def __init__(self, host, port):
        self.addr = (host, port)
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    def fire(self, cues, slide):
        for cue in cues:
            addr = f"/cue/{cue}/start"
            self.sock.sendto(osc_message(addr), self.addr)
            print(f"[qlab] slide {slide} -> {addr}")


# --------------------------------------------------------------------------
# Main
# --------------------------------------------------------------------------

def show_index(index):
    tagged = skipped = 0
    for num in sorted(index):
        e = index[num]
        if not e["cues"]:
            continue
        tagged += 1
        mark = "  SKIPPED, never fires" if e["skipped"] else ""
        if e["skipped"]:
            skipped += 1
        print(f"  slide {num:>3}  " + "  ".join(e["cues"]) + mark)

    print(f"\n{tagged} of {len(index)} slides tagged" +
          (f", {skipped} of them skipped." if skipped else "."))
    if not tagged:
        print("Nothing found. Check the tags are in the *presenter notes* pane,\n"
              "not a text box on the slide, and that they read like #doel.")
    else:
        print("Each tag must match a QLab cue NUMBER (the Q# column), not the cue name.")


def run(backend, args):
    print(f"Backend: {backend.name}. Ctrl-C to stop.\n")

    last = None
    errors = 0

    while True:
        try:
            num, skipped, cues = poll()
            errors = 0
        except KeynoteError as e:
            errors += 1
            if errors == 1:
                print(f"[warn] {e}", file=sys.stderr)
            time.sleep(0.5)
            continue

        if num is None:
            if last is not None:
                print("[info] Keynote closed or no document; waiting...")
                last = None
            time.sleep(0.5)
            continue

        # A skipped slide is invisible during the show: it must not fire, and
        # must not reset the running scene either.
        # Keyed on the tags alone, not the slide: a run of slides carrying the
        # same tag is one scene, so it fires once and keeps playing.
        if not skipped and tuple(cues) != last:
            if cues:
                backend.fire(cues, num)
            elif args.clear_cue and last is not None:
                backend.fire([args.clear_cue], num)
            elif args.verbose:
                print(f"       slide {num:>3}  (no tag)")
            last = tuple(cues)

        time.sleep(args.interval)


def selftest(backend):
    cases = [
        ("Welkom iedereen.\n#doel", ["doel"]),
        ("Kwartaalcijfers\n#shoutout\nNiet vergeten de grafiek.", ["shoutout"]),
        ("#doel #shoutout", ["doel", "shoutout"]),
        ("#Doel en nog eens #doel", ["doel"]),
        ("Gewone notitie zonder tag.", []),
        ("Prijs is #1 in de markt", []),
        ("mail me op guido@example.com #default", ["default"]),
    ]
    for notes, want in cases:
        got = parse_notes(notes)
        assert got == want, f"{notes!r}: got {got}, want {want}"

    print("parser ok:", len(cases), "cases\n")
    for i, (notes, want) in enumerate(cases, 1):
        if want:
            backend.fire(want, i)
    print("\nDone.")


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--backend", choices=["qlab", "console", "osc"], default="qlab")
    ap.add_argument("--osc", metavar="HOST:PORT", default=f"127.0.0.1:{QLAB_PORT}")
    ap.add_argument("--interval", type=float, default=0.25, help="poll seconds (default 0.25)")
    ap.add_argument("--list", action="store_true", help="print the index and exit")
    ap.add_argument("--selftest", action="store_true", help="check the parser, no Keynote")
    ap.add_argument("--clear-cue", metavar="NUMBER", default="",
                    help="fire this cue when landing on an untagged slide")
    ap.add_argument("-v", "--verbose", action="store_true")
    args = ap.parse_args()

    if args.backend == "osc":
        host, _, port = args.osc.partition(":")
        backend = OSCBackend(host, int(port or QLAB_PORT))
    elif args.backend == "console":
        backend = ConsoleBackend()
    else:
        backend = QLabBackend()

    if args.selftest:
        selftest(backend)
        return

    try:
        if args.list:
            show_index(build_index())
        else:
            run(backend, args)
    except KeynoteError as e:
        msg = {"NOT_RUNNING": "Keynote isn't running.",
               "NO_DOC": "Keynote has no open document."}.get(str(e), str(e))
        print(f"Error: {msg}", file=sys.stderr)
        sys.exit(1)
    except KeyboardInterrupt:
        print("\nStopped.")


if __name__ == "__main__":
    main()
