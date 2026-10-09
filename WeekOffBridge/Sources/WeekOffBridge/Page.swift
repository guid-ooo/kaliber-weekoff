enum Page {
    static let html = """
<!doctype html>
<html lang="nl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>WeekOff Bridge</title>
<style>
:root{--bg:#14161a;--panel:#1c2026;--line:#2b313a;--text:#e6edf3;--dim:#8b949e;--accent:#f59e0b;--ok:#3fb950}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--text);font:14px/1.45 -apple-system,system-ui,sans-serif}
header{position:sticky;top:0;background:var(--panel);border-bottom:1px solid var(--line);padding:12px 20px;display:flex;gap:20px;align-items:center;flex-wrap:wrap;z-index:5}
h1{font-size:15px;margin:0;letter-spacing:.3px}
.pill{background:#10131896;border:1px solid var(--line);border-radius:999px;padding:4px 12px;font-size:12px;color:var(--dim)}
.pill b{color:var(--text);font-weight:600}
main{padding:20px;max-width:1000px;margin:0 auto}
section{background:var(--panel);border:1px solid var(--line);border-radius:10px;padding:16px;margin-bottom:16px}
h2{font-size:13px;text-transform:uppercase;letter-spacing:.6px;color:var(--dim);margin:0 0 12px}
.scene{border:1px solid var(--line);border-radius:8px;padding:12px;margin-bottom:10px}
.scene-head{display:flex;gap:10px;align-items:center;flex-wrap:wrap}
.tag{font-family:ui-monospace,SFMono-Regular,monospace;color:var(--accent);font-weight:600}
.row{display:grid;grid-template-columns:150px 1fr 56px;gap:10px;align-items:center;margin-top:8px}
label{color:var(--dim);font-size:13px}
input[type=range]{width:100%;accent-color:var(--accent)}
input[type=number],input[type=text]{background:#0f1216;border:1px solid var(--line);color:var(--text);border-radius:6px;padding:5px 8px;font:inherit;width:100%}
button{background:#0f1216;border:1px solid var(--line);color:var(--text);border-radius:6px;padding:6px 12px;font:inherit;cursor:pointer}
button:hover{border-color:var(--accent)}
button.primary{background:var(--accent);border-color:var(--accent);color:#1a1205;font-weight:600}
.right{margin-left:auto;display:flex;gap:8px}
.muted{color:var(--dim)}
.bar{height:6px;background:#0f1216;border-radius:3px;overflow:hidden}
.bar i{display:block;height:100%;background:var(--accent)}
.dmx{display:grid;grid-template-columns:repeat(auto-fill,minmax(74px,1fr));gap:8px}
.dmx div{background:#0f1216;border:1px solid var(--line);border-radius:6px;padding:6px}
.dmx span{font-size:11px;color:var(--dim)}
.saved{color:var(--ok)}
</style>
</head>
<body>
<header>
  <h1>WeekOff Bridge</h1>
  <span class="pill">dia <b id="slide">–</b></span>
  <span class="pill">tags <b id="tags">–</b></span>
  <span class="pill">MIDI <b id="midi">–</b></span>
  <span class="pill">uitvoer
    <select id="backend" style="background:none;border:0;color:var(--text);font:inherit">
      <option value="qlab">QLab</option><option value="artnet">Art-Net</option><option value="both">Allebei</option>
    </select>
  </span>
  <span class="right"><button id="save" class="primary">Opslaan</button> <span id="savedNote" class="muted"></span></span>
</header>
<main>
  <section>
    <h2>Scenes</h2>
    <div id="scenes"></div>
    <button id="addScene">Scene toevoegen</button>
  </section>
  <section>
    <h2>Live DMX</h2>
    <div class="dmx" id="dmx"></div>
  </section>
</main>
<script>
let config = null, dirty = false;

async function load() {
  config = await (await fetch('/api/config')).json();
  renderScenes();
}

function fixtureParams() {
  const out = [];
  for (const [name, fx] of Object.entries(config.fixtures)) {
    for (const ch of fx.channels) out.push(name + '.' + ch);
  }
  return out.sort();
}

function renderScenes() {
  const host = document.getElementById('scenes');
  host.innerHTML = '';
  for (const tag of Object.keys(config.scenes).sort()) {
    const scene = config.scenes[tag];
    const box = document.createElement('div');
    box.className = 'scene';
    const head = document.createElement('div');
    head.className = 'scene-head';
    head.innerHTML = '<span class="tag">#' + tag + '</span>';

    const fade = document.createElement('input');
    fade.type = 'number'; fade.step = '0.1'; fade.min = '0'; fade.value = scene.fade;
    fade.style.width = '70px';
    fade.oninput = () => { scene.fade = parseFloat(fade.value) || 0; markDirty(); };
    const fadeLabel = document.createElement('label');
    fadeLabel.textContent = 'fade (s)';
    head.append(fadeLabel, fade);

    const actions = document.createElement('span');
    actions.className = 'right';
    const test = document.createElement('button');
    test.textContent = 'Testen';
    test.onclick = async () => {
      const r = await (await fetch('/api/preview', {method:'POST', body: JSON.stringify({tag})})).json();
      const note = document.getElementById('savedNote');
      if (!r.artnet) { note.textContent = 'zet uitvoer op Art-Net om te zien'; note.className = 'muted'; }
    };
    const del = document.createElement('button');
    del.textContent = 'Verwijderen';
    del.onclick = () => { delete config.scenes[tag]; markDirty(); renderScenes(); };
    actions.append(test, del);
    head.append(actions);
    box.append(head);

    for (const path of fixtureParams()) {
      const value = scene.values[path] ?? 0;
      const row = document.createElement('div');
      row.className = 'row';
      const label = document.createElement('label');
      label.textContent = path;
      const range = document.createElement('input');
      range.type = 'range'; range.min = 0; range.max = 100; range.value = value;
      const num = document.createElement('input');
      num.type = 'number'; num.min = 0; num.max = 100; num.value = value;
      const sync = v => {
        range.value = v; num.value = v;
        if (Number(v) === 0) delete scene.values[path]; else scene.values[path] = Number(v);
        markDirty();
      };
      range.oninput = () => sync(range.value);
      num.oninput = () => sync(num.value);
      row.append(label, range, num);
      box.append(row);
    }
    host.append(box);
  }
}

function markDirty() {
  dirty = true;
  document.getElementById('savedNote').textContent = 'niet opgeslagen';
  document.getElementById('savedNote').className = 'muted';
}

document.getElementById('addScene').onclick = () => {
  const tag = prompt('Tag (zonder #)');
  if (!tag) return;
  config.scenes[tag.toLowerCase()] = { fade: 2, values: {} };
  markDirty(); renderScenes();
};

document.getElementById('save').onclick = async () => {
  await fetch('/api/config', {method:'PUT', body: JSON.stringify(config)});
  dirty = false;
  const note = document.getElementById('savedNote');
  note.textContent = 'opgeslagen'; note.className = 'saved';
  setTimeout(() => note.textContent = '', 2000);
};

document.getElementById('backend').onchange = e =>
  fetch('/api/backend', {method:'POST', body: JSON.stringify({backend: e.target.value})});

async function poll() {
  try {
    const s = await (await fetch('/api/state')).json();
    document.getElementById('slide').textContent = s.slide ?? '–';
    document.getElementById('tags').textContent = s.tags.length ? s.tags.join(' ') : '–';
    document.getElementById('midi').textContent = s.midi + ' bron(nen)';
    const sel = document.getElementById('backend');
    if (document.activeElement !== sel) sel.value = s.backend;

    const dmx = document.getElementById('dmx');
    if (dmx.children.length !== s.channels.length) {
      dmx.innerHTML = s.channels.map(c =>
        '<div><span>' + c.name + '</span><div class="bar"><i style="width:0%"></i></div></div>').join('');
    }
    s.channels.forEach((c, i) => {
      dmx.children[i].querySelector('i').style.width = Math.round(c.value / 255 * 100) + '%';
    });
    if (!dirty && JSON.stringify(s.config) !== JSON.stringify(config)) { config = s.config; renderScenes(); }
  } catch (e) {}
}

load();
setInterval(poll, 400);
</script>
</body>
</html>
"""
}
