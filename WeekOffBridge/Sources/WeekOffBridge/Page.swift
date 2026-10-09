enum Page {
    static let html = #"""
<!doctype html><html lang="nl"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1"><title>WeekOff</title>
<style>
@font-face{font-family:'Overused Grotesk';src:url('/fonts/OverusedGrotesk-VF.woff2') format('woff2-variations');font-weight:300 900;font-display:swap}
@font-face{font-family:'Feature Display';src:url('/fonts/FeatureDisplay-Light.woff2') format('woff2');font-weight:300;font-display:swap}
:root{--isit:#d1ff00;--pink:#dfa8ff;--blue:#00a1ff;--berry:#fffcf2;--blackish:#122222;--g800:#071717;--g400:#2a3838;--g300:#3e4948;--gray:#aaa;
--font:'Overused Grotesk',sans-serif;--display:'Feature Display',serif;--ls:calc(-0.2px + -0.015em)}
*{box-sizing:border-box}
body{margin:0;background:var(--g800);color:var(--berry);font-family:var(--font);font-weight:350;letter-spacing:var(--ls);font-size:16px;line-height:1.5}
h1,h2,h3{font-family:var(--display);font-weight:300;margin:0}
header{padding:18px 30px;border-bottom:1px solid var(--g400);display:flex;align-items:center;gap:20px;position:sticky;top:0;background:var(--g800);z-index:9}
h1{font-size:21px}
nav{display:flex;gap:6px}
nav span{padding:7px 16px;border-radius:999px;font-size:14px;color:var(--gray);cursor:pointer;border:1px solid transparent}
nav span.sel{color:var(--isit);border-color:var(--isit)}
.status{margin-left:auto;display:flex;gap:12px;align-items:center;font-size:14px;color:var(--gray)}
.status b{color:var(--berry);font-weight:450}
.dot{width:9px;height:9px;border-radius:50%;background:var(--isit);box-shadow:0 0 12px var(--isit)}
.dot.off{background:var(--g300);box-shadow:none}
button{background:transparent;border:1px solid var(--g300);color:var(--berry);border-radius:999px;padding:8px 16px;font:inherit;font-size:14px;letter-spacing:var(--ls);cursor:pointer}
button:hover{border-color:var(--isit)}
button.p{background:var(--isit);border-color:var(--isit);color:var(--g800);font-weight:500}
button.sel{border-color:var(--isit);color:var(--isit)}
button.sm{padding:5px 12px;font-size:13px}
main{padding:28px 30px 160px;max-width:1080px;margin:0 auto}
.lead{color:var(--gray);margin:0 0 22px;font-size:17px}
.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(250px,1fr));gap:16px}
.scene{background:var(--blackish);border:1px solid var(--g400);border-radius:16px;overflow:hidden;cursor:pointer;transition:.15s}
.scene:hover{border-color:var(--isit);transform:translateY(-2px)}
.scene.actief{border-color:var(--isit);box-shadow:0 0 0 1px var(--isit)}
.prev{height:96px;display:flex;gap:2px}.prev span{flex:1}
.sbody{padding:14px 16px}
.sname{font-family:var(--display);font-size:21px;display:flex;align-items:center;gap:9px}
.badge{font-family:var(--font);font-size:11px;background:var(--isit);color:var(--g800);border-radius:999px;padding:2px 9px;font-weight:500;letter-spacing:0}
.meta{color:var(--gray);font-size:13px;margin-top:5px;display:flex;gap:12px;flex-wrap:wrap}
.add{border:1px dashed var(--g300);border-radius:16px;display:grid;place-items:center;color:var(--gray);min-height:180px;cursor:pointer}
.add:hover{border-color:var(--isit);color:var(--isit)}
.pads{display:grid;grid-template-columns:repeat(4,1fr);gap:13px;max-width:600px}
.pad{aspect-ratio:1;border-radius:16px;border:1px solid var(--g400);background:var(--blackish);padding:13px;display:flex;flex-direction:column;cursor:pointer;transition:.12s}
.pad:hover{border-color:var(--isit);transform:translateY(-2px)}
.pad.leeg{border-style:dashed;color:var(--gray);align-items:center;justify-content:center;font-size:14px}
.pad .nm{margin-top:auto;font-size:15px;line-height:1.25}
.pad .sub{font-size:12px;color:var(--gray);margin-top:3px}
.pad.apparaat{border-color:var(--pink)}.pad.apparaat .nm{color:var(--pink)}
.pad.aan{border-color:var(--isit);box-shadow:0 0 0 1px var(--isit),0 0 24px #d1ff0033}
.banks{display:flex;gap:8px;margin-bottom:18px;align-items:center}
.sheet{position:fixed;inset:auto 0 0 0;background:var(--blackish);border-top:1px solid var(--g400);border-radius:20px 20px 0 0;padding:22px 30px;box-shadow:0 -24px 70px #000a;max-height:72vh;overflow:auto}
.sheet h2{font-size:26px}
.sub{color:var(--gray);font-size:14px;margin:2px 0 18px}
.cols{display:grid;grid-template-columns:repeat(auto-fit,minmax(230px,1fr));gap:15px}
.box{background:var(--g800);border:1px solid var(--g400);border-radius:14px;padding:15px}
.box h3{font-size:17px;margin-bottom:2px}.box p{margin:0 0 12px;color:var(--gray);font-size:13px}
.sw{width:30px;height:30px;border-radius:9px;border:2px solid transparent;cursor:pointer}
.sw.aan{border-color:var(--berry)}
.swatches{display:flex;gap:7px;margin-bottom:12px;flex-wrap:wrap}
input[type=range]{width:100%;accent-color:var(--isit);margin:10px 0 2px}
input[type=text],input[type=number]{background:var(--g800);border:1px solid var(--g300);color:var(--berry);border-radius:8px;padding:7px 10px;font:inherit;font-size:14px;letter-spacing:var(--ls);width:100%}
.row{display:flex;justify-content:space-between;font-size:13px;color:var(--gray)}
.toggle{width:46px;height:26px;background:var(--g300);border-radius:999px;position:relative;cursor:pointer;flex:none}
.toggle.aan{background:var(--isit)}
.toggle i{position:absolute;top:3px;left:3px;width:20px;height:20px;border-radius:50%;background:var(--berry);transition:.12s}
.toggle.aan i{left:23px}
.foot{display:flex;gap:9px;margin-top:18px;align-items:center;flex-wrap:wrap}
.spacer{margin-left:auto}
.choice{display:flex;gap:8px;flex-wrap:wrap}
.key{font-family:'SF Mono',monospace;font-size:12px;color:var(--gray);background:#ffffff08;border:1px solid var(--g300);border-radius:7px;padding:4px 9px}
.backdrop{position:fixed;inset:0;background:#000b;display:grid;place-items:center;padding:24px;z-index:20}
.modal{width:min(900px,100%);background:var(--blackish);border:1px solid var(--g400);border-radius:20px;max-height:86vh;overflow:auto}
.mhead{padding:20px 26px;border-bottom:1px solid var(--g400);display:flex;align-items:center;gap:14px}
.mhead h2{font-size:25px}.mhead p{margin:0;color:var(--gray);font-size:13px}
table{width:100%;border-collapse:collapse;font-size:14px}
th{text-align:left;font-weight:450;color:var(--gray);font-size:11px;text-transform:uppercase;letter-spacing:.06em;padding:0 8px 9px}
td{padding:8px;border-top:1px solid var(--g400)}
.mono{font-family:'SF Mono',monospace;font-size:13px;color:var(--gray)}
.bar{height:6px;background:var(--g800);border-radius:999px;overflow:hidden;min-width:70px}
.bar i{display:block;height:100%;background:var(--isit)}
.hint{color:var(--gray);font-size:13px;margin:14px 0 0}
.hidden{display:none!important}
</style></head><body>
<header>
  <h1>WeekOff</h1>
  <nav><span id="tab-scenes" class="sel">Scenes</span><span id="tab-pads">Soundboard</span></nav>
  <div class="status"><span class="dot" id="live"></span><span id="statusText">–</span><button id="openTech">⚙ Techniek</button><button id="save" class="p">Opslaan</button><span id="note"></span></div>
</header>
<main>
  <div id="view-scenes">
    <p class="lead">Elke scene hoort bij een dia. Klik op een scene om hem aan te passen.</p>
    <div class="grid" id="scenes"></div>
  </div>
  <div id="view-pads" class="hidden">
    <p class="lead">Elke knop hieronder is een pad op het kastje. Klik om te wijzigen.</p>
    <div class="banks" id="banks"></div>
    <div class="pads" id="padgrid"></div>
  </div>
</main>
<div id="sheet"></div>
<div id="tech" class="hidden"></div>
<script>
let config = null, state = {}, dirty = false, tab = 'scenes', bank = 0, open = null, learning = null;
let sigScenes = '', sigPads = '';

const el = (t, p = {}, k = []) => { const n = Object.assign(document.createElement(t), p); k.forEach(c => c && n.append(c)); return n; };
const setNote = (t, c = 'gray') => { const n = document.getElementById('note'); n.textContent = t; n.style.color = c === 'ok' ? 'var(--isit)' : 'var(--gray)'; };
const dirtyNow = () => { dirty = true; setNote('niet opgeslagen'); };
const midi = () => config.midi || {origin: 36, padsPerBank: 16, banks: 3};
const fixtureList = () => Object.entries(config.fixtures).map(([id, f]) => ({id, ...f, naam: f.label || id.charAt(0).toUpperCase() + id.slice(1)}));
const kind = f => f.kind || (f.channels.includes('red') ? 'rgb' : f.channels.includes('warm') ? 'warmcool' : f.channels.length === 1 ? 'schakelaar' : 'dimmer');

const COLORS = [['#e23b3b','rood'],['#ff7a1a','oranje'],['#d1ff00','lime'],['#2fbf71','groen'],['#00a1ff','blauw'],['#dfa8ff','roze'],['#fffcf2','wit']];
const hex2rgb = h => [1,3,5].map(i => parseInt(h.slice(i, i + 2), 16) / 255);

function sceneColor(scene, f) {
  const v = p => scene.values[f.id + '.' + p] ?? 0;
  if (kind(f) === 'rgb') {
    const m = Math.max(v('red'), v('green'), v('blue'));
    if (!m) return '#101c1c';
    return 'rgb(' + [v('red'), v('green'), v('blue')].map(x => Math.round(x / 100 * 255)).join(',') + ')';
  }
  if (kind(f) === 'warmcool') {
    const w = v('warm'), c = v('cool'), m = Math.max(w, c);
    if (!m) return '#101c1c';
    const mix = c / (w + c || 1);
    return 'rgb(' + [255, Math.round(210 + 30 * mix), Math.round(167 + 88 * mix)].join(',') + ')';
  }
  return v(f.channels[0]) > 0 ? '#dfa8ff' : '#101c1c';
}

function updateLiveScenes() {
  const live = state.tags || [];
  document.querySelectorAll('#scenes .scene').forEach(card => {
    const on = live.includes(card.dataset.tag);
    card.classList.toggle('actief', on);
    const name = card.querySelector('.sname');
    const badge = name.querySelector('.badge');
    if (on && !badge) name.append(el('span', {className: 'badge', textContent: 'speelt nu'}));
    if (!on && badge) badge.remove();
  });
}

function renderScenes() {
  const host = document.getElementById('scenes');
  host.innerHTML = '';
  for (const tag of Object.keys(config.scenes).sort()) {
    const scene = config.scenes[tag];
    const live = (state.tags || []).includes(tag);
    const card = el('div', {className: 'scene' + (live ? ' actief' : '')});
    card.dataset.tag = tag;
    card.onclick = () => { open = {type: 'scene', id: tag}; renderSheet(); };
    const prev = el('div', {className: 'prev'});
    fixtureList().forEach(f => prev.append(el('span', {style: 'background:' + sceneColor(scene, f)})));
    const aantal = fixtureList().filter(f => f.channels.some(c => (scene.values[f.id + '.' + c] ?? 0) > 0)).length;
    card.append(prev, el('div', {className: 'sbody'}, [
      el('div', {className: 'sname'}, [document.createTextNode(tag), live ? el('span', {className: 'badge', textContent: 'speelt nu'}) : null]),
      el('div', {className: 'meta'}, [el('span', {textContent: aantal + ' lamp' + (aantal === 1 ? '' : 'en')}), el('span', {textContent: scene.fade + ' sec overgang'})]),
    ]));
    host.append(card);
  }
  sigScenes = JSON.stringify(config.scenes) + JSON.stringify(config.fixtures);
  const add = el('div', {className: 'add', textContent: '+ Nieuwe scene'});
  add.onclick = () => {
    const naam = prompt('Naam van de scene (dit is ook de #tag in Keynote)');
    if (!naam) return;
    const key = naam.trim().toLowerCase().replace(/^#/, '').replace(/[^a-z0-9_.-]/g, '');
    if (!key || config.scenes[key]) return;
    config.scenes[key] = {fade: 2, values: {}};
    dirtyNow(); renderScenes();
  };
  host.append(add);
}

function padKeyFor(index) { return String(midi().origin + bank * midi().padsPerBank + index); }
function padFor(index) {
  const note = midi().origin + bank * midi().padsPerBank + index;
  const pads = config.pads || {};
  return pads[String(note)] ? {key: String(note), pad: pads[String(note)]} :
    Object.entries(pads).map(([k, p]) => ({key: k, pad: p})).find(e => e.key.endsWith(':' + note)) || null;
}

function renderPads() {
  sigPads = JSON.stringify(config.pads) + bank + JSON.stringify(state.held || []);
  const banks = document.getElementById('banks');
  banks.innerHTML = '';
  banks.append(el('span', {textContent: 'bank', style: 'color:var(--gray);font-size:14px'}));
  for (let b = 0; b < midi().banks; b++) {
    const btn = el('button', {textContent: String(b + 1), className: b === bank ? 'p' : ''});
    btn.onclick = () => { bank = b; renderPads(); };
    banks.append(btn);
  }
  const grid = document.getElementById('padgrid');
  grid.innerHTML = '';
  for (let i = 0; i < midi().padsPerBank; i++) {
    const found = padFor(i);
    const held = (state.held || []).some(h => h.endsWith(':' + padKeyFor(i)) || h === padKeyFor(i));
    if (!found) {
      const empty = el('div', {className: 'pad leeg', textContent: '+ leeg'});
      empty.onclick = () => {
        config.pads = config.pads || {};
        config.pads[padKeyFor(i)] = {label: 'Nieuw', mode: 'hold', dmx: {}};
        dirtyNow(); renderPads();
        open = {type: 'pad', id: padKeyFor(i)}; renderSheet();
      };
      grid.append(empty);
      continue;
    }
    const {key, pad} = found;
    const isApparaat = pad.dmx && Object.keys(pad.dmx).length;
    const card = el('div', {className: 'pad' + (isApparaat ? ' apparaat' : '') + (held ? ' aan' : '')});
    card.onclick = () => { open = {type: 'pad', id: key}; renderSheet(); };
    card.append(
      el('span', {className: 'nm', textContent: pad.label || (pad.sample || '').split('/').pop() || 'Pad'}),
      el('span', {className: 'sub', textContent: isApparaat ? (pad.mode === 'toggle' ? 'aan-uit schakelen' : 'zolang ingedrukt') : 'geluid'})
    );
    grid.append(card);
  }
}

function deviceBox(f, values) {
  const box = el('div', {className: 'box'});
  box.append(el('h3', {textContent: f.naam}), el('p', {textContent: f.note || ''}));
  const set = (ch, v) => { if (v > 0) values[f.id + '.' + ch] = v; else delete values[f.id + '.' + ch]; dirtyNow(); };
  const get = ch => values[f.id + '.' + ch] ?? 0;
  const k = kind(f);

  if (k === 'rgb') {
    const sw = el('div', {className: 'swatches'});
    const current = [get('red'), get('green'), get('blue')];
    COLORS.forEach(([hex, naam]) => {
      const [r, g, b] = hex2rgb(hex);
      const dot = el('div', {className: 'sw', title: naam, style: 'background:' + hex});
      const bright = Math.max(...current) || 100;
      if (Math.max(...current) > 0 && Math.abs(current[0] - r * bright) < 6 && Math.abs(current[1] - g * bright) < 6 && Math.abs(current[2] - b * bright) < 6) dot.classList.add('aan');
      dot.onclick = () => {
        const level = Math.max(...[get('red'), get('green'), get('blue')]) || 100;
        set('red', Math.round(r * level)); set('green', Math.round(g * level)); set('blue', Math.round(b * level));
        renderSheet();
      };
      sw.append(dot);
    });
    box.append(sw);
    const level = Math.max(get('red'), get('green'), get('blue'));
    const range = el('input', {type: 'range', min: 0, max: 100, value: level});
    range.oninput = () => {
      const was = Math.max(get('red'), get('green'), get('blue')) || 100;
      const factor = range.value / (was || 100);
      ['red', 'green', 'blue'].forEach(c => set(c, Math.round((get(c) || (was ? 0 : 100)) * factor)));
      if (Number(range.value) > 0 && !get('red') && !get('green') && !get('blue')) ['red','green','blue'].forEach(c => set(c, Number(range.value)));
      box.querySelector('.row span:last-child').textContent = range.value + '%';
    };
    box.append(range, el('div', {className: 'row'}, [el('span', {textContent: 'helderheid'}), el('span', {textContent: level + '%'})]));
  } else if (k === 'warmcool') {
    const level = Math.max(get('warm'), get('cool'));
    const mix = (get('cool') / (get('warm') + get('cool') || 1)) * 100;
    const b = el('input', {type: 'range', min: 0, max: 100, value: level});
    const m = el('input', {type: 'range', min: 0, max: 100, value: Math.round(mix)});
    const apply = () => {
      const L = Number(b.value), M = Number(m.value) / 100;
      set('warm', Math.round(L * (1 - M))); set('cool', Math.round(L * M));
      box.querySelectorAll('.row span:last-child')[0].textContent = L + '%';
      box.querySelectorAll('.row span:last-child')[1].textContent = M < .34 ? 'warm' : M > .66 ? 'koel' : 'neutraal';
    };
    b.oninput = apply; m.oninput = apply;
    box.append(b, el('div', {className: 'row'}, [el('span', {textContent: 'helderheid'}), el('span', {textContent: level + '%'})]),
      m, el('div', {className: 'row'}, [el('span', {textContent: 'warm ↔ koel'}), el('span', {textContent: mix < 34 ? 'warm' : mix > 66 ? 'koel' : 'neutraal'})]));
  } else {
    const ch = f.channels[0];
    const on = get(ch) > 0;
    const t = el('div', {className: 'toggle' + (on ? ' aan' : '')}, [el('i')]);
    t.onclick = () => { set(ch, on ? 0 : 100); renderSheet(); };
    box.append(el('div', {style: 'display:flex;gap:12px;align-items:center;margin-top:16px'}, [t, el('span', {className: 'sub', textContent: on ? 'aan in deze scene' : 'uit in deze scene', style: 'margin:0'})]));
  }
  return box;
}

function renderSheet() {
  const host = document.getElementById('sheet');
  host.innerHTML = '';
  if (!open) return;

  const sheet = el('div', {className: 'sheet'});
  if (open.type === 'scene') {
    const scene = config.scenes[open.id];
    if (!scene) { open = null; return; }
    sheet.append(el('h2', {textContent: open.id}), el('div', {className: 'sub', textContent: 'Start op de dia met #' + open.id + ' in de notities'}));
    const cols = el('div', {className: 'cols'});
    fixtureList().forEach(f => cols.append(deviceBox(f, scene.values)));
    sheet.append(cols);

    const foot = el('div', {className: 'foot'});
    foot.append(el('span', {textContent: 'overgang', style: 'color:var(--gray);font-size:14px'}));
    [0, 1, 2, 5].forEach(sec => {
      const b = el('button', {textContent: sec === 0 ? 'direct' : sec + ' sec', className: scene.fade === sec ? 'sel' : ''});
      b.onclick = () => { scene.fade = sec; dirtyNow(); renderSheet(); };
      foot.append(b);
    });
    const rename = el('button', {textContent: 'Naam wijzigen'});
    rename.onclick = () => {
      const n = prompt('Nieuwe naam', open.id);
      if (!n) return;
      const key = n.trim().toLowerCase().replace(/^#/, '').replace(/[^a-z0-9_.-]/g, '');
      if (!key || config.scenes[key]) return;
      config.scenes[key] = scene; delete config.scenes[open.id]; open.id = key;
      dirtyNow(); renderScenes(); renderSheet();
    };
    const del = el('button', {textContent: 'Verwijderen'});
    del.onclick = () => { delete config.scenes[open.id]; open = null; dirtyNow(); renderScenes(); renderSheet(); };
    const test = el('button', {textContent: 'Uitproberen'});
    test.onclick = async () => {
      const r = await (await fetch('/api/preview', {method: 'POST', body: JSON.stringify({tag: open.id})})).json();
      setNote(r.artnet ? 'scene speelt' : 'zet Art-Net aan in Techniek', r.artnet ? 'ok' : 'gray');
    };
    const done = el('button', {textContent: 'Klaar', className: 'p'});
    done.onclick = () => { open = null; renderSheet(); };
    foot.append(el('span', {className: 'spacer'}), rename, del, test, done);
    sheet.append(foot);
  } else {
    const pad = (config.pads || {})[open.id];
    if (!pad) { open = null; return; }
    const note = Number(open.id.split(':').pop());
    const idx = note - midi().origin;
    sheet.append(el('h2', {textContent: pad.label || 'Pad'}),
      el('div', {className: 'sub', textContent: 'Knop ' + (idx % midi().padsPerBank + 1) + ', bank ' + (Math.floor(idx / midi().padsPerBank) + 1)}));

    const cols = el('div', {className: 'cols'});
    const naam = el('input', {type: 'text', value: pad.label || ''});
    naam.oninput = () => { pad.label = naam.value; dirtyNow(); };
    const b1 = el('div', {className: 'box'}, [el('h3', {textContent: 'Naam'}), el('p', {textContent: 'zoals het op de knop staat'}), naam]);

    const isApparaat = pad.dmx && Object.keys(pad.dmx).length > 0;
    const soort = el('div', {className: 'choice'});
    ['Geluid', 'Apparaat'].forEach(s => {
      const b = el('button', {textContent: s, className: (s === 'Apparaat') === isApparaat ? 'sel' : ''});
      b.onclick = () => {
        if (s === 'Geluid') { pad.dmx = {}; } else { delete pad.sample; pad.dmx = pad.dmx || {}; }
        dirtyNow(); renderSheet();
      };
      soort.append(b);
    });
    const b2 = el('div', {className: 'box'}, [el('h3', {textContent: 'Wat doet deze knop?'}), el('p', {textContent: 'kies er één'}), soort]);

    const modus = el('div', {className: 'choice'});
    [['hold', 'Zolang ingedrukt'], ['toggle', 'Aan-uit schakelen']].forEach(([m, lbl]) => {
      const b = el('button', {textContent: lbl, className: (pad.mode || 'hold') === m ? 'sel' : ''});
      b.onclick = () => { pad.mode = m; dirtyNow(); renderSheet(); };
      modus.append(b);
    });
    const b3 = el('div', {className: 'box'}, [el('h3', {textContent: 'Hoe lang?'}), el('p', {textContent: 'bij loslaten'}), modus]);

    const leer = el('button', {textContent: learning ? 'Druk op een pad…' : 'Pad leren…', className: learning ? 'sel' : ''});
    leer.onclick = () => { learning = open.id; setNote('druk op een pad op het kastje'); renderSheet(); };
    const b4 = el('div', {className: 'box'}, [el('h3', {textContent: 'Welke knop?'}), el('p', {textContent: 'druk op het pad om te koppelen'}),
      el('div', {style: 'display:flex;gap:9px;align-items:center'}, [leer, el('span', {className: 'key', textContent: 'noot ' + note})])]);

    cols.append(b1, b2, b3, b4);
    if (!isApparaat) {
      const sample = el('input', {type: 'text', value: pad.sample || '', placeholder: '/pad/naar/geluid.mp3'});
      sample.onchange = () => { const v = sample.value.trim(); if (v) pad.sample = v; else delete pad.sample; dirtyNow(); };
      cols.append(el('div', {className: 'box'}, [el('h3', {textContent: 'Geluid'}), el('p', {textContent: 'bestand op deze computer'}), sample]));
    } else {
      fixtureList().forEach(f => cols.append(deviceBox(f, pad.dmx)));
    }
    sheet.append(cols);

    const foot = el('div', {className: 'foot'});
    const del = el('button', {textContent: 'Verwijderen'});
    del.onclick = () => { delete config.pads[open.id]; open = null; dirtyNow(); renderPads(); renderSheet(); };
    const test = el('button', {textContent: 'Uitproberen'});
    test.onclick = () => fetch('/api/pad', {method: 'POST', body: JSON.stringify({pad: open.id})});
    const done = el('button', {textContent: 'Klaar', className: 'p'});
    done.onclick = () => { open = null; learning = null; renderSheet(); };
    foot.append(del, el('span', {className: 'spacer'}), test, done);
    sheet.append(foot);
  }
  host.append(sheet);
}

function renderTech() {
  const host = document.getElementById('tech');
  host.className = '';
  host.innerHTML = '';
  const rows = el('table');
  rows.append(el('tr', {}, ['Naam', 'Soort', 'DMX-adres', 'Kanalen', 'Nu'].map(h => el('th', {textContent: h}))));
  fixtureList().forEach(f => {
    const naam = el('input', {type: 'text', value: f.naam});
    naam.onchange = () => { config.fixtures[f.id].label = naam.value; dirtyNow(); };
    const soort = el('input', {type: 'text', value: kind(f)});
    soort.onchange = () => { config.fixtures[f.id].kind = soort.value.trim(); dirtyNow(); };
    const adres = el('input', {type: 'number', min: 1, max: 512, value: f.address});
    adres.onchange = () => { config.fixtures[f.id].address = Number(adres.value); dirtyNow(); renderTech(); };
    const live = (state.channels || []).filter(c => c.name.startsWith(f.id + '.'));
    const meter = el('div', {className: 'bar'}, [el('i', {style: 'width:' + Math.round(Math.max(0, ...live.map(c => c.value)) / 255 * 100) + '%'})]);
    rows.append(el('tr', {}, [el('td', {}, [naam]), el('td', {}, [soort]), el('td', {}, [adres]),
      el('td', {className: 'mono', textContent: f.address + '–' + (f.address + f.channels.length - 1)}), el('td', {}, [meter])]));
  });

  const host2 = el('div', {className: 'backdrop'});
  const modal = el('div', {className: 'modal'});
  const close = el('button', {textContent: '✕'});
  close.onclick = () => { host.className = 'hidden'; };
  modal.append(el('div', {className: 'mhead'}, [
    el('div', {}, [el('h2', {textContent: 'Techniek'}), el('p', {textContent: 'Alleen nodig bij het opbouwen van de set'})]),
    el('span', {className: 'spacer'}), close]));

  const body = el('div', {style: 'padding:18px 26px 24px'});
  body.append(rows, el('p', {className: 'hint', textContent: 'Het DMX-adres stel je ook op de lamp zelf in. Staan ze niet gelijk, dan reageert de verkeerde lamp.'}));

  const host3 = el('div', {style: 'display:grid;grid-template-columns:1fr 1fr 1fr;gap:14px;margin-top:20px'});
  const ip = el('input', {type: 'text', value: config.artnet.host});
  ip.onchange = () => { config.artnet.host = ip.value.trim(); dirtyNow(); };
  const uni = el('input', {type: 'number', value: config.artnet.universe});
  uni.onchange = () => { config.artnet.universe = Number(uni.value); dirtyNow(); };
  const origin = el('input', {type: 'number', value: midi().origin});
  origin.onchange = () => { config.midi = {...midi(), origin: Number(origin.value)}; dirtyNow(); renderPads(); };
  host3.append(
    el('div', {}, [el('p', {className: 'hint', textContent: 'Art-Net apparaat', style: 'margin:0 0 6px'}), ip]),
    el('div', {}, [el('p', {className: 'hint', textContent: 'Universe', style: 'margin:0 0 6px'}), uni]),
    el('div', {}, [el('p', {className: 'hint', textContent: 'Eerste pad (MIDI-noot)', style: 'margin:0 0 6px'}), origin]));
  body.append(host3);

  const out = el('div', {className: 'foot'});
  ['qlab', 'artnet', 'both'].forEach(b => {
    const btn = el('button', {textContent: {qlab: 'QLab', artnet: 'Art-Net', both: 'Allebei'}[b], className: state.backend === b ? 'sel' : ''});
    btn.onclick = async () => { await fetch('/api/backend', {method: 'POST', body: JSON.stringify({backend: b})}); poll(); renderTech(); };
    out.append(btn);
  });
  body.append(el('p', {className: 'hint', textContent: 'Waar gaat het licht heen?'}), out);
  modal.append(body);
  host2.append(modal);
  host2.onclick = e => { if (e.target === host2) host.className = 'hidden'; };
  host.append(host2);
}

document.getElementById('tab-scenes').onclick = () => { tab = 'scenes'; syncTabs(); };
document.getElementById('tab-pads').onclick = () => { tab = 'pads'; syncTabs(); };
function syncTabs() {
  document.getElementById('tab-scenes').className = tab === 'scenes' ? 'sel' : '';
  document.getElementById('tab-pads').className = tab === 'pads' ? 'sel' : '';
  document.getElementById('view-scenes').className = tab === 'scenes' ? '' : 'hidden';
  document.getElementById('view-pads').className = tab === 'pads' ? '' : 'hidden';
  open = null; renderSheet();
}
document.getElementById('openTech').onclick = renderTech;
document.getElementById('save').onclick = async () => {
  const r = await fetch('/api/config', {method: 'PUT', body: JSON.stringify(config)});
  if (r.ok) { dirty = false; setNote('opgeslagen', 'ok'); setTimeout(() => setNote(''), 2000); } else setNote('opslaan mislukt');
};
window.onbeforeunload = e => { if (dirty) e.preventDefault(); };

async function poll() {
  try {
    state = await (await fetch('/api/state')).json();
    document.getElementById('live').className = 'dot' + (state.slide == null ? ' off' : '');
    document.getElementById('statusText').innerHTML = state.slide == null ? 'geen presentatie'
      : 'dia <b>' + state.slide + '</b>' + ((state.tags || []).length ? ' · <b>' + state.tags.join(' ') + '</b>' : '') + ' · MIDI <b>' + state.midi + '</b>';

    if (learning && state.lastNote && state.lastNote.age < 1.5) {
      const nieuw = String(state.lastNote.note);
      if (nieuw !== learning && !(config.pads || {})[nieuw]) {
        config.pads[nieuw] = config.pads[learning];
        delete config.pads[learning];
        if (open && open.id === learning) open.id = nieuw;
        learning = null; dirtyNow(); setNote('pad gekoppeld', 'ok'); renderPads(); renderSheet();
      }
    }
    const nextScenes = JSON.stringify(config.scenes) + JSON.stringify(config.fixtures);
    const nextPads = JSON.stringify(config.pads) + bank + JSON.stringify(state.held || []);
    if (tab === 'scenes') {
      if (nextScenes !== sigScenes) { sigScenes = nextScenes; renderScenes(); } else updateLiveScenes();
    } else if (nextPads !== sigPads) { sigPads = nextPads; renderPads(); }
    if (!dirty && JSON.stringify(state.config) !== JSON.stringify(config)) { config = state.config; renderSheet(); }
  } catch (e) {}
}

(async () => { config = await (await fetch('/api/config')).json(); renderScenes(); renderPads(); setInterval(poll, 500); poll(); })();
</script>
</body></html>
"""#
}
