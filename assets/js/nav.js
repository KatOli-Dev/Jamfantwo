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

var tableOfContents = document.querySelectorAll('.table-of-contents');
for (var i = 0; i < tableOfContents.length; i++) {
  var toc = tableOfContents[i];
  var heading = toc.querySelector('h2');
  var list = toc.querySelector('ol');
  if (!heading || !list) {
    continue;
  }

  var listId = list.id || 'table-of-contents-list-' + (i + 1);
  list.id = listId;

  var tocToggle = document.createElement('button');
  tocToggle.type = 'button';
  tocToggle.className = 'toc-toggle';
  tocToggle.setAttribute('aria-expanded', 'false');
  tocToggle.setAttribute('aria-controls', listId);
  tocToggle.textContent = heading.textContent;
  heading.textContent = '';
  heading.appendChild(tocToggle);
  list.hidden = true;

  tocToggle.addEventListener('click', function() {
    var expanded = this.getAttribute('aria-expanded') === 'true';
    var controlledList = document.getElementById(this.getAttribute('aria-controls'));
    this.setAttribute('aria-expanded', !expanded);
    controlledList.hidden = expanded;
  });
}
