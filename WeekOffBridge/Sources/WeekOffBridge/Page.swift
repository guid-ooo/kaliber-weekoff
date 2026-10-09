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
body{margin:0;background:var(--g800);color:var(--berry);font-family:var(--font);font-weight:350;letter-spacing:var(--ls);font-size:16px;line-height:1.5;-webkit-user-select:none;user-select:none}
input,textarea{-webkit-user-select:text;user-select:text}
h1,h2,h3{font-family:var(--display);font-weight:300;margin:0}
header{padding:18px 30px;border-bottom:1px solid var(--g400);display:flex;align-items:center;gap:20px;position:sticky;top:0;background:var(--g800);z-index:9}
h1{font-size:21px}
nav{display:flex;gap:6px}
nav span{padding:7px 16px;border-radius:999px;font-size:14px;color:var(--gray);cursor:pointer;border:1px solid transparent}
nav span.sel{color:var(--isit);border-color:var(--isit)}
.status{margin-left:auto;display:flex;gap:0;align-items:center;font-size:14px;color:var(--gray)}
.status .dot{margin-right:11px;flex:none}
#statusText{display:flex;align-items:center;margin-right:32px}
.status button+button{margin-left:8px}
.status #note{margin-left:16px}
.status .cel{display:flex;align-items:baseline;gap:6px;padding-left:11px;margin-left:11px;border-left:1px solid var(--g400)}
.status .cel:first-child{padding-left:0;margin-left:0;border-left:0}
.status .lab{font-size:9.5px;text-transform:uppercase;letter-spacing:.11em;color:var(--gray);opacity:.65}
.status .val{color:var(--berry);font-weight:450;font-variant-numeric:tabular-nums}
.status .cel.stil .val{color:var(--gray);font-weight:400}
.status .cel.let .val{color:var(--pink)}
.dot{width:8px;height:8px;border-radius:50%;background:var(--isit);box-shadow:0 0 0 3px #d1ff0026}
.dot.off{background:var(--g300);box-shadow:none}
button{background:transparent;border:1px solid var(--g300);color:var(--berry);border-radius:999px;padding:8px 16px;font:inherit;font-size:14px;letter-spacing:var(--ls);cursor:pointer}
button:hover{border-color:var(--isit)}
button:disabled{opacity:.3;cursor:default}
button:disabled:hover{border-color:var(--g300)}
button.p{background:var(--isit);border-color:var(--isit);color:var(--g800);font-weight:500}
button.sel{border-color:var(--isit);color:var(--isit)}
button.sm{padding:5px 12px;font-size:13px}
button.ico{width:39px;height:39px;padding:0;display:grid;place-items:center;flex:none}
button.ico svg{width:16px;height:16px;display:block}
button.ico.weg:hover{border-color:#ff8e8e;color:#ff8e8e}
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
.scene{position:relative;background:var(--blackish);border:1px solid var(--g400);border-radius:16px;overflow:hidden;cursor:pointer;transition:.15s}
.scene:hover{border-color:var(--isit);transform:translateY(-2px)}
.scene.actief{border-color:var(--isit)}
.kanalen{display:flex;gap:9px;align-items:flex-end;height:104px;padding:0 15px}
.kan{flex:1;min-width:0;display:flex;flex-direction:column;gap:7px;height:100%}
.spoor2{width:100%;flex:1;background:var(--g800);border-radius:6px;position:relative;overflow:hidden;
box-shadow:inset 0 1px 0 #ffffff0a}
.spoor2 i{position:absolute;left:0;right:0;bottom:0;border-radius:5px;display:block}
.kan small{font-size:10.5px;color:var(--gray);text-align:center;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.skop{display:flex;align-items:baseline;gap:10px;padding:14px 15px 12px}
.svoet{padding:11px 15px 13px;font-size:12.5px;color:var(--gray);display:flex;gap:6px;align-items:baseline;flex-wrap:wrap}
.svoet .nu{color:var(--isit);font-weight:500}
.svoet .punt{color:var(--g300)}
.svoet .chip{color:var(--pink);border:1px solid #dfa8ff40;border-radius:999px;padding:1px 9px;font-size:11.5px}
.dia{margin-left:auto;font-size:12px;color:#fffcf2a6;font-variant-numeric:tabular-nums;white-space:nowrap}
.groei>.kanalen{height:150px;padding:20px 24px 0}
.sname{font-family:var(--display);font-size:21px;line-height:1.1}
.groei>.kanalen+.sheet{padding-top:18px}
.badge{font-family:var(--font);font-size:10.5px;background:var(--isit);color:var(--g800);
border-radius:999px;padding:3px 9px;font-weight:500;letter-spacing:.01em}
.scene>.badge{position:absolute;top:10px;right:10px;z-index:3;background:#0a1414e8;color:var(--isit);box-shadow:inset 0 0 0 1px #d1ff0059}
.meta{color:var(--gray);font-size:12.5px;margin-top:7px;display:flex;gap:7px;flex-wrap:wrap;align-items:baseline}
.meta .waar{color:#fffcf2a6;font-weight:450;font-variant-numeric:tabular-nums}
.meta .punt{color:var(--g300)}
.meta .chip{color:var(--pink);border:1px solid #dfa8ff40;border-radius:999px;padding:1px 9px;font-size:11.5px}
.kop{grid-column:1/-1;font-size:12px;text-transform:uppercase;letter-spacing:.07em;color:var(--gray);margin:14px 0 -4px}
.deckkop{display:flex;align-items:center;gap:24px;flex-wrap:wrap;margin:0 0 20px;padding-bottom:16px;border-bottom:1px solid var(--g400)}
.deckkop .label{font-size:11px;text-transform:uppercase;letter-spacing:.09em;color:var(--gray);margin-bottom:6px;line-height:1}
.deckkop h2{font-size:29px;line-height:1}
.deckkop.geen h2{color:var(--gray)}
.deckkop .rechts{margin-left:auto;display:flex;align-items:center;gap:22px}
.deckkop .tellers{display:flex;gap:18px;color:var(--gray);font-size:13px;font-variant-numeric:tabular-nums}
.kiezer{display:flex;gap:2px;background:var(--g800);border:1px solid var(--g400);border-radius:11px;padding:3px}
.kiezer button{width:34px;height:30px;border:0;border-radius:8px;background:transparent;color:var(--gray);display:grid;place-items:center;padding:0}
.kiezer button.sel{background:var(--g400);color:var(--isit)}
.kiezer svg{width:17px;height:17px;display:block}
.terug{background:none;border:0;color:var(--isit);padding:0;font-size:15px;margin-bottom:14px}
.deckkop .tellers b{color:var(--berry);font-weight:400}
.kop.klik{cursor:pointer;user-select:none}
.kop.klik:hover{color:var(--isit)}
.scene.dof{opacity:.62}
.scene.dof:hover{opacity:1}
.add{border:1px dashed var(--g300);border-radius:16px;display:grid;place-items:center;color:var(--gray);min-height:180px;cursor:pointer}
.add:hover{border-color:var(--isit);color:var(--isit)}
.pads{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:13px;max-width:600px;margin:0 auto}
#view-pads>.lead{max-width:600px;margin-left:auto;margin-right:auto}
.pad{aspect-ratio:1;min-height:0;overflow:hidden;border-radius:16px;border:1px solid var(--g400);background:var(--blackish);padding:13px;display:flex;flex-direction:column;cursor:pointer;transition:.12s}
.pad:hover{border-color:var(--isit);transform:translateY(-2px)}
.pad.leeg{border-color:transparent;background:#ffffff06;box-shadow:inset 0 1px 0 #ffffff0a;
color:var(--gray);align-items:center;justify-content:center;font-size:22px;line-height:1;opacity:.45;font-weight:300}
.pad.leeg:hover{opacity:1;background:#d1ff000a;border-color:var(--isit);transform:none}
.pad .teken{font-size:14px;line-height:1;opacity:.45}
.pad .nm{margin-top:auto;font-size:15px;line-height:1.2;overflow-wrap:anywhere;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden}
.pad .sub{font-size:12px;color:var(--gray);margin-top:3px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.pad.apparaat .nm{color:var(--pink)}
.pad.aan{border-color:var(--isit);box-shadow:0 0 0 1px var(--isit),0 0 24px #d1ff0033}
.pad[draggable]{cursor:grab}
.pad.sleep{opacity:.4;cursor:grabbing}
.pad.doel{border-color:var(--isit);border-style:solid;background:#d1ff000f}
.banken{display:flex;gap:1px;background:var(--g800);border:1px solid var(--g400);border-radius:9px;padding:2px}
.banken .kn{min-width:21px;height:18px;border:0;border-radius:6px;background:transparent;color:var(--gray);
font-family:'SF Mono',monospace;font-size:10px;padding:0;display:grid;place-items:center}
.banken .kn.aan{background:var(--g400);color:var(--isit)}
#banks .kn{min-width:32px;height:26px;border-radius:7px;font-family:var(--font);font-size:13.5px}
.terugrij{max-width:600px;margin:0 auto 16px}
.terug{padding:6px 14px 6px 11px;font-size:13.5px;color:var(--gray);border-color:var(--g400);background:transparent;border-width:1px;border-style:solid;border-radius:999px}
.terug:hover{color:var(--berry);border-color:var(--isit)}
#view-pads .deckkop{max-width:600px;margin-left:auto;margin-right:auto}
.schim{position:fixed;inset:0;background:#000b;z-index:15;display:grid;place-items:center;padding:24px}
.groei{width:min(820px,92vw);max-height:88vh;overflow:auto;background:var(--blackish);border:1px solid var(--g400);border-radius:20px;box-shadow:0 40px 110px #000d}
.groei>.prev{height:150px}
.groei>.prev>span:first-of-type{border-top-left-radius:19px}
.groei>.prev>span:last-of-type{border-top-right-radius:19px}
.sheet{padding:24px 28px}
.wiz{width:min(660px,92vw);background:var(--blackish);border:1px solid var(--g400);border-radius:20px;padding:26px 30px;box-shadow:0 40px 110px #000d}
.stappen{display:flex;gap:8px;margin-bottom:22px}
.stappen i{flex:1;height:4px;border-radius:999px;background:var(--g400);display:block}
.stappen i.aan{background:var(--isit)}
.vraag{font-family:var(--display);font-size:27px;margin-bottom:6px}
.wiz .sub2{color:var(--gray);font-size:13px;margin:0 0 22px}
.groot{display:flex;gap:12px;flex-wrap:wrap}
.groot .keus{width:62px;height:62px;border-radius:16px;border:2px solid transparent;display:grid;place-items:center;cursor:pointer;font-size:12px;color:var(--g800);text-align:center;line-height:1.1}
.groot .keus.aan{border-color:var(--berry)}
.groot .keus.leeg{background:var(--g800);border-color:var(--g300);color:var(--gray)}
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
.discoVlak,.sw.disco{background:linear-gradient(110deg,#e23b3b,#ff7a1a,#d1ff00,#2fbf71,#00a1ff,#dfa8ff,#e23b3b);background-size:300% 100%;
animation:discoKleur 3s linear infinite, discoBeat .5s ease-out infinite}
@keyframes discoKleur{from{background-position:0% 50%}to{background-position:300% 50%}}
@keyframes discoBeat{0%{transform:scale(1.07)}45%{transform:scale(1)}100%{transform:scale(1)}}
.sw.disco{border-color:var(--g300);position:relative;opacity:.9}
.sw.disco:after{content:"";position:absolute;inset:3px;border-radius:5px;background:radial-gradient(circle at 30% 30%,#ffffffcc,transparent 60%)}
.sw.disco:hover{opacity:1;border-color:var(--gray)}
.sw.disco.aan{border-color:var(--berry);opacity:1}
.sw.meer{background:conic-gradient(from 0deg,#f00,#ff0,#0f0,#0ff,#00f,#f0f,#f00);border-color:var(--g300);
box-shadow:inset 0 0 0 2px var(--blackish);opacity:.85;transition:.12s}
.sw.meer:hover{opacity:1;border-color:var(--gray)}
.sw.meer.aan{border-color:var(--berry);opacity:1;box-shadow:inset 0 0 0 2px var(--blackish)}
.wheel{width:132px;height:132px;border-radius:50%;margin:4px auto 10px;position:relative;cursor:crosshair;touch-action:none;border:1px solid var(--g300);
background:radial-gradient(circle,#fff 0%,#fff0 70%),conic-gradient(from 90deg,#f00,#ff0,#0f0,#0ff,#00f,#f0f,#f00)}
.wheel i{position:absolute;width:16px;height:16px;margin:-8px 0 0 -8px;border-radius:50%;border:2px solid #fff;box-shadow:0 0 0 1px #0008;pointer-events:none}
input[type=range]{-webkit-appearance:none;appearance:none;width:100%;height:30px;margin:12px 0 2px;background:transparent;cursor:pointer}
input[type=range]::-webkit-slider-runnable-track{height:30px;border-radius:10px;
background-image:repeating-linear-gradient(90deg,#00000059 0 2px,transparent 2px 10%),
linear-gradient(90deg,#00000059 0 2px),
linear-gradient(90deg,var(--isit) 0 calc(8px + (100% - 16px)*var(--f,0)),var(--g300) calc(8px + (100% - 16px)*var(--f,0)));
background-position:7px 50%,calc(100% - 9px) 50%,0 0;
background-size:calc(100% - 16px) 15px,2px 15px,100% 100%;
background-repeat:no-repeat}
input[type=range]::-webkit-slider-thumb{-webkit-appearance:none;appearance:none;width:16px;height:28px;border-radius:6px;
background:var(--berry);box-shadow:0 0 0 1px #0006;margin-top:1px}
input[type=range]:focus-visible::-webkit-slider-thumb{outline:2px solid var(--isit);outline-offset:2px}
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
#kastje{position:fixed;right:26px;bottom:-18px;z-index:12;cursor:pointer;width:224px;
background:var(--blackish);border:1px solid var(--g400);border-radius:24px;padding:14px 14px 28px;
box-shadow:0 18px 50px #0009;transition:border-color .15s}
#kastje:hover{border-color:var(--isit)}
.kastkop{display:flex;align-items:center;gap:10px;margin-bottom:12px}
.kastkop .merk{font-size:10px;text-transform:uppercase;letter-spacing:.12em;color:var(--gray);line-height:1}
.kastkop .banken{margin-left:auto}
.kbord{display:grid;grid-template-columns:repeat(4,1fr);gap:6px}
.kpd{aspect-ratio:1;border-radius:10px;background:var(--g800);box-shadow:inset 0 1px 0 #ffffff0a;
padding:6px;display:flex;flex-direction:column;overflow:hidden}
.kpd.vol{background:var(--g400);box-shadow:none}
.kpd .teken{font-size:9px;line-height:1;opacity:.5}
.kpd .nm{margin-top:auto;font-size:8.5px;line-height:1.15;color:var(--berry);overflow-wrap:anywhere;
display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden}
.kpd.aan{background:var(--isit);box-shadow:none}
.kpd.aan .nm{color:var(--g800)}
.kpd.aan .teken{opacity:.8}
#vraag.schim{z-index:40}
.vraagdoos{width:min(430px,92vw);background:var(--blackish);border:1px solid var(--g400);border-radius:18px;
padding:22px 24px;box-shadow:0 30px 80px #000d}
.vraagdoos h3{font-size:20px;margin-bottom:7px}
.vraagdoos p{margin:0;color:var(--gray);font-size:14px}
.hidden{display:none!important}
</style></head><body>
<header>
  <h1>WeekOff</h1>
  <div class="status"><span class="dot" id="live"></span><span id="statusText">–</span><button id="panic" class="ico uit" title="Alles uit" aria-label="Alles uit"><svg viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"><path d="M8 2.1v5.4"/><path d="M12.1 4.3a5.4 5.4 0 1 1-8.2 0"/></svg></button><button id="openTech">⚙ Techniek</button><span id="note"></span></div>
</header>
<main>
  <div id="deckkop"></div>
  <div id="view-scenes">
    <p class="lead">Elke scene hoort bij een dia. Klik op een scene om hem aan te passen.</p>
    <div class="grid" id="scenes"></div>
  </div>
  <div id="view-pads" class="hidden">
    <div class="terugrij"><button class="terug" id="terugNaarScenes">← Scenes</button></div>
    <div id="padkop"></div>
    <p class="lead">Elke knop is een pad op het kastje. Sleep om te verplaatsen, klik om te wijzigen.</p>
    <div class="pads" id="padgrid"></div>
  </div>
  <div id="view-tijd" class="hidden">
    <p class="lead">Elke scene over de lengte van de presentatie.</p>
    <div id="tijdlijn"></div>
  </div>
</main>
<div id="sheet"></div>
<div id="wizard"></div>
<div id="vraag" class="hidden"></div>
<div id="kastje" class="hidden"></div>
<div id="tech" class="hidden"></div>
<script>
let config = null, state = {}, dirty = false, bank = 0, open = null, learning = null;
let sigScenes = '', sigPads = '', sigSheet = '', sigTijd = '', sigKop = '', wheelOpen = {}, techOpen = {}, techZichtbaar = false, tab = 'scenes';
let snapshot = null, snapshotVoor = '';
let wizard = null, weergave = localStorage.getItem('weergave') || 'kaarten';

const stable = v => {
  if (v === null || typeof v !== 'object') return JSON.stringify(v);
  if (Array.isArray(v)) return '[' + v.map(stable).join(',') + ']';
  return '{' + Object.keys(v).sort().map(k => JSON.stringify(k) + ':' + stable(v[k])).join(',') + '}';
};
const ICO = {herstel: '<svg viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M3 8a5.2 5.2 0 1 0 1.7-3.9"/><path d="M2.6 2.9v3h3"/></svg>', kopie: '<svg viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round"><rect x="5.6" y="5.6" width="8" height="8" rx="2"/><path d="M10.4 3.3a2 2 0 0 0-2-1H4.4a2 2 0 0 0-2 2v4a2 2 0 0 0 1 1.7"/></svg>', uit: '<svg viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"><path d="M8 2.1v5.4"/><path d="M12.1 4.3a5.4 5.4 0 1 1-8.2 0"/></svg>', speel: '<svg viewBox="0 0 16 16" fill="currentColor" stroke="currentColor" stroke-width="1.6" stroke-linejoin="round"><path d="M6.1 4.4 12.4 8 6.1 11.6Z"/></svg>', weg: '<svg viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M2.9 4.4h10.2"/><path d="M6.4 4.4V3h3.2v1.4"/><path d="M4.3 4.4l.55 8.1a1 1 0 0 0 1 .93h4.3a1 1 0 0 0 1-.93l.55-8.1"/><path d="M6.7 6.9v4M9.3 6.9v4"/></svg>'};
function icoKnop(soort, label) {
  const b = el('button', {className: 'ico ' + soort, innerHTML: ICO[soort], title: label});
  b.setAttribute('aria-label', label);
  return b;
}
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
  werkHerstelBij();
  if (open) { setNote('nog niet bewaard'); return; }
  setNote('bewaren…');
  clearTimeout(saveTimer);
  saveTimer = setTimeout(bewaar, 600);
};
async function sluit() {
  const moest = dirty;
  open = null; learning = null; snapshot = null; snapshotVoor = '';
  navigeer();
  if (moest) await bewaar();
  sigScenes = ''; sigPads = ''; sigKop = '';
  renderScenes();
  renderSheet();
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
const hexKleur = h => { const v = hex2rgb(h); const m = Math.max(...v) || 1; return v.map(x => x / m); };
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
    if (v('disco') > 0) return 'DISCO';
    const m = Math.max(v('red'), v('green'), v('blue'));
    if (!m) return '#101c1c';
    return 'rgb(' + [v('red'), v('green'), v('blue')].map(x => Math.round(x / 100 * 255)).join(',') + ')';
  }
  if (kind(f) === 'warmcool') {
    const w = v('warm'), c = v('cool'), m = Math.max(w, c);
    if (!m) return '#101c1c';
    const mix = c / (w + c || 1), sterkte = m / 100;
    return 'rgb(' + [255, 210 + 30 * mix, 167 + 88 * mix].map(x => Math.round(x * sterkte)).join(',') + ')';
  }
  const niveau = v(f.channels[0]);
  if (!niveau) return '#101c1c';
  return 'rgb(' + [223, 168, 255].map(x => Math.round(x * niveau / 100)).join(',') + ')';
}

function fixtureNiveau(scene, f) {
  return Math.max(0, scene.values[f.id + '.disco'] ?? 0, ...f.channels.map(c => scene.values[f.id + '.' + c] ?? 0));
}

function bouwKanalen(scene) {
  const host = el('div', {className: 'kanalen'});
  fixtureList().forEach(f => {
    const niveau = fixtureNiveau(scene, f);
    const kleur = sceneColor(scene, f);
    const vul = el('i', {className: kleur === 'DISCO' ? 'discoVlak' : '',
      style: 'height:' + niveau + '%' + (kleur === 'DISCO' ? '' : ';background:' + kleur)});
    host.append(el('div', {className: 'kan'}, [
      el('div', {className: 'spoor2'}, [vul]),
      el('small', {textContent: f.naam, title: f.naam + ' \u00b7 ' + niveau + '%'})]));
  });
  return host;
}

function updateLiveScenes() {
  const live = state.tags || [];
  document.querySelectorAll('#scenes .scene').forEach(card => {
    const on = live.includes(card.dataset.tag);
    card.classList.toggle('actief', on);
    const tag = card.dataset.tag;
    const scene = config.scenes[tag];
    const voet = card.querySelector('.svoet');
    if (scene && voet) voet.replaceWith(voetVoor(tag, scene, on, bereik(tag)));
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

const ICOON_KAART = '<svg viewBox="0 0 16 16" fill="currentColor"><rect x="0" y="0" width="7" height="7" rx="2"/><rect x="9" y="0" width="7" height="7" rx="2"/><rect x="0" y="9" width="7" height="7" rx="2"/><rect x="9" y="9" width="7" height="7" rx="2"/></svg>';
const ICOON_TIJD = '<svg viewBox="0 0 16 16" fill="currentColor"><rect x="0" y="1" width="11" height="3.4" rx="1.7"/><rect x="3" y="6.3" width="13" height="3.4" rx="1.7"/><rect x="1" y="11.6" width="8" height="3.4" rx="1.7"/></svg>';

function renderDeckkop() {
  const host = document.getElementById('deckkop');
  if (tab !== 'scenes' || !config) { host.className = 'hidden'; host.innerHTML = ''; return; }
  host.className = 'deckkop' + (state.deckName ? '' : ' geen');
  host.innerHTML = '';
  const {inDeck, ontbreekt} = sceneVolgorde();
  host.append(el('div', {}, [
    el('div', {className: 'label', textContent: 'Huidige presentatie'}),
    el('h2', {textContent: state.deckName || 'Geen presentatie open'})]));
  const tellers = el('div', {className: 'tellers'});
  if (state.deckName) {
    tellers.append(el('span', {innerHTML: '<b>' + (state.diaTotaal || 0) + "</b> dia's"}),
      el('span', {innerHTML: '<b>' + inDeck.length + '</b> scene' + (inDeck.length === 1 ? '' : 's')}));
    if (ontbreekt.length) tellers.append(el('span', {innerHTML: '<b>' + ontbreekt.length + '</b> zonder scene', style: 'color:var(--pink)'}));
  }
  const kiezer = el('div', {className: 'kiezer'});
  [['kaarten', ICOON_KAART, 'Kaarten'], ['tijdlijn', ICOON_TIJD, 'Tijdlijn']].forEach(([w, icoon, titel]) => {
    const knop = el('button', {className: weergave === w ? 'sel' : '', innerHTML: icoon, title: titel});
    knop.onclick = () => {
      weergave = w;
      localStorage.setItem('weergave', w);
      navigeer();
      tekenAlles();
    };
    kiezer.append(knop);
  });
  host.append(el('div', {className: 'rechts'}, [tellers, kiezer]));
}

function voetVoor(tag, scene, live, waar) {
  const voet = el('div', {className: 'svoet'});
  if (live) {
    voet.append(el('span', {className: 'nu', textContent: 'nu op dia ' + state.slide}),
      el('span', {className: 'punt', textContent: '\u00b7'}),
      el('span', {textContent: scene.fade + ' sec overgang'}));
  } else if (!waar) {
    voet.append(el('span', {className: 'chip', textContent: 'niet in de presentatie'}),
      el('span', {className: 'punt', textContent: '\u00b7'}),
      el('span', {textContent: scene.fade + ' sec overgang'}));
  } else {
    voet.append(el('span', {textContent: scene.fade + ' sec overgang'}));
  }
  return voet;
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

  for (const tag of inDeck) {
    const scene = config.scenes[tag];
    const live = (state.tags || []).includes(tag);
    const card = el('div', {className: 'scene' + (live ? ' actief' : '')});
    card.dataset.tag = tag;
    card.onclick = () => { open = {type: 'scene', id: tag}; navigeer(); renderSheet(); };
    const waar = bereik(tag);
    card.append(el('div', {className: 'skop'}, [
      el('span', {className: 'sname', textContent: tag}),
      waar ? el('span', {className: 'dia', textContent: waar}) : null]));
    card.append(bouwKanalen(scene));
    card.append(voetVoor(tag, scene, live, waar));
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
      wizard = {tag: d.tag, stap: 0}; renderWizard();
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
    dirtyNow(); sigScenes = ''; renderScenes();
    wizard = {tag: key, stap: 0}; renderWizard();
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
      card.append(el('div', {className: 'skop'}, [el('span', {className: 'sname', textContent: tag})]));
      card.append(bouwKanalen(scene));
      card.append(el('div', {className: 'svoet'}, [
        el('span', {className: 'chip', textContent: herkomst[tag] || 'geen presentatie'})]));
      host.append(card);
    }
  }

  sigScenes = stable(config.scenes) + stable(config.fixtures) + stable(state.getagd || []) + stable(state.deck || []) + stable(state.origins || {}) + (state.deckName || '') + (state.diaTotaal || 0);
}

function padKeyFor(index) { return String(midi().origin + bank * midi().padsPerBank + index); }
function padFor(index) {
  const note = midi().origin + bank * midi().padsPerBank + index;
  const pads = config.pads || {};
  // Dezelfde voorrang als ShowConfig.pad(channel:note:): kanaal-gebonden wint.
  const gebonden = Object.entries(pads).map(([k, p]) => ({key: k, pad: p})).find(e => e.key.endsWith(':' + note));
  if (gebonden) return gebonden;
  return pads[String(note)] ? {key: String(note), pad: pads[String(note)]} : null;
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

function statusCel(label, waarde, klasse) {
  return el('span', {className: 'cel' + (klasse ? ' ' + klasse : '')},
    [label ? el('span', {className: 'lab', textContent: label}) : null,
     el('span', {className: 'val', textContent: waarde})]);
}

function renderStatus() {
  const host = document.getElementById('statusText');
  host.innerHTML = '';
  const geenDeck = state.slide == null;
  document.getElementById('live').className = 'dot' + (geenDeck ? ' off' : '');
  if (geenDeck) {
    host.append(statusCel('', state.blackout ? 'geen presentatie, alles uit' : 'geen presentatie', 'stil'));
  } else {
    const tags = state.tags || [];
    host.append(statusCel('dia', String(state.slide)),
      statusCel('scene', tags.length ? tags.join(' ') : 'geen', tags.length ? '' : 'stil'));
  }
  const bronnen = state.midi || 0;
  host.append(statusCel('kastje',
    bronnen ? (bronnen === 1 ? 'verbonden' : bronnen + ' verbonden') : 'niet verbonden',
    bronnen ? '' : 'let'));
}

function renderKastje() {
  const host = document.getElementById('kastje');
  if (tab !== 'scenes' || !config) { host.className = 'hidden'; host.innerHTML = ''; return; }
  host.className = '';
  host.innerHTML = '';

  const knopjes = el('div', {className: 'banken'});
  for (let b = 0; b < midi().banks; b++) {
    const knop = el('button', {className: 'kn' + (b === bank ? ' aan' : ''), textContent: String(b + 1)});
    knop.onclick = e => { e.stopPropagation(); bank = b; sigPads = ''; renderPads(); renderKastje(); };
    knopjes.append(knop);
  }
  host.append(el('div', {className: 'kastkop'}, [el('span', {className: 'merk', textContent: 'SOUNDBOARD'}), knopjes]));

  const bord = el('div', {className: 'kbord'});
  for (let i = 0; i < midi().padsPerBank; i++) {
    const found = padFor(i);
    const sleutel = padKeyFor(i);
    const speelt = (state.held || []).some(h => h === sleutel || h.endsWith(':' + sleutel));
    const vak = el('div', {className: 'kpd' + (found ? ' vol' : '') + (speelt ? ' aan' : ''),
      title: 'knop ' + (i + 1) + ', bank ' + (bank + 1)});
    if (found) {
      const isApparaat = padIsApparaat(found.pad);
      vak.append(el('span', {className: 'teken', textContent: isApparaat ? '🔦' : '🔈'}),
        el('span', {className: 'nm', textContent: found.pad.label || (found.pad.sample || '').split('/').pop() || 'Pad'}));
    }
    bord.append(vak);
  }
  host.append(bord);

  host.onclick = () => { tab = 'pads'; syncTabs(); };
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
    const niveau = f => Math.max(0, scene.values[f.id + '.disco'] ?? 0, ...f.channels.map(c => scene.values[f.id + '.' + c] ?? 0));
    const fels = fixtureList().slice().sort((a, b) => niveau(b) - niveau(a))[0];
    let hoofdkleur = fels && niveau(fels) > 0 ? sceneColor(scene, fels) : '#223130';
    const isDisco = hoofdkleur === 'DISCO';
    if (isDisco) hoofdkleur = '#223130';
    stukken.forEach(([a, b]) => {
      const links = (a - 1) / totaal * 100, breed = (b - a + 1) / totaal * 100;
      const vlak = el('div', {className: 'vlak' + (isDisco ? ' discoVlak' : ''), style: `left:${links}%;width:${breed}%` + (isDisco ? '' : `;background:${hoofdkleur}`)});
      if (breed > 12) vlak.textContent = a === b ? 'dia ' + a : a + '–' + b;
      spoor.append(vlak);
    });

    const lampjes = el('div', {className: 'lampjes'});
    fixtureList().forEach(f => {
      const kleur = sceneColor(scene, f);
      lampjes.append(kleur === 'DISCO' ? el('i', {className: 'discoVlak'}) : el('i', {style: 'background:' + kleur}));
    });

    rij.append(naam, spoor, lampjes, el('div', {className: 'meta2', textContent: (bereik(tag) || '') + ' · ' + scene.fade + ' sec'}));
    host.append(rij);
  }
}

function renderPads() {
  sigPads = stable(config.pads) + bank + stable(state.held || []);
  const kop = document.getElementById('padkop');
  kop.className = 'deckkop';
  kop.innerHTML = '';
  kop.append(el('div', {}, [
    el('div', {className: 'label', textContent: 'Soundboard'}),
    el('h2', {textContent: 'Kastje'})]));
  const banken = el('div', {className: 'banken', id: 'banks', title: 'bank'});
  for (let b = 0; b < midi().banks; b++) {
    const btn = el('button', {textContent: String(b + 1), className: 'kn' + (b === bank ? ' aan' : '')});
    btn.onclick = () => { bank = b; renderPads(); };
    banken.append(btn);
  }
  const gevuld = Array.from({length: midi().padsPerBank}, (_, i) => padFor(i)).filter(Boolean).length;
  kop.append(el('div', {className: 'rechts'}, [
    el('div', {className: 'tellers'}, [el('span', {innerHTML: '<b>' + gevuld + '</b> van ' + midi().padsPerBank})]),
    banken]));
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
      const empty = el('div', {className: 'pad leeg', textContent: '+', title: 'knop ' + (i + 1) + ' is nog leeg'});
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

function kleurIndex(get) {
  const current = [get('red'), get('green'), get('blue')];
  const helder = Math.max(...current);
  if (helder <= 0) return -1;
  let beste = -1, besteAfstand = Infinity;
  COLORS.forEach(([hex], i) => {
    const [r, g, b] = hexKleur(hex);
    const afstand = Math.hypot(current[0] - r * helder, current[1] - g * helder, current[2] - b * helder);
    if (afstand < besteAfstand) { besteAfstand = afstand; beste = i; }
  });
  return besteAfstand > 12 ? -1 : beste;
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
    const beste = kleurIndex(get);
    COLORS.forEach(([hex, naam], i) => {
      const [r, g, b] = hexKleur(hex);
      const dot = el('div', {className: 'sw' + (i === beste ? ' aan' : ''), title: naam, style: 'background:' + hex});
      dot.onclick = () => {
        const level = Math.max(...current) || 100;
        set('disco', 0);
        set('red', Math.round(r * level)); set('green', Math.round(g * level)); set('blue', Math.round(b * level));
        renderSheet();
      };
      sw.append(dot);
    });

    const disco = get('disco') > 0;
    const discoSwatch = el('div', {className: 'sw disco' + (disco ? ' aan' : ''), title: 'disco'});
    discoSwatch.onclick = () => {
      if (disco) { set('disco', 0); }
      else {
        const niveau = Math.max(get('red'), get('green'), get('blue')) || 100;
        ['red', 'green', 'blue'].forEach(c => set(c, 0));
        set('disco', niveau);
      }
      renderSheet();
    };
    sw.append(discoSwatch);

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
      const angle = h * Math.PI / 180;
      marker.style.left = (50 + Math.cos(angle) * sat * 50) + '%';
      marker.style.top = (50 + Math.sin(angle) * sat * 50) + '%';
      marker.style.opacity = Math.max(r, g, b) > 0 ? 1 : 0.25;
    };
    place();
    if (!wheelOpen[f.id]) wheel.style.display = 'none';
    const kiesUitWiel = e => {
      const rect = wheel.getBoundingClientRect();
      const dx = e.clientX - rect.left - rect.width / 2, dy = e.clientY - rect.top - rect.height / 2;
      const dist = Math.min(Math.hypot(dx, dy) / (rect.width / 2), 1);
      const hue = (Math.atan2(dy, dx) * 180 / Math.PI + 360) % 360;
      const level = Math.max(get('red'), get('green'), get('blue')) || 100;
      const [r, g, b] = hsv2rgb(hue, dist);
      set('disco', 0);
      set('red', Math.round(r * level)); set('green', Math.round(g * level)); set('blue', Math.round(b * level));
      place();
      ververPrev();
    };
    wheel.onpointerdown = e => { e.preventDefault(); wheel.setPointerCapture(e.pointerId); kiesUitWiel(e); };
    wheel.onpointermove = e => { if (wheel.hasPointerCapture(e.pointerId)) kiesUitWiel(e); };
    wheel.onpointerup = () => { sigScenes = ''; renderScenes(); renderSheet(); };
    box.append(wheel);

    const level = disco ? get('disco') : Math.max(get('red'), get('green'), get('blue'));
    const range = el('input', {type: 'range', min: 0, max: 100, step: 10, value: level});
    if (disco) {
      range.oninput = () => {
        set('disco', Number(range.value));
        box.querySelector('.row span:last-child').textContent = range.value + '%';
      };
      box.append(range, el('div', {className: 'row'}, [el('span', {textContent: 'helderheid · disco'}), el('span', {textContent: level + '%'})]));
      return box;
    }
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
    const b = el('input', {type: 'range', min: 0, max: 100, step: 10, value: level});
    const m = el('input', {type: 'range', min: 0, max: 100, step: 10, value: Math.round(mix)});
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
    const r = el('input', {type: 'range', min: 0, max: 100, step: 10, value: get(ch)});
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




function wizKeuzes(f) {
  const k = kind(f);
  if (k === 'rgb') {
    const lijst = COLORS.map(([hex, naam]) => ({naam, stijl: 'background:' + hex, zet: v => {
      const [r, g, b] = hexKleur(hex);
      v[f.id + '.disco'] = 0; delete v[f.id + '.disco'];
      ['red', 'green', 'blue'].forEach((c, i) => v[f.id + '.' + c] = Math.round([r, g, b][i] * 100));
    }}));
    lijst.push({naam: 'disco', klasse: 'disco', zet: v => {
      ['red', 'green', 'blue'].forEach(c => delete v[f.id + '.' + c]);
      v[f.id + '.disco'] = 100;
    }});
    return lijst;
  }
  if (k === 'warmcool') return [
    {naam: 'warm', stijl: 'background:#ffd9a0', zet: v => { v[f.id + '.warm'] = 100; delete v[f.id + '.cool']; }},
    {naam: 'neutraal', stijl: 'background:#ffe9c9', zet: v => { v[f.id + '.warm'] = 50; v[f.id + '.cool'] = 50; }},
    {naam: 'koel', stijl: 'background:#cfe7ff', zet: v => { v[f.id + '.cool'] = 100; delete v[f.id + '.warm']; }}];
  if (k === 'schakelaar') return [
    {naam: 'aan', stijl: 'background:' + '#d1ff00', zet: v => v[f.id + '.' + f.channels[0]] = 100}];
  return [
    {naam: 'vol', stijl: 'background:#fffcf2', zet: v => v[f.id + '.' + f.channels[0]] = 100},
    {naam: 'half', stijl: 'background:#8a8a80', zet: v => v[f.id + '.' + f.channels[0]] = 50}];
}

function wizHuidig(f, values) {
  const k = kind(f);
  if (k === 'rgb') {
    if ((values[f.id + '.disco'] ?? 0) > 0) return COLORS.length;
    return kleurIndex(ch => values[f.id + '.' + ch] ?? 0);
  }
  if (k === 'warmcool') {
    const w = values[f.id + '.warm'] ?? 0, c = values[f.id + '.cool'] ?? 0;
    if (!w && !c) return -1;
    return c === 0 ? 0 : w === 0 ? 2 : 1;
  }
  const niveau = values[f.id + '.' + f.channels[0]] ?? 0;
  if (!niveau) return -1;
  return k === 'schakelaar' ? 0 : (niveau > 70 ? 0 : 1);
}

function renderWizard() {
  const laag = document.getElementById('wizard');
  laag.innerHTML = '';
  if (!wizard) return;
  const scene = config.scenes[wizard.tag];
  const lampen = fixtureList();
  if (!scene || !lampen.length) { wizard = null; return; }
  if (wizard.stap >= lampen.length) {
    const tag = wizard.tag;
    wizard = null;
    open = {type: 'scene', id: tag}; navigeer();
    sigScenes = ''; renderScenes(); renderSheet();
    return;
  }

  const f = lampen[wizard.stap];
  const doos = el('div', {className: 'wiz'});
  doos.onclick = e => e.stopPropagation();

  const balk = el('div', {className: 'stappen'});
  lampen.forEach((_, i) => balk.append(el('i', {className: i <= wizard.stap ? 'aan' : ''})));
  doos.append(balk,
    el('div', {className: 'vraag', textContent: 'Wat doet ' + f.naam + ' in deze scene?'}),
    el('p', {className: 'sub2', textContent: 'Scene ' + wizard.tag + ' \u00b7 stap ' + (wizard.stap + 1) + ' van ' + lampen.length}));

  const huidig = wizHuidig(f, scene.values);
  const rij = el('div', {className: 'groot'});
  wizKeuzes(f).forEach((keus, i) => {
    const vak = el('div', {className: 'keus' + (keus.klasse ? ' ' + keus.klasse : '') + (i === huidig ? ' aan' : ''),
      title: keus.naam, style: keus.stijl || ''});
    vak.onclick = () => {
      keus.zet(scene.values);
      dirtyNow(); sigScenes = ''; renderScenes();
      wizard.stap++; renderWizard();
    };
    rij.append(vak);
  });
  const uit = el('div', {className: 'keus leeg' + (huidig === -1 ? ' aan' : ''), textContent: 'uit', title: 'uit'});
  uit.onclick = () => {
    f.channels.concat('disco').forEach(c => delete scene.values[f.id + '.' + c]);
    dirtyNow(); sigScenes = ''; renderScenes();
    wizard.stap++; renderWizard();
  };
  rij.append(uit);
  doos.append(rij);

  const voet = el('div', {className: 'foot'});
  if (wizard.stap === 0) {
    const zelf = el('button', {textContent: 'Ik doe het zelf'});
    zelf.onclick = () => {
      const tag = wizard.tag;
      wizard = null;
      open = {type: 'scene', id: tag}; navigeer(); renderSheet();
    };
    voet.append(zelf);
  } else {
    const terug = el('button', {textContent: '\u2190 Terug'});
    terug.onclick = () => { wizard.stap--; renderWizard(); };
    voet.append(terug);
  }
  const sla = el('button', {textContent: 'Overslaan'});
  sla.onclick = () => { wizard.stap++; renderWizard(); };
  const door = el('button', {textContent: wizard.stap === lampen.length - 1 ? 'Klaar' : 'Volgende \u2192', className: 'p'});
  door.onclick = () => { wizard.stap++; renderWizard(); };
  voet.append(el('span', {className: 'spacer'}), sla, door);
  doos.append(voet);

  const schim = el('div', {className: 'schim'}, [doos]);
  schim.onclick = () => { wizard = null; renderWizard(); };
  laag.append(schim);
}

function huidigObject() {
  if (!open) return null;
  return open.type === 'scene' ? config.scenes[open.id] : (config.pads || {})[open.id];
}

function zorgSnapshot() {
  if (!open) { snapshot = null; snapshotVoor = ''; return; }
  const sleutel = open.type + ':' + open.id;
  if (sleutel === snapshotVoor) return;
  const bron = huidigObject();
  snapshot = bron ? JSON.parse(JSON.stringify(bron)) : null;
  snapshotVoor = sleutel;
}

function isGewijzigd() {
  const bron = huidigObject();
  return !!(snapshot && bron) && stable(bron) !== stable(snapshot);
}

function zetTerug() {
  const kopie = JSON.parse(JSON.stringify(snapshot));
  if (open.type === 'scene') config.scenes[open.id] = kopie; else config.pads[open.id] = kopie;
  dirty = true;
  sigScenes = ''; sigPads = '';
}

function sluitVraag() {
  const laag = document.getElementById('vraag');
  laag.className = 'hidden';
  laag.innerHTML = '';
}

function probeerSluiten() {
  if (!open || !isGewijzigd()) { sluit(); return; }
  const naam = open.type === 'scene' ? open.id : (huidigObject().label || 'dit pad');
  const weg = el('button', {textContent: 'Weggooien'});
  weg.onclick = () => { zetTerug(); sluitVraag(); sluit(); };
  const terug = el('button', {textContent: 'Terug'});
  terug.onclick = sluitVraag;
  const bewaren = el('button', {textContent: 'Bewaren', className: 'p'});
  bewaren.onclick = () => { sluitVraag(); sluit(); };
  const doos = el('div', {className: 'vraagdoos'}, [
    el('h3', {textContent: 'Nog niet bewaard'}),
    el('p', {textContent: 'Je hebt \u201c' + naam + '\u201d aangepast. Wat moet ermee gebeuren?'}),
    el('div', {className: 'foot'}, [weg, el('span', {className: 'spacer'}), terug, bewaren])]);
  const laag = document.getElementById('vraag');
  laag.className = 'schim';
  laag.innerHTML = '';
  laag.append(doos);
  laag.onclick = e => { if (e.target === laag) sluitVraag(); };
}

function werkHerstelBij() {
  const b = document.querySelector('#sheet .herstel');
  if (!b) return;
  const gewijzigd = isGewijzigd();
  b.disabled = !gewijzigd;
  b.title = gewijzigd ? 'Wijzigingen ongedaan maken' : 'Niets gewijzigd';
  const k = document.querySelector('#sheet .klaar');
  if (k) k.textContent = gewijzigd ? 'Bewaren' : 'Sluiten';
}

function herstelKnop() {
  const gewijzigd = isGewijzigd();
  const b = icoKnop('herstel', gewijzigd ? 'Wijzigingen ongedaan maken' : 'Niets gewijzigd');
  b.disabled = !gewijzigd;
  b.onclick = () => {
    if (!isGewijzigd()) return;
    const naam = open.type === 'scene' ? open.id
      : (huidigObject().label || 'dit pad');
    if (!confirm('Alles wat je sinds het openen aan \u201c' + naam + '\u201d hebt veranderd, terugzetten?')) return;
    const kopie = JSON.parse(JSON.stringify(snapshot));
    if (open.type === 'scene') config.scenes[open.id] = kopie; else config.pads[open.id] = kopie;
    dirtyNow();
    sigScenes = ''; sigPads = '';
    renderScenes(); renderPads(); renderSheet();
    setNote('teruggezet', 'ok');
  };
  return b;
}

function schuifVul(i) { i.style.setProperty('--f', Number(i.value) / 100); }

function ververPrev() {
  if (!open || open.type !== 'scene') return;
  const scene = config.scenes[open.id];
  const oud = document.querySelector('#sheet .groei > .kanalen');
  if (!scene || !oud) return;
  oud.replaceWith(bouwKanalen(scene));
}

function renderSheet() {
  const host = document.getElementById('sheet');
  host.innerHTML = '';
  if (!open) return;
  zorgSnapshot();

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
    const del = icoKnop('weg', 'Scene verwijderen');
    del.onclick = () => {
      if (!confirm('Scene \u201c' + open.id + '\u201d verwijderen? Dit kun je niet terugdraaien.')) return;
      delete config.scenes[open.id]; dirty = true; sluit();
    };
    const test = icoKnop('speel', 'Uitproberen');
    test.onclick = async () => {
      if (dirty) await bewaar();
      const r = await (await fetch('/api/preview', {method: 'POST', body: JSON.stringify({tag: open.id})})).json();
      setNote(r.artnet ? 'scene speelt' : 'zet Art-Net aan in Techniek', r.artnet ? 'ok' : 'gray');
    };
    const kopie = icoKnop('kopie', 'Scene dupliceren');
    kopie.onclick = () => {
      let key = open.id + '-kopie', n = 2;
      while (config.scenes[key]) key = open.id + '-kopie' + (n++);
      config.scenes[key] = {fade: scene.fade, values: Object.assign({}, scene.values)};
      open = {type: 'scene', id: key};
      dirtyNow(); navigeer(); sigScenes = ''; renderScenes(); renderSheet();
    };
    const done = el('button', {textContent: isGewijzigd() ? 'Bewaren' : 'Sluiten', className: 'p klaar'});
    done.onclick = sluit;
    foot.append(el('span', {className: 'spacer'}), del, herstelKnop(), kopie, test, done);
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
      const volSlider = el('input', {type: 'range', min: 0, max: 100, step: 10, value: vol});
      const volUit = el('span', {textContent: Math.round(vol) + '%'});
      volSlider.oninput = () => { pad.volume = Number(volSlider.value); volUit.textContent = volSlider.value + '%'; dirtyNow(); };
      cols.append(el('div', {className: 'box'}, [
        el('h3', {textContent: 'Geluid'}),
        el('p', {textContent: naamVanBestand || 'nog geen bestand gekozen'}),
        el('div', {style: 'display:flex;gap:8px;flex-wrap:wrap'}, [kies, pad.sample ? weg : null]),
        pad.sample ? volSlider : null,
        pad.sample ? el('div', {className: 'row'}, [el('span', {textContent: 'volume'}), volUit]) : null]));
    } else {
      pad.dmx = pad.dmx || {};
      fixtureList('pads').forEach(f => cols.append(deviceBox(f, pad.dmx)));
    }
    sheet.append(cols);

    const foot = el('div', {className: 'foot'});
    const del = icoKnop('weg', 'Pad verwijderen');
    del.onclick = () => {
      if (!confirm('Pad \u201c' + (pad.label || 'zonder naam') + '\u201d verwijderen? Dit kun je niet terugdraaien.')) return;
      delete config.pads[open.id]; dirty = true; sluit();
    };
    const test = icoKnop('speel', 'Uitproberen');
    test.onclick = async () => { if (dirty) await bewaar(); fetch('/api/pad', {method: 'POST', body: JSON.stringify({pad: open.id})}); };
    const done = el('button', {textContent: isGewijzigd() ? 'Bewaren' : 'Sluiten', className: 'p klaar'});
    done.onclick = sluit;
    foot.append(del, el('span', {className: 'spacer'}), herstelKnop(), test, done);
    sheet.append(foot);
  }
  const groei = el('div', {className: 'groei'});
  if (open.type === 'scene') groei.append(bouwKanalen(config.scenes[open.id]));
  groei.append(sheet);
  const schim = el('div', {className: 'schim'}, [groei]);
  schim.onclick = e => { if (e.target === schim) probeerSluiten(); };
  host.append(schim);
  host.querySelectorAll('input[type=range]').forEach(schuifVul);
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
  return tab === 'pads' ? '/soundboard' : weergave === 'tijdlijn' ? '/tijdlijn' : '/scenes';
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
  else {
    open = null;
    tab = delen[0] === 'soundboard' ? 'pads' : 'scenes';
    if (delen[0] === 'tijdlijn') weergave = 'tijdlijn';
    else if (delen[0] === 'scenes') weergave = 'kaarten';
  }
  tekenAlles();
}
function tekenAlles() {
  document.getElementById('view-scenes').className = tab === 'scenes' && weergave === 'kaarten' ? '' : 'hidden';
  document.getElementById('view-pads').className = tab === 'pads' ? '' : 'hidden';
  document.getElementById('view-tijd').className = tab === 'scenes' && weergave === 'tijdlijn' ? '' : 'hidden';
  if (config) renderDeckkop();
  else document.getElementById('deckkop').className = 'hidden';
  if (config) { renderScenes(); renderPads(); renderTijdlijn(); renderSheet(); }
  renderKastje();
  if (techZichtbaar) renderTech(); else document.getElementById('tech').className = 'hidden';
}
window.onpopstate = pasUrlToe;

document.addEventListener('input', e => {
  if (e.target.type !== 'range') return;
  schuifVul(e.target);
  ververPrev();
});
document.addEventListener('change', e => {
  if (e.target.type !== 'range' || !open || open.type !== 'scene') return;
  sigScenes = ''; renderScenes();
});
addEventListener('keydown', e => {
  if (e.key !== 'Escape') return;
  if (!document.getElementById('vraag').classList.contains('hidden')) { sluitVraag(); return; }
  if (wizard) { wizard = null; renderWizard(); }
  else if (open) probeerSluiten();
});
document.getElementById('terugNaarScenes').onclick = () => { tab = 'scenes'; syncTabs(); };
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
    renderStatus();

    if (learning && state.lastNote && state.lastNote.age < 1.5) {
      const nieuw = String(state.lastNote.note);
      // Een sleutel als "0:44" vangt noot 44 af vóór de kale "44", dus die telt ook als bezet.
      const bezet = Object.keys(config.pads || {})
        .some(k => k !== learning && (k === nieuw || k.endsWith(':' + nieuw)));
      if (bezet) {
        learning = null; setNote('die knop hoort al bij een ander pad'); renderPads(); renderSheet();
      } else if (nieuw !== learning) {
        config.pads[nieuw] = config.pads[learning];
        delete config.pads[learning];
        if (open && open.id === learning) open.id = nieuw;
        learning = null; dirtyNow(); setNote('pad gekoppeld', 'ok'); renderPads(); renderSheet();
      }
    }
    const nextScenes = stable(config.scenes) + stable(config.fixtures) + stable(state.getagd || []) + stable(state.deck || []) + stable(state.origins || {}) + (state.deckName || '') + (state.diaTotaal || 0);
    const nextPads = stable(config.pads) + bank + stable(state.held || []);
    const nextKop = (state.deckName || '') + '|' + (state.diaTotaal || 0) + '|' +
      stable(Object.keys(config.scenes || {})) + '|' + stable(state.deck || []);
    if (tab === 'scenes' && nextKop !== sigKop) { sigKop = nextKop; renderDeckkop(); }
    if (tab === 'scenes' && weergave === 'kaarten') {
      if (nextScenes !== sigScenes) { sigScenes = nextScenes; renderScenes(); } else updateLiveScenes();
    }
    if (tab === 'pads' && nextPads !== sigPads) { sigPads = nextPads; renderPads(); }
    if (tab === 'scenes') renderKastje();
    if (tab === 'scenes' && weergave === 'tijdlijn') {
      const nextTijd = nextScenes + stable(state.tags || []);
      if (nextTijd !== sigTijd) { sigTijd = nextTijd; renderTijdlijn(); }
    }
    const sheetSig = open ? open.type + open.id + stable(state.deck || []) : '';
    if (sheetSig !== sigSheet) { sigSheet = sheetSig; if (!dirty) renderSheet(); }
    if (!dirty && state.config && stable(state.config) !== stable(config)) { config = state.config; renderSheet(); }
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
