var randomLinks = document.querySelectorAll('.js-random-link');
var randomPage = document.getElementById('js-random-page');

function randomPageEntries(indexUrl) {
  return fetch(indexUrl)
    .then(function(response) {
      if (!response.ok) throw new Error('Could not load the page index.');
      return response.json();
    })
    .then(function(entries) {
      if (!Array.isArray(entries)) throw new Error('The page index is invalid.');
      return entries.filter(function(entry) {
        return entry && typeof entry.url === 'string' && entry.url.length > 0;
      });
    });
}

function chooseRandomPage(indexUrl, status) {
  randomPageEntries(indexUrl)
    .then(function(entries) {
      if (entries.length === 0) throw new Error('The page index is empty.');
      var entry = entries[Math.floor(Math.random() * entries.length)];
      window.location.assign(entry.url);
    })
    .catch(function() {
      if (status) {
        status.textContent = 'The archive could not be loaded. Try again.';
      }
    });
}

for (var i = 0; i < randomLinks.length; i++) {
  randomLinks[i].addEventListener('click', function(event) {
    event.preventDefault();
    chooseRandomPage(this.getAttribute('data-index-url'));
  });
}

if (randomPage) {
  chooseRandomPage(
    randomPage.getAttribute('data-index-url'),
    document.getElementById('random-status')
  );
}
