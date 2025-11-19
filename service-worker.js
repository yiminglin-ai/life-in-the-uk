var APP_NAME = 'lifeintheuk',
  APP_VERSION = 10,
  CACHE_NAME = APP_NAME + '_' + APP_VERSION;
var filesToCache = ['./', './?utm_source=homescreen', './questions_base.json'];

// Service worker from Google Documentation

self.addEventListener('install', function (event) {
  // Perform install steps
  event.waitUntil(
    caches.open(CACHE_NAME).then(function (cache) {
      return cache.addAll(filesToCache);
    })
  );
});

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheNames) {
      return Promise.all(
        cacheNames.map(function (cacheName) {
          if (cacheName.indexOf(APP_NAME) === 0 && CACHE_NAME !== cacheName) {
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
});

self.addEventListener('fetch', function (event) {
  // Only handle same-origin GET requests over HTTP(S); ignore things like
  // chrome-extension://, data:, POST requests, etc.
  if (event.request.method !== 'GET') {
    return;
  }

  var url = new URL(event.request.url);
  if (url.origin !== self.location.origin) {
    return;
  }
  if (url.protocol !== 'http:' && url.protocol !== 'https:') {
    return;
  }

  event.respondWith(
    caches.match(event.request).then(function (response) {
      // Cache hit - return response
      if (response) {
        return response;
      }

      // Clone the request because it is a stream.
      var fetchRequest = event.request.clone();

      return fetch(fetchRequest).then(function (response) {
        // Check if we received a valid response
        if (!response || response.status !== 200 || response.type !== 'basic') {
          return response;
        }

        // Clone the response before caching
        var responseToCache = response.clone();

        caches.open(CACHE_NAME).then(function (cache) {
          cache.put(event.request, responseToCache).catch(function (err) {
            // Ignore cache errors for unsupported schemes, etc.
            console.warn('SW cache.put failed:', err);
          });
        });

        return response;
      });
    })
  );
});
