#!/usr/bin/env python3
"""
keynote_doel.py — fire lighting cues from #doel tags in Keynote presenter notes.

Indexes the deck's presenter notes once, then polls only the (cheap) current
slide number. When you land on a slide whose notes contain #doel, it fires.

Tag syntax, anywhere in the presenter notes:

    #doel                -> fires the "default" cue
    #doel rood           -> fires the "rood" cue from CUES
    #doel: warm          -> same, colon/equals optional
    #dmx 1=255, 5=128    -> sets raw channels, no CUES lookup needed

Backends: console (default), osc, artnet. All stdlib, no pip install.

    python3 keynote_doel.py --list                 # dump index, check detection
    python3 keynote_doel.py                        # run, print cues
    python3 keynote_doel.py --backend osc --osc 127.0.0.1:53000
    python3 keynote_doel.py --backend artnet --artnet 192.168.1.50:0
    python3 keynote_doel.py --selftest             # exercise cues, no Keynote

macOS will ask for Automation permission the first time (Terminal -> Keynote).
System Settings > Privacy & Security > Automation if you ever need to reset it.
"""

import argparse
import re
import socket
import struct
import subprocess
import sys
import time
import unicodedata

# --------------------------------------------------------------------------
# Cue table. Edit this.
# --------------------------------------------------------------------------

CUES = {
    "default": {"osc": "/cue/doel/start", "dmx": {1: 255, 2: 255, 3: 255}},
    "rood":    {"osc": "/cue/rood/start", "dmx": {1: 255, 2: 0,   3: 0}},
    "warm":    {"osc": "/cue/warm/start", "dmx": {1: 255, 2: 180, 3: 90}},
    "blackout": {"osc": "/cue/blackout/start", "dmx": {1: 0, 2: 0, 3: 0}},
}

CLEAR_CUE = "blackout"          # used by --clear-on-untagged
DMX_UNIVERSE_SIZE = 512

# --------------------------------------------------------------------------
# AppleScript
# --------------------------------------------------------------------------

# One call returns everything the poll loop needs: slide number, slide count
# (so we can detect an edited deck), and whether we're in playback.
POLL_SCRIPT = '''
if application "Keynote" is not running then return "NOT_RUNNING"
tell application "Keynote"
    if (count of documents) is 0 then return "NO_DOC"
    set p to playing
    tell front document
        set n to slide number of current slide
        set c to count of slides
    end tell
    return (n as string) & "|" & (c as string) & "|" & (p as string)
end tell
'''

# Presenter notes contain newlines, so delimit with a sentinel instead.
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
            set out to out & "<<<SLIDE " & i & ">>>" & nts
        end repeat
        return out
    end tell
