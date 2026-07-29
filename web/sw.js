// Caches the app shell so VIDEO opens and records with no network at all.
//
// CACHE must be bumped on every release. If it isn't, this file's bytes don't
// change, the browser never treats the worker as updated, and installed phones
// keep serving whatever is already cached — including a bad build.
const CACHE = 'video-v12';

const SHELL = [
  './',
  './index.html',
  './manifest.webmanifest',
  './icons/icon-180.png',
  './icons/icon-512.png'
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE)
      .then(cache => cache.addAll(SHELL))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', event => {
  const request = event.request;
  if (request.method !== 'GET') return;

  const isPage = request.mode === 'navigate' || request.destination === 'document';

  if (isPage) {
    // Network-first for the app itself. Cache-first here is what let a bad
    // build survive on installed phones: the worker kept answering from its
    // own cache and never looked at the server again. Now a working network
    // always wins, and the cache is only the offline fallback.
    event.respondWith(
      fetch(request)
        .then(response => {
          if (response && response.ok) {
            const copy = response.clone();
            caches.open(CACHE).then(cache => cache.put(request, copy));
          }
          return response;
        })
        .catch(() => caches.match(request).then(hit => hit || caches.match('./index.html')))
    );
    return;
  }

  // Icons and the manifest are static, so cache-first is fine for them.
  event.respondWith(
    caches.match(request).then(hit => {
      if (hit) return hit;
      return fetch(request).then(response => {
        if (response && response.ok && new URL(request.url).origin === self.location.origin) {
          const copy = response.clone();
          caches.open(CACHE).then(cache => cache.put(request, copy));
        }
        return response;
      });
    })
  );
});
