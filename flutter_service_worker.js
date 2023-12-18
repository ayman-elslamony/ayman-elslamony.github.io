'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "c6c16f5a6238e0fe718fc1f1a8b2d08d",
"assets/AssetManifest.bin.json": "2f3d657104ee7ade0d8342415a979907",
"assets/AssetManifest.json": "1c5652b1d1e8a989781be01a250fc2b7",
"assets/assets/fonts/Nunito-Bold.ttf": "91019ffb3b1df640e444b34e5a73dfc3",
"assets/assets/fonts/Nunito-Regular.ttf": "0c890be2af0d241a2387ad2c4c16af2c",
"assets/assets/images/check_and_chat.png": "475e1b2b71d9f12851991c33d4de3436",
"assets/assets/images/coach_station.png": "a9b4651627eda0dc331e41651c3c1d94",
"assets/assets/images/eaudemilano.png": "1e43eaeef711248dd997a271c8d54ecf",
"assets/assets/images/enaya.jpg": "4ef9883c4cea255971dfc4e48a6f6a86",
"assets/assets/images/es3fni.png": "7d908889c0ec373a9a1e7a080967e1c9",
"assets/assets/images/handaza.png": "075a844cb9fdfdcc30cbb10b78a509f1",
"assets/assets/images/health_book.png": "0ec8bd7755a9c867b72422c3358aa91c",
"assets/assets/images/hyper_pay.png": "930aef2c470776a912f5440bc1c69412",
"assets/assets/images/laptop_code.svg": "8e8a6c6fada50f27c234378559e9fd03",
"assets/assets/images/laptop_load.gif": "814486dfff7c35ca32c7df111b4b443e",
"assets/assets/images/logo.png": "1677cf3060de75780e5fe8c59d1272a0",
"assets/assets/images/rafah.png": "c726e58a4cbd2863f331f8822d0969db",
"assets/assets/images/refd.png": "6a2ac92f7e26f69eccd2f187b5bb9cc5",
"assets/assets/images/spinner-dark.apng": "d7f6e0cca2ae052bdb7973799975027a",
"assets/assets/images/spinner-light.apng": "0aa2c9bee051117e80ffaafb604e9258",
"assets/assets/images/splash_dark.png": "1677cf3060de75780e5fe8c59d1272a0",
"assets/assets/images/splash_light.png": "8de99388650a0dfa4f5685f0a7c7a5c8",
"assets/assets/images/sraco.jpg": "b4edec0199190b306c279121e1a217d0",
"assets/assets/images/tadbeer.jpg": "05815abb461680829480c594c9b29ecf",
"assets/assets/images/tanmya.jpg": "85daa84cdb76bb78f81d692b341a67da",
"assets/assets/translations/en.json": "d43e8be0b5d2e5ea3646dd301f212bf8",
"assets/FontManifest.json": "3ddd9b2ab1c2ae162d46e3cc7b78ba88",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/NOTICES": "fd538e0b6a0251ce92ffd89baf1a5de6",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "f25e8e701660fb45e2a81ff3f43c6d5c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "a5d7457fda15b7622c14f432ba63039a",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "b72c617acdf2227c8b1413215f620711",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"canvaskit/canvaskit.js": "eb8797020acdbdf96a12fb0405582c1b",
"canvaskit/canvaskit.wasm": "64edb91684bdb3b879812ba2e48dd487",
"canvaskit/chromium/canvaskit.js": "0ae8bbcc58155679458a0f7a00f66873",
"canvaskit/chromium/canvaskit.wasm": "f87e541501c96012c252942b6b75d1ea",
"canvaskit/skwasm.js": "87063acf45c5e1ab9565dcf06b0c18b8",
"canvaskit/skwasm.wasm": "4124c42a73efa7eb886d3400a1ed7a06",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.ico": "e27d09ea9ee337902fe0145a13f4010c",
"flutter.js": "59a12ab9d00ae8f8096fffc417b6e84f",
"icons/apple-touch-icon.png": "0f52db92c6df1fc86211688fd33c2889",
"icons/icon-192-maskable.png": "fe8ade4feb6beac2254f258aa78202d7",
"icons/icon-192.png": "fbc60aaf17509219e37bf2a63e102d33",
"icons/icon-512-maskable.png": "0d70240a868baae51cf81b5fa10b1ae0",
"icons/icon-512.png": "1b411fa1ab3060125a2992e538c68f45",
"index.html": "2cde3998cee452417a2e4c3d571bd0c7",
"/": "2cde3998cee452417a2e4c3d571bd0c7",
"main.dart.js": "9bd2faf60770073514278facc85d2a04",
"manifest.json": "c7a1600b8e7b20a1c062b6d25e98acda",
"version.json": "009c9e65172e010890f7f65fde438006"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