end tell
'''

SENTINEL = re.compile(r"<<<SLIDE (\d+)>>>")


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


DOEL_RE = re.compile(r"#doel\b[ \t]*[:=]?[ \t]*([^\n#]*)", re.IGNORECASE)
DMX_RE = re.compile(r"#dmx\b[ \t]*[:=]?[ \t]*([^\n#]*)", re.IGNORECASE)
PAIR_RE = re.compile(r"(\d{1,3})\s*[=:]\s*(\d{1,3})")


def parse_notes(notes):
    """Return (cue_name_or_None, {channel: value}) found in one slide's notes."""
    notes = normalize(notes)
    cue = None
    m = DOEL_RE.search(notes)
    if m:
        arg = m.group(1).strip().strip(".,;").lower()
        cue = arg if arg else "default"

    dmx = {}
    for dm in DMX_RE.finditer(notes):
        for ch, val in PAIR_RE.findall(dm.group(1)):
            ch, val = int(ch), int(val)
            if 1 <= ch <= DMX_UNIVERSE_SIZE and 0 <= val <= 255:
                dmx[ch] = val
    return cue, dmx


def build_index():
    raw = osa(INDEX_SCRIPT)
    if raw in ("NOT_RUNNING", "NO_DOC"):
        raise KeynoteError(raw)

    index = {}
    parts = SENTINEL.split(raw)
    # parts == ['', '1', notes1, '2', notes2, ...]
    for i in range(1, len(parts) - 1, 2):
        num = int(parts[i])
        cue, dmx = parse_notes(parts[i + 1])
        index[num] = {"notes": parts[i + 1].strip(), "cue": cue, "dmx": dmx}
    return index


def poll():
    raw = osa(POLL_SCRIPT)
    if raw in ("NOT_RUNNING", "NO_DOC"):
        return None, None, False
    num, count, playing = raw.split("|")
    return int(num), int(count), playing.strip().lower() == "true"


# --------------------------------------------------------------------------
# Output backends
# --------------------------------------------------------------------------

def _pad(b):
    return b + b"\x00" * (4 - len(b) % 4)


def osc_message(addr, *args):
    tags, body = ",", b""
    for a in args:
        if isinstance(a, bool):
            tags += "T" if a else "F"
        elif isinstance(a, int):
            tags += "i"
            body += struct.pack(">i", a)
        elif isinstance(a, float):
            tags += "f"
            body += struct.pack(">f", a)
        else:
            tags += "s"
            body += _pad(str(a).encode())
    return _pad(addr.encode()) + _pad(tags.encode()) + body


class ConsoleBackend:
    name = "console"

    def fire(self, cue, dmx, slide):
        stamp = time.strftime("%H:%M:%S")
        bits = []
        if cue:
            bits.append(f"cue={cue}")
        if dmx:
            bits.append("dmx=" + ", ".join(f"{c}@{v}" for c, v in sorted(dmx.items())))
        print(f"[{stamp}] slide {slide:>3}  ->  " + "  ".join(bits))


class OSCBackend:
    name = "osc"

    def __init__(self, host, port):
        self.addr = (host, port)
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    def fire(self, cue, dmx, slide):
        entry = CUES.get(cue or "", {})
        addr = entry.get("osc") or f"/cue/{cue or 'doel'}/start"
        self.sock.sendto(osc_message(addr), self.addr)
        print(f"[osc] slide {slide} -> {addr}")
        for ch, val in sorted(dmx.items()):
            self.sock.sendto(osc_message(f"/dmx/{ch}", int(val)), self.addr)


class ArtNetBackend:
    name = "artnet"

    def __init__(self, host, universe=0, port=6454):
        self.addr = (host, port)
        self.universe = universe
        self.seq = 1
        self.data = bytearray(DMX_UNIVERSE_SIZE)
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)

    def _send(self):
        pkt = bytearray(b"Art-Net\x00")
        pkt += struct.pack("<H", 0x5000)                 # OpDmx, little-endian
        pkt += struct.pack(">H", 14)                     # protocol version
        pkt += bytes([self.seq, 0])                      # sequence, physical
        pkt += bytes([self.universe & 0xFF, (self.universe >> 8) & 0x7F])
        pkt += struct.pack(">H", DMX_UNIVERSE_SIZE)
        pkt += bytes(self.data)
        self.sock.sendto(bytes(pkt), self.addr)
        self.seq = 1 if self.seq >= 255 else self.seq + 1

    def fire(self, cue, dmx, slide):
        merged = dict(CUES.get(cue or "", {}).get("dmx", {}))
        merged.update(dmx)
        for ch, val in merged.items():
            self.data[ch - 1] = val & 0xFF
        self._send()
        print(f"[artnet] slide {slide} -> u{self.universe} " +
              ", ".join(f"{c}@{v}" for c, v in sorted(merged.items())))


# --------------------------------------------------------------------------
# Main
# --------------------------------------------------------------------------

def show_index(index):
    tagged = 0
    for num in sorted(index):
        e = index[num]
        if e["cue"] or e["dmx"]:
            tagged += 1
            desc = []
            if e["cue"]:
                known = "" if e["cue"] in CUES else "  (!! not in CUES)"
                desc.append(f"cue={e['cue']}{known}")
            if e["dmx"]:
                desc.append("dmx=" + ", ".join(f"{c}@{v}" for c, v in sorted(e["dmx"].items())))
            print(f"  slide {num:>3}  " + "  ".join(desc))
    print(f"\n{tagged} of {len(index)} slides tagged.")
    if not tagged:
        print("Nothing found. Check the notes are in the *presenter notes* pane,\n"
              "not a text box on the slide, and that the tag reads exactly #doel.")


def run(backend, args):
    print(f"Indexing deck...")
    index = build_index()
    tagged = sum(1 for e in index.values() if e["cue"] or e["dmx"])
    print(f"{len(index)} slides, {tagged} tagged. Backend: {backend.name}. Ctrl-C to stop.\n")

    last_slide = None
    last_count = len(index)
    errors = 0

    while True:
        try:
            num, count, playing = poll()
            errors = 0
        except KeynoteError as e:
            errors += 1
            if errors == 1:
                print(f"[warn] {e}", file=sys.stderr)
            time.sleep(0.5)
            continue

        if num is None:
            if last_slide is not None:
                print("[info] Keynote closed or no document; waiting...")
                last_slide = None
            time.sleep(0.5)
            continue

        if count != last_count:
            print(f"[info] slide count changed ({last_count} -> {count}), re-indexing")
            try:
                index = build_index()
                last_count = count
            except KeynoteError as e:
                print(f"[warn] re-index failed: {e}", file=sys.stderr)

        if num != last_slide:
            entry = index.get(num, {"cue": None, "dmx": {}})
            if entry["cue"] or entry["dmx"]:
                backend.fire(entry["cue"], entry["dmx"], num)
            elif args.clear_on_untagged and last_slide is not None:
                backend.fire(CLEAR_CUE, {}, num)
            elif args.verbose:
                print(f"       slide {num:>3}  (no tag)")
            last_slide = num

        time.sleep(args.interval)


def selftest(backend):
    print("Self-test: parsing sample notes, firing each cue.\n")
    samples = [
        "Welkom iedereen.\n#doel",
        "Kwartaalcijfers\n#doel rood\nNiet vergeten de grafiek te noemen.",
        "#doel: warm",
        "Handmatig: #dmx 1=255, 5=128, 12=64",
        "Gewone notitie zonder tag.",
    ]
    for i, s in enumerate(samples, 1):
        cue, dmx = parse_notes(s)
        print(f"slide {i}: cue={cue!r} dmx={dmx}")
        if cue or dmx:
            backend.fire(cue, dmx, i)
    print("\nDone.")


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--backend", choices=["console", "osc", "artnet"], default="console")
    ap.add_argument("--osc", metavar="HOST:PORT", default="127.0.0.1:53000")
    ap.add_argument("--artnet", metavar="HOST[:UNIVERSE]", default="127.0.0.1:0")
    ap.add_argument("--interval", type=float, default=0.08, help="poll seconds (default 0.08)")
    ap.add_argument("--list", action="store_true", help="print the index and exit")
    ap.add_argument("--selftest", action="store_true", help="test cue output without Keynote")
    ap.add_argument("--clear-on-untagged", action="store_true",
                    help="fire the blackout cue when landing on an untagged slide")
    ap.add_argument("-v", "--verbose", action="store_true")
    args = ap.parse_args()

    if args.backend == "osc":
        host, _, port = args.osc.partition(":")
        backend = OSCBackend(host, int(port or 53000))
    elif args.backend == "artnet":
        host, _, uni = args.artnet.partition(":")
        backend = ArtNetBackend(host, int(uni or 0))
    else:
        backend = ConsoleBackend()

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
