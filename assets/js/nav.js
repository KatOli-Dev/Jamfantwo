var toggle = document.querySelector('.nav-toggle');
var menu = document.querySelector('.nav-menu');
if (toggle && menu) {
  toggle.addEventListener('click', function() {
    var expanded = toggle.getAttribute('aria-expanded') === 'true';
    toggle.setAttribute('aria-expanded', !expanded);
    menu.classList.toggle('nav-menu-open');
  });
}
var dt = document.querySelector('.dropdown-toggle');
var dm = document.querySelector('.dropdown-menu');
if (dt && dm) {
  dt.addEventListener('click', function(e) {
    if (window.innerWidth <= 600) {
      var expanded = dt.getAttribute('aria-expanded') === 'true';
      dt.setAttribute('aria-expanded', !expanded);
      dm.classList.toggle('dropdown-menu-open');
    }
  });
}
