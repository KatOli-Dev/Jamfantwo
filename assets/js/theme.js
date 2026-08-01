var key = 'jamfantwo-theme';
var html = document.documentElement;

var stored = localStorage.getItem(key);
var theme;
if (stored === 'light' || stored === 'dark') {
  theme = stored;
} else {
  theme = window.matchMedia('(prefers-color-scheme: light)').matches ? 'light' : 'dark';
}
html.setAttribute('data-theme', theme);

var btn = document.getElementById('theme-toggle');
if (btn) {
  btn.setAttribute('aria-label', 'Switch to ' + (theme === 'light' ? 'dark' : 'light') + ' theme');
  btn.addEventListener('click', function() {
    var current = html.getAttribute('data-theme');
    var next = current === 'light' ? 'dark' : 'light';
    html.setAttribute('data-theme', next);
    localStorage.setItem(key, next);
    btn.setAttribute('aria-label', 'Switch to ' + (next === 'light' ? 'dark' : 'light') + ' theme');
  });
}
