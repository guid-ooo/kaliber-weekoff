enum Page {
    static let html = """
<!doctype html>
<html lang="nl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>WeekOff Bridge</title>
<style>
:root{--bg:#14161a;--panel:#1c2026;--line:#2b313a;--text:#e6edf3;--dim:#8b949e;--accent:#f59e0b;--ok:#3fb950;--bad:#f85149}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--text);font:14px/1.45 -apple-system,system-ui,sans-serif}
header{position:sticky;top:0;background:var(--panel);border-bottom:1px solid var(--line);padding:12px 20px;display:flex;gap:12px;align-items:center;flex-wrap:wrap;z-index:5}
h1{font-size:15px;margin:0 8px 0 0}
.pill{background:#10131896;border:1px solid var(--line);border-radius:999px;padding:4px 12px;font-size:12px;color:var(--dim)}
.pill b{color:var(--text);font-weight:600}
main{padding:20px;max-width:1040px;margin:0 auto}
section{background:var(--panel);border:1px solid var(--line);border-radius:10px;padding:16px;margin-bottom:16px}
h2{font-size:12px;text-transform:uppercase;letter-spacing:.6px;color:var(--dim);margin:0 0 12px}
.card{border:1px solid var(--line);border-radius:8px;padding:12px;margin-bottom:10px;background:#181c21}
.head{display:flex;gap:10px;align-items:center;flex-wrap:wrap}
.row{display:grid;grid-template-columns:160px 1fr 60px;gap:10px;align-items:center;margin-top:6px}
.inline{display:flex;gap:8px;align-items:center;flex-wrap:wrap;margin-top:8px}
label{color:var(--dim);font-size:13px}
input[type=range]{width:100%;accent-color:var(--accent)}
input,select{background:#0f1216;border:1px solid var(--line);color:var(--text);border-radius:6px;padding:5px 8px;font:inherit}
input[type=number]{width:72px}
input.tag{font-family:ui-monospace,monospace;color:var(--accent);font-weight:600;width:170px}
input.path{flex:1;min-width:220px}
button{background:#0f1216;border:1px solid var(--line);color:var(--text);border-radius:6px;padding:6px 12px;font:inherit;cursor:pointer}
button:hover{border-color:var(--accent)}
button.primary{background:var(--accent);border-color:var(--accent);color:#1a1205;font-weight:600}
.right{margin-left:auto;display:flex;gap:8px}
.muted{color:var(--dim)}.ok{color:var(--ok)}.bad{color:var(--bad)}
.bar{height:6px;background:#0f1216;border-radius:3px;overflow:hidden}
.bar i{display:block;height:100%;background:var(--accent);transition:width .1s linear}
.dmx{display:grid;grid-template-columns:repeat(auto-fill,minmax(110px,1fr));gap:8px}
.dmx div{background:#0f1216;border:1px solid var(--line);border-radius:6px;padding:6px}
.dmx span{font-size:11px;color:var(--dim);display:block}
.live{outline:1px solid var(--accent)}
</style>
</head>
<body>
<header>
  <h1>WeekOff Bridge</h1>
  <span class="pill">dia <b id="slide">–</b></span>
  <span class="pill">scene <b id="scene">–</b></span>
  <span class="pill">MIDI <b id="midi">–</b></span>
  <span class="pill">uitvoer <select id="backend" style="background:none;border:0;color:var(--text);font:inherit">
    <option value="qlab">QLab</option><option value="artnet">Art-Net</option><option value="both">Allebei</option>
  </select></span>
  <span class="right"><span id="note" class="muted"></span> <button id="save" class="primary">Opslaan</button></span>
</header>
<main>
  <section><h2>Scenes</h2><div id="scenes"></div><button id="addScene">Scene toevoegen</button></section>
  <section><h2>Pads</h2><div id="pads"></div><button id="addPad">Pad toevoegen</button></section>
  <section><h2>Fixtures</h2><div id="fixtures"></div><button id="addFixture">Fixture toevoegen</button></section>
  <section><h2>Live DMX</h2><div class="dmx" id="dmx"></div></section>
</main>
<script>
let config = null, dirty = false, liveScene = [];

const el = (tag, props = {}, kids = []) => {
  const node = Object.assign(document.createElement(tag), props);
  kids.forEach(k => node.append(k));
  return node;
};
const note = (text, cls = 'muted') => {
  const n = document.getElementById('note');
  n.textContent = text; n.className = cls;
};
const markDirty = () => { dirty = true; note('niet opgeslagen'); };

function paramPaths() {
  const out = [];
  for (const [name, fx] of Object.entries(config.fixtures))
    for (const ch of fx.channels) out.push(name + '.' + ch);
  return out.sort();
}

function levelRow(target, path) {
  const value = target[path] ?? 0;
  const range = el('input', {type: 'range', min: 0, max: 100, value});
  const num = el('input', {type: 'number', min: 0, max: 100, value});
  const sync = v => {
    range.value = v; num.value = v;
    if (Number(v) === 0) delete target[path]; else target[path] = Number(v);
    markDirty();
  };
  range.oninput = () => sync(range.value);
  num.oninput = () => sync(num.value);
  return el('div', {className: 'row'}, [el('label', {textContent: path}), range, num]);
}

function renderScenes() {
  const host = document.getElementById('scenes');
  host.innerHTML = '';
  for (const tag of Object.keys(config.scenes).sort()) {
    const scene = config.scenes[tag];
    const card = el('div', {className: 'card' + (liveScene.includes(tag) ? ' live' : ''), id: 'scene-' + tag});

    const name = el('input', {className: 'tag', value: tag});
    name.onchange = () => {
      const next = name.value.trim().toLowerCase().replace(/^#/, '');
      if (!next || config.scenes[next]) { name.value = tag; return; }
      delete config.scenes[tag];
      config.scenes[next] = scene;
      markDirty(); renderScenes();
    };
    const fade = el('input', {type: 'number', step: '0.1', min: '0', value: scene.fade});
    fade.oninput = () => { scene.fade = parseFloat(fade.value) || 0; markDirty(); };

    const test = el('button', {textContent: 'Testen'});
    test.onclick = async () => {
      const r = await (await fetch('/api/preview', {method: 'POST', body: JSON.stringify({tag})})).json();
      note(r.artnet ? 'scene ' + tag + ' actief' : 'zet uitvoer op Art-Net om te zien', r.artnet ? 'ok' : 'muted');
    };
    const copy = el('button', {textContent: 'Dupliceren'});
    copy.onclick = () => {
      let n = tag + '-kopie', i = 2;
      while (config.scenes[n]) n = tag + '-kopie' + i++;
      config.scenes[n] = JSON.parse(JSON.stringify(scene));
      markDirty(); renderScenes();
    };
    const del = el('button', {textContent: 'Verwijderen'});
    del.onclick = () => { delete config.scenes[tag]; markDirty(); renderScenes(); };

    card.append(el('div', {className: 'head'}, [
      el('span', {textContent: '#'}), name,
      el('label', {textContent: 'fade (s)'}), fade,
      el('span', {className: 'right'}, [test, copy, del]),
    ]));

    paramPaths().forEach(path => card.append(levelRow(scene.values, path)));
    host.append(card);
  }
}

function renderPads() {
  const host = document.getElementById('pads');
  host.innerHTML = '';
  config.pads = config.pads || {};
  for (const key of Object.keys(config.pads).sort()) {
    const pad = config.pads[key];
    const card = el('div', {className: 'card'});

    const noteInput = el('input', {className: 'tag', value: key, style: 'width:90px'});
    noteInput.onchange = () => {
      const next = noteInput.value.trim();
      if (!next || config.pads[next]) { noteInput.value = key; return; }
      delete config.pads[key]; config.pads[next] = pad;
      markDirty(); renderPads();
    };
    const hold = el('input', {type: 'checkbox', checked: !!pad.hold});
    hold.onchange = () => { pad.hold = hold.checked; markDirty(); };
    const del = el('button', {textContent: 'Verwijderen'});
    del.onclick = () => { delete config.pads[key]; markDirty(); renderPads(); };

    card.append(el('div', {className: 'head'}, [
      el('label', {textContent: 'noot'}), noteInput,
      el('label', {textContent: 'vasthouden'}), hold,
      el('span', {className: 'right'}, [del]),
    ]));

    const sample = el('input', {className: 'path', placeholder: 'pad naar sample (optioneel)', value: pad.sample ?? ''});
    sample.onchange = () => {
      const v = sample.value.trim();
      if (v) pad.sample = v; else delete pad.sample;
      markDirty();
    };
    card.append(el('div', {className: 'inline'}, [el('label', {textContent: 'sample'}), sample]));

    pad.dmx = pad.dmx || {};
    paramPaths().forEach(path => card.append(levelRow(pad.dmx, path)));
    host.append(card);
  }
}

function renderFixtures() {
  const host = document.getElementById('fixtures');
  host.innerHTML = '';
  for (const name of Object.keys(config.fixtures).sort()) {
    const fx = config.fixtures[name];
    const card = el('div', {className: 'card'});

    const nameInput = el('input', {className: 'tag', value: name});
    nameInput.onchange = () => {
      const next = nameInput.value.trim().toLowerCase();
      if (!next || config.fixtures[next]) { nameInput.value = name; return; }
      delete config.fixtures[name]; config.fixtures[next] = fx;
      markDirty(); renderAll();
    };
    const address = el('input', {type: 'number', min: 1, max: 512, value: fx.address});
    address.oninput = () => { fx.address = parseInt(address.value) || 1; markDirty(); renderAll(); };
    const channels = el('input', {className: 'path', value: fx.channels.join(', ')});
    channels.onchange = () => {
      fx.channels = channels.value.split(',').map(c => c.trim()).filter(Boolean);
      markDirty(); renderAll();
    };
    const del = el('button', {textContent: 'Verwijderen'});
    del.onclick = () => { delete config.fixtures[name]; markDirty(); renderAll(); };

    card.append(el('div', {className: 'head'}, [
      nameInput, el('label', {textContent: 'adres'}), address,
      el('span', {className: 'right'}, [del]),
    ]));
    card.append(el('div', {className: 'inline'}, [
      el('label', {textContent: 'kanalen'}), channels,
      el('span', {className: 'muted', textContent: 'DMX ' + fx.address + '–' + (fx.address + Math.max(fx.channels.length, 1) - 1)}),
    ]));
    host.append(card);
  }
}

const renderAll = () => { renderScenes(); renderPads(); renderFixtures(); };

document.getElementById('addScene').onclick = () => {
  const tag = prompt('Scenenaam (zonder #)');
  if (!tag) return;
  const key = tag.trim().toLowerCase().replace(/^#/, '');
  if (!key || config.scenes[key]) return;
  config.scenes[key] = {fade: 2, values: {}};
  markDirty(); renderScenes();
};
document.getElementById('addPad').onclick = () => {
  const n = prompt('MIDI-noot (bijv. 44, of 9:44)');
  if (!n) return;
  config.pads = config.pads || {};
  if (config.pads[n]) return;
  config.pads[n.trim()] = {hold: false, dmx: {}};
  markDirty(); renderPads();
};
document.getElementById('addFixture').onclick = () => {
  const n = prompt('Naam van de fixture');
  if (!n) return;
  const key = n.trim().toLowerCase();
  if (!key || config.fixtures[key]) return;
  config.fixtures[key] = {address: 1, channels: ['intensity']};
  markDirty(); renderAll();
};
document.getElementById('save').onclick = async () => {
  const r = await fetch('/api/config', {method: 'PUT', body: JSON.stringify(config)});
  if (r.ok) { dirty = false; note('opgeslagen', 'ok'); setTimeout(() => note(''), 2000); }
  else note('opslaan mislukt', 'bad');
};
document.getElementById('backend').onchange = e =>
  fetch('/api/backend', {method: 'POST', body: JSON.stringify({backend: e.target.value})});
window.onbeforeunload = e => { if (dirty) e.preventDefault(); };

async function poll() {
  try {
    const s = await (await fetch('/api/state')).json();
    document.getElementById('slide').textContent = s.slide ?? '–';
    document.getElementById('scene').textContent = s.tags.length ? s.tags.join(' ') : '–';
    document.getElementById('midi').textContent = s.midi + ' bron(nen)';
    const sel = document.getElementById('backend');
    if (document.activeElement !== sel) sel.value = s.backend;

    const dmx = document.getElementById('dmx');
    if (dmx.children.length !== s.channels.length)
      dmx.innerHTML = s.channels.map(c => '<div><span>' + c.name + '</span><div class="bar"><i></i></div></div>').join('');
    s.channels.forEach((c, i) => {
      dmx.children[i].querySelector('i').style.width = Math.round(c.value / 255 * 100) + '%';
    });

    if (String(liveScene) !== String(s.tags)) {
      liveScene = s.tags;
      document.querySelectorAll('#scenes .card').forEach(c =>
        c.classList.toggle('live', liveScene.includes(c.id.replace('scene-', ''))));
    }
    if (!dirty && JSON.stringify(s.config) !== JSON.stringify(config)) { config = s.config; renderAll(); }
  } catch (e) {}
}

(async () => { config = await (await fetch('/api/config')).json(); renderAll(); setInterval(poll, 400); })();
</script>
</body>
</html>
"""
}
