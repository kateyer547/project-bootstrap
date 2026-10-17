/* Barre d'outils des maquettes : changement d'état, thème clair/sombre, annotations.
   Paramètres d'URL reconnus : ?theme=dark  ?annotations=1  ?etat=vide
   Fichier générique : il n'a pas besoin d'être modifié. */
(function () {
  var params = new URLSearchParams(location.search);
  var root = document.documentElement;
  var stored = function (key) { try { return localStorage.getItem('proto-' + key); } catch (e) { return null; } };
  var store = function (key, value) { try { localStorage.setItem('proto-' + key, value); } catch (e) { /* stockage indisponible */ } };
  var embedded = window.self !== window.top;

  var theme = params.get('theme') || (embedded ? null : stored('theme')) || 'light';
  root.setAttribute('data-theme', theme);

  function ready(fn) {
    if (document.readyState !== 'loading') fn(); else document.addEventListener('DOMContentLoaded', fn);
  }

  ready(function () {
    var body = document.body;
    if (params.get('annotations') === '1') body.classList.add('proto-annotations');

    var sections = Array.prototype.slice.call(document.querySelectorAll('[data-etat]'));
    var states = [];
    sections.forEach(function (s) {
      var name = s.getAttribute('data-etat');
      if (states.indexOf(name) === -1) states.push(name);
    });

    function showState(name) {
      sections.forEach(function (s) { s.hidden = s.getAttribute('data-etat') !== name; });
      Array.prototype.forEach.call(document.querySelectorAll('.proto-bar [data-state]'), function (b) {
        b.setAttribute('aria-pressed', String(b.getAttribute('data-state') === name));
      });
    }
    var initial = params.get('etat');
    if (initial && states.indexOf(initial) !== -1) showState(initial);

    // Dans le tableau des écrans (iframe), pas de barre d'outils.
    if (embedded) return;

    var css = document.createElement('style');
    css.textContent =
      '.proto-bar{position:fixed;right:12px;bottom:84px;z-index:1000;display:flex;flex-wrap:wrap;gap:4px;align-items:center;' +
      'max-width:calc(100vw - 24px);padding:6px;border-radius:12px;background:rgba(17,20,26,.92);color:#fff;' +
      'font:500 12px/1 system-ui,sans-serif;box-shadow:0 6px 20px rgba(0,0,0,.25)}' +
      '.proto-bar button,.proto-bar a{all:unset;cursor:pointer;padding:7px 9px;border-radius:8px;color:#d6dae2}' +
      '.proto-bar button:hover,.proto-bar a:hover{background:rgba(255,255,255,.12);color:#fff}' +
      '.proto-bar [aria-pressed=true]{background:#fff;color:#111}' +
      '.proto-bar .sep{width:1px;height:18px;background:rgba(255,255,255,.2);margin:0 2px}' +
      '.proto-bar.reduite>*:not(.proto-toggle){display:none}' +
      '@media(min-width:1024px){.proto-bar{bottom:16px}}';
    document.head.appendChild(css);

    var bar = document.createElement('div');
    bar.className = 'proto-bar';
    bar.setAttribute('role', 'toolbar');
    bar.setAttribute('aria-label', 'Outils de maquette');

    var back = document.createElement('a');
    back.href = '../index.html';
    back.textContent = '← Écrans';
    bar.appendChild(back);

    if (states.length > 1) {
      var sep = document.createElement('span'); sep.className = 'sep'; bar.appendChild(sep);
      var current = (sections.filter(function (s) { return !s.hidden; })[0] || sections[0]).getAttribute('data-etat');
      states.forEach(function (name) {
        var b = document.createElement('button');
        b.type = 'button';
        b.setAttribute('data-state', name);
        b.setAttribute('aria-pressed', String(name === current));
        b.textContent = name.charAt(0).toUpperCase() + name.slice(1);
        b.addEventListener('click', function () { showState(name); });
        bar.appendChild(b);
      });
    }

    var sep2 = document.createElement('span'); sep2.className = 'sep'; bar.appendChild(sep2);

    var themeBtn = document.createElement('button');
    themeBtn.type = 'button';
    themeBtn.textContent = root.getAttribute('data-theme') === 'dark' ? 'Clair' : 'Sombre';
    themeBtn.addEventListener('click', function () {
      var next = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
      root.setAttribute('data-theme', next);
      store('theme', next);
      themeBtn.textContent = next === 'dark' ? 'Clair' : 'Sombre';
    });
    bar.appendChild(themeBtn);

    var annBtn = document.createElement('button');
    annBtn.type = 'button';
    annBtn.textContent = 'Annotations';
    annBtn.setAttribute('aria-pressed', String(body.classList.contains('proto-annotations')));
    annBtn.addEventListener('click', function () {
      var on = body.classList.toggle('proto-annotations');
      annBtn.setAttribute('aria-pressed', String(on));
    });
    bar.appendChild(annBtn);

    var toggle = document.createElement('button');
    toggle.type = 'button';
    toggle.className = 'proto-toggle';
    toggle.textContent = '×';
    toggle.setAttribute('aria-label', 'Réduire la barre d\'outils');
    toggle.addEventListener('click', function () {
      var reduced = bar.classList.toggle('reduite');
      toggle.textContent = reduced ? '⚙' : '×';
      toggle.setAttribute('aria-label', reduced ? 'Afficher la barre d\'outils' : 'Réduire la barre d\'outils');
      store('bar', reduced ? 'reduite' : 'ouverte');
    });
    bar.appendChild(toggle);
    if (stored('bar') === 'reduite' || (stored('bar') === null && window.innerWidth < 640)) { bar.classList.add('reduite'); toggle.textContent = '⚙'; }

    body.appendChild(bar);
  });
})();
