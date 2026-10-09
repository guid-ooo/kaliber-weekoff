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
.rij{display:grid;grid-template-columns:170px 1fr 120px 130px;gap:16px;align-items:center;padding:12px 15px;border:1px solid var(--g400);
border-radius:13px;margin-bottom:8px;background:var(--blackish);cursor:pointer}
.rij:hover{border-color:var(--isit)}
.rij.actief{border-color:var(--isit);box-shadow:0 0 0 1px var(--isit)}
.rij .naam{font-family:var(--display);font-size:21px;display:flex;align-items:center;gap:8px}
.spoor{position:relative;height:28px;background:#0f1a1a;border-radius:8px;overflow:hidden}
.vlak{position:absolute;top:0;bottom:0;border-radius:8px;display:flex;align-items:center;padding:0 9px;font-size:12px;color:#0d1a1a;font-weight:500}
.lampjes{display:flex;gap:5px}
.lampjes i{width:24px;height:24px;border-radius:7px;display:block}
.rij .meta2{color:var(--gray);font-size:13px;text-align:right}
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
.kop{grid-column:1/-1;font-size:12px;text-transform:uppercase;letter-spacing:.07em;color:var(--gray);margin:14px 0 -4px}
.kop.klik{cursor:pointer;user-select:none}
.kop.klik:hover{color:var(--isit)}
.scene.dof{opacity:.62}
.scene.dof:hover{opacity:1}
.add{border:1px dashed var(--g300);border-radius:16px;display:grid;place-items:center;color:var(--gray);min-height:180px;cursor:pointer}
.add:hover{border-color:var(--isit);color:var(--isit)}
.pads{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:13px;max-width:600px;margin:0 auto}
#view-pads>.lead,#view-pads>.banks{max-width:600px;margin-left:auto;margin-right:auto}
.pad{aspect-ratio:1;min-height:0;overflow:hidden;border-radius:16px;border:1px solid var(--g400);background:var(--blackish);padding:13px;display:flex;flex-direction:column;cursor:pointer;transition:.12s}
.pad:hover{border-color:var(--isit);transform:translateY(-2px)}
.pad.leeg{border-style:dashed;color:var(--gray);align-items:center;justify-content:center;font-size:14px}
.pad .teken{font-size:17px;line-height:1;opacity:.75}
.pad .nm{margin-top:auto;font-size:15px;line-height:1.2;overflow-wrap:anywhere;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden}
.pad .sub{font-size:12px;color:var(--gray);margin-top:3px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.pad.apparaat .nm{color:var(--pink)}
.pad.aan{border-color:var(--isit);box-shadow:0 0 0 1px var(--isit),0 0 24px #d1ff0033}
.pad[draggable]{cursor:grab}
.pad.sleep{opacity:.4;cursor:grabbing}
.pad.doel{border-color:var(--isit);border-style:solid;background:#d1ff000f}
.banks{display:flex;gap:8px;margin-bottom:18px;align-items:center}
.sheet{position:fixed;inset:auto 0 0 0;background:var(--blackish);border-top:1px solid var(--g400);border-radius:20px 20px 0 0;padding:22px 30px;box-shadow:0 -24px 70px #000a;max-height:72vh;overflow:auto}
.sheet h2{font-size:26px}
.titelrij{display:flex;align-items:center;gap:10px}
.potlood{border:1px solid transparent;color:var(--gray);border-radius:999px;width:32px;height:32px;padding:0;font-size:15px;line-height:1}
.potlood:hover{border-color:var(--isit);color:var(--isit)}
.sub{color:var(--gray);font-size:14px;margin:2px 0 18px}
.cols{display:grid;grid-template-columns:repeat(auto-fit,minmax(230px,1fr));gap:15px}
.box{background:var(--g800);border:1px solid var(--g400);border-radius:14px;padding:15px}
.box h3{font-size:17px;margin-bottom:2px}.box p{margin:0 0 12px;color:var(--gray);font-size:13px}
.sw{width:30px;height:30px;border-radius:9px;border:2px solid transparent;cursor:pointer}
.sw.aan{border-color:var(--berry)}
.swatches{display:flex;gap:7px;margin-bottom:12px;flex-wrap:wrap}
.sw.meer{background:conic-gradient(from 0deg,#f00,#ff0,#0f0,#0ff,#00f,#f0f,#f00);border-color:var(--g300);
box-shadow:inset 0 0 0 2px var(--blackish);opacity:.85;transition:.12s}
.sw.meer:hover{opacity:1;border-color:var(--gray)}
.sw.meer.aan{border-color:var(--berry);opacity:1;box-shadow:inset 0 0 0 2px var(--blackish)}
.wheel{width:132px;height:132px;border-radius:50%;margin:4px auto 10px;position:relative;cursor:crosshair;border:1px solid var(--g300);
background:radial-gradient(circle,#fff 0%,#fff0 70%),conic-gradient(from 90deg,#f00,#ff0,#0f0,#0ff,#00f,#f0f,#f00)}
.wheel i{position:absolute;width:16px;height:16px;margin:-8px 0 0 -8px;border-radius:50%;border:2px solid #fff;box-shadow:0 0 0 1px #0008;pointer-events:none}
input[type=range]{width:100%;accent-color:var(--isit);margin:10px 0 2px}
select{background:var(--g800);border:1px solid var(--g300);color:var(--berry);border-radius:8px;padding:6px 9px;font:inherit;font-size:14px}
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
  <nav><span id="tab-scenes" class="sel">Scenes</span><span id="tab-pads">Soundboard</span><span id="tab-tijd">Tijdlijn</span></nav>
  <div class="status"><span class="dot" id="live"></span><span id="statusText">–</span><button id="panic" title="alles uit">Alles uit</button><button id="openTech">⚙ Techniek</button><span id="note"></span></div>
</header>
<main>
  <div id="view-scenes">
    <p class="lead">Elke scene hoort bij een dia. Klik op een scene om hem aan te passen.</p>
    <div class="grid" id="scenes"></div>
  </div>
  <div id="view-pads" class="hidden">
    <p class="lead">Elke knop is een pad op het kastje. Sleep om te verplaatsen, klik om te wijzigen.</p>
    <div class="banks" id="banks"></div>
    <div class="pads" id="padgrid"></div>
  </div>
  <div id="view-tijd" class="hidden">
    <p class="lead">Elke scene over de lengte van de presentatie.</p>
    <div id="tijdlijn"></div>
  </div>
</main>
<div id="sheet"></div>
<div id="tech" class="hidden"></div>
<script>
let config = null, state = {}, dirty = false, bank = 0, open = null, learning = null;
let sigScenes = '', sigPads = '', sigSheet = '', sigTijd = '', wheelOpen = {}, techOpen = {}, techZichtbaar = false, tab = 'scenes';

const stable = v => {
  if (v === null || typeof v !== 'object') return JSON.stringify(v);
  if (Array.isArray(v)) return '[' + v.map(stable).join(',') + ']';
  return '{' + Object.keys(v).sort().map(k => JSON.stringify(k) + ':' + stable(v[k])).join(',') + '}';
};
const el = (t, p = {}, k = []) => { const n = Object.assign(document.createElement(t), p); k.forEach(c => c && n.append(c)); return n; };
const setNote = (t, c = 'gray') => { const n = document.getElementById('note'); n.textContent = t; n.style.color = c === 'ok' ? 'var(--isit)' : 'var(--gray)'; };
let saveTimer = null;
async function bewaar() {
  const r = await fetch('/api/config', {method: 'PUT', body: JSON.stringify(config)});
  if (r.ok) { dirty = false; setNote('opgeslagen', 'ok'); setTimeout(() => { if (!dirty) setNote(''); }, 1500); }
  else setNote('opslaan mislukt');
}
const dirtyNow = () => {
  dirty = true;
  if (open) { setNote('nog niet bewaard'); return; }
  setNote('bewaren…');
  clearTimeout(saveTimer);
  saveTimer = setTimeout(bewaar, 600);
};
async function sluit() {
  const moest = dirty;
  open = null; learning = null;
  navigeer();
  if (moest) await bewaar();
  sigScenes = ''; sigPads = '';
  renderSheet();
  renderScenes();
  renderPads();
  renderTijdlijn();
}
const midi = () => config.midi || {origin: 36, padsPerBank: 16, banks: 3};
const fixtureAll = () => Object.entries(config.fixtures).map(([id, f]) => ({id, ...f, naam: f.label || id.charAt(0).toUpperCase() + id.slice(1)}));
const fixtureList = (waar = 'scenes') => fixtureAll().filter(f => waar === 'scenes' ? f.inScenes !== false : f.inPads !== false);
const padIsApparaat = p => p.type ? p.type === 'apparaat' : !!(p.dmx && Object.keys(p.dmx).length);
const kind = f => f.kind || (f.channels.includes('red') ? 'rgb' : f.channels.includes('warm') ? 'warmcool' : f.channels.length === 1 ? 'schakelaar' : 'dimmer');

const KANAALNAMEN = [
  ['red', 'rood'], ['green', 'groen'], ['blue', 'blauw'], ['white', 'wit'], ['amber', 'amber'],
  ['warm', 'warm wit'], ['cool', 'koel wit'], ['intensity', 'helderheid'], ['dimmer', 'dimmer'],
  ['strobe', 'strobe'], ['rook', 'rook'], ['pan', 'pan'], ['tilt', 'tilt'], ['', 'niet gebruikt'],
];
const kanaalLabel = n => (KANAALNAMEN.find(([k]) => k === n) || [n, n])[1];
const GEBRUIKT = {rgb: ['red', 'green', 'blue'], warmcool: ['warm', 'cool'], schakelaar: [], dimmer: []};

function hernoemKanaal(fixtureId, oud, nieuw) {
  const vervang = obj => {
    if (!obj) return;
    const van = fixtureId + '.' + oud, naar = fixtureId + '.' + nieuw;
    if (obj[van] === undefined) return;
    if (nieuw) obj[naar] = obj[van];
    delete obj[van];
  };
  Object.values(config.scenes).forEach(sc => vervang(sc.values));
  Object.values(config.pads || {}).forEach(p => vervang(p.dmx));
}

const COLORS = [['#e23b3b','rood'],['#ff7a1a','oranje'],['#d1ff00','lime'],['#2fbf71','groen'],['#00a1ff','blauw'],['#dfa8ff','roze'],['#fffcf2','wit']];
const hex2rgb = h => [1,3,5].map(i => parseInt(h.slice(i, i + 2), 16) / 255);
const hsv2rgb = (h, s) => {
  const f = n => { const k = (n + h / 60) % 6; return 1 - s * Math.max(0, Math.min(k, 4 - k, 1)); };
  return [f(5), f(3), f(1)];
};
const rgb2hs = (r, g, b) => {
  const max = Math.max(r, g, b), min = Math.min(r, g, b), d = max - min;
  if (!max) return [0, 0];
  let h = 0;
  if (d) h = max === r ? 60 * (((g - b) / d) % 6) : max === g ? 60 * ((b - r) / d + 2) : 60 * ((r - g) / d + 4);
  return [(h + 360) % 360, d / max];
};

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

function bereik(tag) {
  const getagd = state.getagd || [], totaal = state.diaTotaal || 0;
  const stukken = [];
  getagd.forEach((g, i) => {
    if (!g.tags.includes(tag)) return;
    const volgende = getagd.slice(i + 1).find(v => !v.tags.includes(tag));
    const eind = volgende ? volgende.slide - 1 : totaal;
    const vorige = stukken[stukken.length - 1];
    if (vorige && vorige[1] >= g.slide - 1) vorige[1] = Math.max(vorige[1], eind);
    else stukken.push([g.slide, eind]);
  });
  if (!stukken.length) return null;
  return stukken.map(([a, b]) => a === b ? 'dia ' + a : 'dia ' + a + '–' + b).join(', ');
}

function sceneVolgorde() {
  const deck = state.deck || [];
  const inDeck = deck.map(d => d.tag).filter(t => config.scenes[t]);
  const origins = state.origins || {};
  const herkomst = {};
  for (const [presentatie, tags] of Object.entries(origins))
    for (const t of tags) if (!inDeck.includes(t) && config.scenes[t]) herkomst[t] = presentatie;
  const elders = Object.keys(herkomst).sort();
  const rest = Object.keys(config.scenes).filter(t => !inDeck.includes(t) && !elders.includes(t)).sort();
  const ontbreekt = deck.filter(d => !config.scenes[d.tag]);
  return {inDeck, elders, herkomst, rest, ontbreekt, deck};
}

function renderScenes() {
  const host = document.getElementById('scenes');
  host.innerHTML = '';
  const {inDeck, elders, herkomst, rest, ontbreekt, deck} = sceneVolgorde();
  const dia = tag => (deck.find(d => d.tag === tag) || {}).slide;

  const dicht = JSON.parse(localStorage.getItem('dichtgeklapt') || '{}');
  const kop = (tekst, inklapbaar = false, aantal = 0) => {
    const open2 = !dicht[tekst];
    const h = el('div', {className: 'kop' + (inklapbaar ? ' klik' : '')});
    h.textContent = inklapbaar ? (open2 ? '▾ ' : '▸ ') + tekst + ' (' + aantal + ')' : tekst;
    if (inklapbaar) h.onclick = () => {
      dicht[tekst] = open2;
      localStorage.setItem('dichtgeklapt', JSON.stringify(dicht));
      sigScenes = ''; renderScenes();
    };
    host.append(h);
    return open2;
  };
  if (elders.length || rest.length) kop(state.deckName ? 'In ' + state.deckName : 'In deze presentatie');

  for (const tag of inDeck) {
    const scene = config.scenes[tag];
    const live = (state.tags || []).includes(tag);
    const card = el('div', {className: 'scene' + (live ? ' actief' : '')});
    card.dataset.tag = tag;
    card.onclick = () => { open = {type: 'scene', id: tag}; navigeer(); renderSheet(); };
    const prev = el('div', {className: 'prev'});
    fixtureList().forEach(f => prev.append(el('span', {style: 'background:' + sceneColor(scene, f)})));
    const aantal = fixtureList().filter(f => f.channels.some(c => (scene.values[f.id + '.' + c] ?? 0) > 0)).length;
    card.append(prev, el('div', {className: 'sbody'}, [
      el('div', {className: 'sname'}, [document.createTextNode(tag), live ? el('span', {className: 'badge', textContent: 'speelt nu'}) : null]),
      el('div', {className: 'meta'}, [
        el('span', {textContent: bereik(tag) || 'niet in de presentatie', style: bereik(tag) ? '' : 'color:#dfa8ff'}),
        el('span', {textContent: aantal + ' lamp' + (aantal === 1 ? '' : 'en')}),
        el('span', {textContent: scene.fade + ' sec overgang'})]),
    ]));
    host.append(card);
  }
  for (const d of ontbreekt) {
    const kaart = el('div', {className: 'add', style: 'min-height:150px;border-color:#dfa8ff55;color:#dfa8ff'});
    kaart.append(el('div', {style: 'text-align:center;line-height:1.4'}, [
      el('div', {textContent: '#' + d.tag}),
      el('div', {textContent: 'staat op dia ' + d.slide + ', nog geen scene', style: 'font-size:13px;opacity:.8'}),
      el('div', {textContent: 'klik om aan te maken', style: 'font-size:13px;opacity:.6'})]));
    kaart.onclick = () => {
      config.scenes[d.tag] = {fade: 2, values: {}};
      dirtyNow(); sigScenes = ''; renderScenes();
      open = {type: 'scene', id: d.tag}; navigeer(); renderSheet();
    };
    host.append(kaart);
  }

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

  for (const groep of [{titel: 'Uit andere presentaties', tags: elders}, {titel: 'Nergens gebruikt', tags: rest}]) {
    if (!groep.tags.length) continue;
    if (!kop(groep.titel, true, groep.tags.length)) continue;
    for (const tag of groep.tags) {
      const scene = config.scenes[tag];
      const card = el('div', {className: 'scene dof'});
      card.dataset.tag = tag;
      card.onclick = () => { open = {type: 'scene', id: tag}; navigeer(); renderSheet(); };
      const prev = el('div', {className: 'prev'});
      fixtureList().forEach(f => prev.append(el('span', {style: 'background:' + sceneColor(scene, f)})));
      card.append(prev, el('div', {className: 'sbody'}, [
        el('div', {className: 'sname'}, [document.createTextNode(tag)]),
        el('div', {className: 'meta'}, [el('span', {textContent: herkomst[tag] || 'geen presentatie', style: 'color:var(--pink)'})]),
      ]));
      host.append(card);
    }
  }

  sigScenes = stable(config.scenes) + stable(config.fixtures) + stable(state.getagd || []) + stable(state.deck || []) + stable(state.origins || {}) + (state.deckName || '');
}

function padKeyFor(index) { return String(midi().origin + bank * midi().padsPerBank + index); }
function padFor(index) {
  const note = midi().origin + bank * midi().padsPerBank + index;
  const pads = config.pads || {};
  return pads[String(note)] ? {key: String(note), pad: pads[String(note)]} :
    Object.entries(pads).map(([k, p]) => ({key: k, pad: p})).find(e => e.key.endsWith(':' + note)) || null;
}

function verplaatsPad(vanKey, naarNote) {
  const pads = config.pads || {};
  const bron = pads[vanKey];
  if (!bron) return;
  const kanaal = vanKey.includes(':') ? vanKey.split(':')[0] + ':' : '';
  const doelKey = Object.keys(pads).find(k => k === String(naarNote) || k.endsWith(':' + naarNote)) || (kanaal + naarNote);
  if (doelKey === vanKey) return;
  const doel = pads[doelKey];
  delete pads[vanKey];
  pads[doelKey] = bron;
  if (doel) pads[vanKey] = doel;
  dirtyNow(); sigPads = ''; renderPads();
}

function renderTijdlijn() {
  const host = document.getElementById('tijdlijn');
  if (!host || !config) return;
  host.innerHTML = '';
  const getagd = state.getagd || [], totaal = state.diaTotaal || 0;
  const live = state.tags || [];
  const {inDeck} = sceneVolgorde();

  if (!totaal) { host.append(el('p', {className: 'lead', textContent: 'Geen presentatie open.'})); return; }

  for (const tag of inDeck) {
    const scene = config.scenes[tag];
    const rij = el('div', {className: 'rij' + (live.includes(tag) ? ' actief' : '')});
    rij.onclick = () => { open = {type: 'scene', id: tag}; navigeer(); renderSheet(); };

    const naam = el('div', {className: 'naam'}, [document.createTextNode(tag)]);
    if (live.includes(tag)) naam.append(el('span', {className: 'badge', textContent: 'nu'}));

    const spoor = el('div', {className: 'spoor'});
    const stukken = [];
    getagd.forEach((g, i) => {
      if (!g.tags.includes(tag)) return;
      const volgende = getagd.slice(i + 1).find(v => !v.tags.includes(tag));
      const eind = volgende ? volgende.slide - 1 : totaal;
      const vorige = stukken[stukken.length - 1];
      if (vorige && vorige[1] >= g.slide - 1) vorige[1] = Math.max(vorige[1], eind);
      else stukken.push([g.slide, eind]);
    });
    const niveau = f => Math.max(0, ...f.channels.map(c => scene.values[f.id + '.' + c] ?? 0));
    const fels = fixtureList().slice().sort((a, b) => niveau(b) - niveau(a))[0];
    const hoofdkleur = fels && niveau(fels) > 0 ? sceneColor(scene, fels) : '#223130';
    stukken.forEach(([a, b]) => {
      const links = (a - 1) / totaal * 100, breed = (b - a + 1) / totaal * 100;
      const vlak = el('div', {className: 'vlak', style: `left:${links}%;width:${breed}%;background:${hoofdkleur}`});
      if (breed > 12) vlak.textContent = a === b ? 'dia ' + a : a + '–' + b;
      spoor.append(vlak);
    });

    const lampjes = el('div', {className: 'lampjes'});
    fixtureList().forEach(f => lampjes.append(el('i', {style: 'background:' + sceneColor(scene, f)})));

    rij.append(naam, spoor, lampjes, el('div', {className: 'meta2', textContent: (bereik(tag) || '') + ' · ' + scene.fade + ' sec'}));
    host.append(rij);
  }
}

function renderPads() {
  sigPads = stable(config.pads) + bank + stable(state.held || []);
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
    const note = midi().origin + bank * midi().padsPerBank + i;
    const onthaal = node => {
      node.ondragover = e => { e.preventDefault(); node.classList.add('doel'); };
      node.ondragleave = () => node.classList.remove('doel');
      node.ondrop = e => {
        e.preventDefault();
        node.classList.remove('doel');
        const van = e.dataTransfer.getData('text/plain');
        if (van) verplaatsPad(van, note);
      };
    };

    if (!found) {
      const empty = el('div', {className: 'pad leeg', textContent: '+ leeg'});
      onthaal(empty);
      empty.onclick = () => {
        config.pads = config.pads || {};
        config.pads[padKeyFor(i)] = {label: 'Nieuw', mode: 'hold', type: 'geluid', dmx: {}};
        dirtyNow(); renderPads();
        open = {type: 'pad', id: padKeyFor(i)}; navigeer(); renderSheet();
      };
      grid.append(empty);
      continue;
    }
    const {key, pad} = found;
    const isApparaat = padIsApparaat(pad);
    const card = el('div', {className: 'pad' + (isApparaat ? ' apparaat' : '') + (held ? ' aan' : ''), draggable: true});
    let gesleept = false;
    card.ondragstart = e => { gesleept = true; e.dataTransfer.setData('text/plain', key); e.dataTransfer.effectAllowed = 'move'; card.classList.add('sleep'); };
    card.ondragend = () => { card.classList.remove('sleep'); setTimeout(() => { gesleept = false; }, 0); };
    onthaal(card);
    card.onclick = () => { if (gesleept) return; open = {type: 'pad', id: key}; navigeer(); renderSheet(); };
    card.append(
      el('span', {className: 'teken', textContent: isApparaat ? '🔦' : '🔈'}),
      el('span', {className: 'nm', textContent: pad.label || (pad.sample || '').split('/').pop() || 'Pad'}),
      el('span', {className: 'sub', textContent: isApparaat ? (pad.mode === 'toggle' ? 'aan/uit' : 'vasthouden') : Math.round(pad.volume ?? 100) + '%'})
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
    const meer = el('div', {className: 'sw meer' + (wheelOpen[f.id] ? ' aan' : ''), title: 'meer kleuren'});
    meer.onclick = () => { wheelOpen[f.id] = !wheelOpen[f.id]; renderSheet(); };
    sw.append(meer);
    box.append(sw);

    const wheel = el('div', {className: 'wheel'});
    const marker = el('i');
    wheel.append(marker);
    const place = () => {
      const [r, g, b] = ['red', 'green', 'blue'].map(c => get(c));
      const [h, sat] = rgb2hs(r / 100, g / 100, b / 100);
      const radius = sat * 46, angle = h * Math.PI / 180;
      marker.style.left = (66 + Math.cos(angle) * radius) + 'px';
      marker.style.top = (66 + Math.sin(angle) * radius) + 'px';
      marker.style.opacity = Math.max(r, g, b) > 0 ? 1 : 0.25;
    };
    place();
    if (!wheelOpen[f.id]) wheel.style.display = 'none';
    wheel.onclick = e => {
      const rect = wheel.getBoundingClientRect();
      const dx = e.clientX - rect.left - rect.width / 2, dy = e.clientY - rect.top - rect.height / 2;
      const dist = Math.min(Math.hypot(dx, dy) / (rect.width / 2), 1);
      const hue = (Math.atan2(dy, dx) * 180 / Math.PI + 360) % 360;
      const level = Math.max(get('red'), get('green'), get('blue')) || 100;
      const [r, g, b] = hsv2rgb(hue, dist);
      set('red', Math.round(r * level)); set('green', Math.round(g * level)); set('blue', Math.round(b * level));
      renderSheet();
    };
    box.append(wheel);

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
  } else if (k === 'schakelaar') {
    const ch = f.channels[0];
    const on = get(ch) > 0;
    const t = el('div', {className: 'toggle' + (on ? ' aan' : '')}, [el('i')]);
    t.onclick = () => { set(ch, on ? 0 : 100); renderSheet(); };
    box.append(el('div', {style: 'display:flex;gap:12px;align-items:center;margin-top:16px'}, [t, el('span', {className: 'sub', textContent: on ? 'aan in deze scene' : 'uit in deze scene', style: 'margin:0'})]));
  }

  const rest = f.channels.filter(c => c && !(GEBRUIKT[k] || []).includes(c) && !(k === 'schakelaar' && c === f.channels[0]));
  rest.forEach(ch => {
    const r = el('input', {type: 'range', min: 0, max: 100, value: get(ch)});
    const uit = el('span', {textContent: get(ch) + '%'});
    r.oninput = () => { set(ch, Number(r.value)); uit.textContent = r.value + '%'; };
    box.append(r, el('div', {className: 'row'}, [el('span', {textContent: kanaalLabel(ch)}), uit]));
  });

  return box;
}

function bereikVan(tag) {
  const getagd = state.getagd || [], totaal = state.diaTotaal || 0;
  const stukken = [];
  getagd.forEach((g, i) => {
    if (!g.tags.includes(tag)) return;
    const volgende = getagd.slice(i + 1).find(v => !v.tags.includes(tag));
    const eind = volgende ? volgende.slide - 1 : totaal;
    const vorige = stukken[stukken.length - 1];
    if (vorige && vorige[1] >= g.slide - 1) vorige[1] = Math.max(vorige[1], eind);
    else stukken.push([g.slide, eind]);
  });
  if (!stukken.length) return null;
  return 'Actief op ' + stukken.map(([a, b]) => a === b ? 'dia ' + a : 'dia ' + a + ' t/m ' + b).join(' en ');
}

function renderSheet() {
  const host = document.getElementById('sheet');
  host.innerHTML = '';
  if (!open) return;

  const sheet = el('div', {className: 'sheet'});
  if (open.type === 'scene') {
    const scene = config.scenes[open.id];
    if (!scene) { open = null; return; }
    const opDia = (state.deck || []).find(d => d.tag === open.id);
    const potlood = el('button', {className: 'potlood', title: 'naam wijzigen', textContent: '✎'});
    potlood.onclick = () => {
      const n = prompt('Nieuwe naam (dit is ook de #tag in Keynote)', open.id);
      if (!n) return;
      const key = n.trim().toLowerCase().replace(/^#/, '').replace(/[^a-z0-9_.-]/g, '');
      if (!key || config.scenes[key]) return;
      config.scenes[key] = config.scenes[open.id];
      delete config.scenes[open.id];
      open.id = key;
      dirtyNow(); navigeer(true); sigScenes = ''; renderScenes(); renderSheet();
    };
    sheet.append(el('div', {className: 'titelrij'}, [el('h2', {textContent: open.id}), potlood]), el('div', {className: 'sub',
      textContent: bereikVan(open.id) || 'Staat nergens in de presentatie — zet #' + open.id + ' in de notities van een dia'}));
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
    const del = el('button', {textContent: 'Verwijderen'});
    del.onclick = () => { delete config.scenes[open.id]; dirty = true; sluit(); };
    const test = el('button', {textContent: 'Uitproberen'});
    test.onclick = async () => {
      if (dirty) await bewaar();
      const r = await (await fetch('/api/preview', {method: 'POST', body: JSON.stringify({tag: open.id})})).json();
      setNote(r.artnet ? 'scene speelt' : 'zet Art-Net aan in Techniek', r.artnet ? 'ok' : 'gray');
    };
    const done = el('button', {textContent: 'Klaar', className: 'p'});
    done.onclick = sluit;
    foot.append(el('span', {className: 'spacer'}), del, test, done);
    sheet.append(foot);
  } else {
    const pad = (config.pads || {})[open.id];
    if (!pad) { open = null; return; }
    const note = Number(open.id.split(':').pop());
    const idx = note - midi().origin;
    const potlood = el('button', {className: 'potlood', title: 'naam wijzigen', textContent: '✎'});
    potlood.onclick = () => {
      const n = prompt('Naam van deze knop', pad.label || '');
      if (n === null) return;
      pad.label = n.trim();
      dirtyNow(); sigPads = ''; renderPads(); renderSheet();
    };
    sheet.append(el('div', {className: 'titelrij'}, [el('h2', {textContent: pad.label || 'Pad'}), potlood]),
      el('div', {className: 'sub', textContent: 'Knop ' + (idx % midi().padsPerBank + 1) + ', bank ' + (Math.floor(idx / midi().padsPerBank) + 1)}));

    const cols = el('div', {className: 'cols'});

    const isApparaat = padIsApparaat(pad);
    const soort = el('div', {className: 'choice'});
    ['Geluid', 'Apparaat'].forEach(s => {
      const b = el('button', {textContent: s, className: (s === 'Apparaat') === isApparaat ? 'sel' : ''});
      b.onclick = () => {
        pad.type = s === 'Apparaat' ? 'apparaat' : 'geluid';
        if (pad.type === 'apparaat') { delete pad.sample; delete pad.volume; pad.dmx = pad.dmx || {}; }
        else pad.dmx = {};
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

    cols.append(b2, b3, b4);
    if (!isApparaat) {
      const naamVanBestand = (pad.sample || '').split('/').pop();
      const kies = el('button', {textContent: pad.sample ? 'Ander bestand kiezen…' : 'Kies bestand…'});
      kies.onclick = async () => {
        if (dirty) { clearTimeout(saveTimer); await bewaar(); }
        fetch('/api/kies-geluid', {method: 'POST', body: JSON.stringify({pad: open.id})});
        setNote('kies een bestand in het venster');
      };
      const weg = el('button', {textContent: 'Wissen'});
      weg.onclick = () => { delete pad.sample; dirtyNow(); renderSheet(); };
      const vol = pad.volume ?? 100;
      const volSlider = el('input', {type: 'range', min: 0, max: 100, value: vol});
      const volUit = el('span', {textContent: Math.round(vol) + '%'});
      volSlider.oninput = () => { pad.volume = Number(volSlider.value); volUit.textContent = volSlider.value + '%'; dirtyNow(); };
      cols.append(el('div', {className: 'box'}, [
        el('h3', {textContent: 'Geluid'}),
        el('p', {textContent: naamVanBestand || 'nog geen bestand gekozen'}),
        el('div', {style: 'display:flex;gap:8px;flex-wrap:wrap'}, [kies, pad.sample ? weg : null]),
        pad.sample ? volSlider : null,
        pad.sample ? el('div', {className: 'row'}, [el('span', {textContent: 'volume'}), volUit]) : null]));
    } else {
      fixtureList('pads').forEach(f => cols.append(deviceBox(f, pad.dmx)));
    }
    sheet.append(cols);

    const foot = el('div', {className: 'foot'});
    const del = el('button', {textContent: 'Verwijderen'});
    del.onclick = () => { delete config.pads[open.id]; dirty = true; sluit(); };
    const test = el('button', {textContent: 'Uitproberen'});
    test.onclick = async () => { if (dirty) await bewaar(); fetch('/api/pad', {method: 'POST', body: JSON.stringify({pad: open.id})}); };
    const done = el('button', {textContent: 'Klaar', className: 'p'});
    done.onclick = sluit;
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
  rows.append(el('tr', {}, ['Naam', 'Soort', 'DMX-adres', 'Kanalen', '', 'Scenes', 'Soundboard', 'Nu'].map(h => el('th', {textContent: h}))));
  fixtureAll().forEach(f => {
    const naam = el('input', {type: 'text', value: f.naam});
    naam.onchange = () => { config.fixtures[f.id].label = naam.value; dirtyNow(); };
    const soortNaam = {rgb: 'kleurlamp', warmcool: 'warm/koel wit', schakelaar: 'aan-uit', dimmer: 'dimmer'}[kind(f)] || kind(f);
    const soort = el('span', {className: 'mono', textContent: soortNaam});
    const adres = el('input', {type: 'number', min: 1, max: 512, value: f.address});
    adres.onchange = () => { config.fixtures[f.id].address = Number(adres.value); dirtyNow(); renderTech(); };
    const live = (state.channels || []).filter(c => c.name.startsWith(f.id + '.'));
    const meter = el('div', {className: 'bar'}, [el('i', {style: 'width:' + Math.round(Math.max(0, ...live.map(c => c.value)) / 255 * 100) + '%'})]);
    const vink = (veld) => {
      const aan = config.fixtures[f.id][veld] !== false;
      const t = el('div', {className: 'toggle' + (aan ? ' aan' : '')}, [el('i')]);
      t.onclick = () => { config.fixtures[f.id][veld] = !aan; dirtyNow(); renderTech(); sigScenes = ''; sigPads = ''; };
      return t;
    };
    const uitklap = el('button', {className: 'sm', textContent: techOpen[f.id] ? '▾ kanalen' : '▸ kanalen'});
    uitklap.onclick = () => { techOpen[f.id] = !techOpen[f.id]; renderTech(); };
    rows.append(el('tr', {}, [el('td', {}, [naam]), el('td', {}, [soort]), el('td', {}, [adres]),
      el('td', {className: 'mono', textContent: f.address + '–' + (f.address + f.channels.length - 1)}),
      el('td', {}, [uitklap]), el('td', {}, [vink('inScenes')]), el('td', {}, [vink('inPads')]), el('td', {}, [meter])]));

    if (techOpen[f.id]) {
      const cel = el('td', {colSpan: 8, style: 'padding:4px 8px 14px'});
      f.channels.forEach((ch, i) => {
        const kies = el('select');
        KANAALNAMEN.forEach(([waarde, label]) => {
          const o = el('option', {value: waarde, textContent: label});
          if (waarde === ch) o.selected = true;
          kies.append(o);
        });
        if (!KANAALNAMEN.some(([k2]) => k2 === ch)) {
          const o = el('option', {value: ch, textContent: ch, selected: true});
          kies.append(o);
        }
        kies.onchange = () => {
          hernoemKanaal(f.id, ch, kies.value);
          config.fixtures[f.id].channels[i] = kies.value;
          delete config.fixtures[f.id].kind;
          dirtyNow(); sigScenes = ''; sigPads = ''; renderTech();
        };
        const weg = el('button', {className: 'sm', textContent: '✕'});
        weg.onclick = () => {
          hernoemKanaal(f.id, ch, '');
          config.fixtures[f.id].channels.splice(i, 1);
          dirtyNow(); sigScenes = ''; renderTech();
        };
        cel.append(el('div', {style: 'display:flex;gap:10px;align-items:center;margin-top:7px'}, [
          el('span', {className: 'mono', textContent: 'DMX ' + (f.address + i), style: 'min-width:72px'}),
          kies, weg]));
      });
      const erbij = el('button', {className: 'sm', textContent: '+ kanaal'});
      erbij.onclick = () => { config.fixtures[f.id].channels.push('intensity'); dirtyNow(); renderTech(); };
      cel.append(el('div', {style: 'margin-top:10px'}, [erbij]));
      rows.append(el('tr', {}, [cel]));
    }
  });

  const host2 = el('div', {className: 'backdrop'});
  const modal = el('div', {className: 'modal'});
  const close = el('button', {textContent: '✕'});
  close.onclick = () => { techZichtbaar = false; host.className = 'hidden'; navigeer(); };
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
  host2.onclick = e => { if (e.target === host2) { techZichtbaar = false; host.className = 'hidden'; navigeer(); } };
  host.append(host2);
}

function url() {
  if (techZichtbaar) return '/techniek';
  if (open) return (open.type === 'scene' ? '/scene/' : '/pad/') + encodeURIComponent(open.id);
  return tab === 'pads' ? '/soundboard' : tab === 'tijd' ? '/tijdlijn' : '/scenes';
}
function navigeer(vervang = false) {
  const pad = url();
  if (location.pathname === pad) return;
  history[vervang ? 'replaceState' : 'pushState']({}, '', pad);
}
function pasUrlToe() {
  const delen = decodeURIComponent(location.pathname).split('/').filter(Boolean);
  techZichtbaar = delen[0] === 'techniek';
  if (delen[0] === 'scene' && delen[1]) { open = {type: 'scene', id: delen[1]}; if (tab === 'pads') tab = 'scenes'; }
  else if (delen[0] === 'pad' && delen[1]) { open = {type: 'pad', id: delen[1]}; tab = 'pads'; }
  else { open = null; tab = delen[0] === 'soundboard' ? 'pads' : delen[0] === 'tijdlijn' ? 'tijd' : 'scenes'; }
  tekenAlles();
}
function tekenAlles() {
  document.getElementById('tab-scenes').className = tab === 'scenes' ? 'sel' : '';
  document.getElementById('tab-pads').className = tab === 'pads' ? 'sel' : '';
  document.getElementById('tab-tijd').className = tab === 'tijd' ? 'sel' : '';
  document.getElementById('view-scenes').className = tab === 'scenes' ? '' : 'hidden';
  document.getElementById('view-pads').className = tab === 'pads' ? '' : 'hidden';
  document.getElementById('view-tijd').className = tab === 'tijd' ? '' : 'hidden';
  if (config) { renderScenes(); renderPads(); renderTijdlijn(); renderSheet(); }
  if (techZichtbaar) renderTech(); else document.getElementById('tech').className = 'hidden';
}
window.onpopstate = pasUrlToe;

document.getElementById('tab-scenes').onclick = () => { tab = 'scenes'; syncTabs(); };
document.getElementById('tab-pads').onclick = () => { tab = 'pads'; syncTabs(); };
document.getElementById('tab-tijd').onclick = () => { tab = 'tijd'; syncTabs(); };
function syncTabs() {
  if (open && dirty) bewaar();
  open = null;
  navigeer();
  tekenAlles();
}
document.getElementById('panic').onclick = async () => { await fetch('/api/panic', {method: 'POST'}); setNote('alles uit', 'ok'); };
document.getElementById('openTech').onclick = () => { techZichtbaar = true; navigeer(); renderTech(); };
window.onbeforeunload = () => { if (dirty) { clearTimeout(saveTimer); navigator.sendBeacon('/api/config', JSON.stringify(config)); } };

async function poll() {
  try {
    state = await (await fetch('/api/state')).json();
    document.getElementById('live').className = 'dot' + (state.slide == null ? ' off' : '');
    document.getElementById('statusText').innerHTML = state.slide == null ? (state.blackout ? 'geen presentatie — alles uit' : 'geen presentatie')
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
    const nextScenes = stable(config.scenes) + stable(config.fixtures) + stable(state.getagd || []) + stable(state.deck || []) + stable(state.origins || {}) + (state.deckName || '');
    const nextPads = stable(config.pads) + bank + stable(state.held || []);
    if (tab === 'scenes') {
      if (nextScenes !== sigScenes) { sigScenes = nextScenes; renderScenes(); } else updateLiveScenes();
    }
    if (tab === 'pads' && nextPads !== sigPads) { sigPads = nextPads; renderPads(); }
    if (tab === 'tijd') {
      const nextTijd = nextScenes + stable(state.tags || []);
      if (nextTijd !== sigTijd) { sigTijd = nextTijd; renderTijdlijn(); }
    }
    const sheetSig = open ? open.type + open.id + stable(state.deck || []) : '';
    if (sheetSig !== sigSheet) { sigSheet = sheetSig; if (!dirty) renderSheet(); }
    if (!dirty && stable(state.config) !== stable(config)) { config = state.config; renderSheet(); }
  } catch (e) {}
}

(async () => {
  config = await (await fetch('/api/config')).json();
  pasUrlToe();
  navigeer(true);
  setInterval(poll, 500);
  poll();
})();
</script>
</body></html>
"""#
}
