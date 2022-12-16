'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/asset/fonts/Inter-Bold.ttf": "275bfea5dc74c33f51916fee80feae67",
"assets/asset/fonts/Inter-Light.ttf": "d55f45d07cfe01e8797bd1566561f718",
"assets/asset/fonts/Inter-Medium.ttf": "ed533866b5c83114c7dddbcbc2288b19",
"assets/asset/fonts/Inter-Regular.ttf": "079af0e2936ccb99b391ddc0bbb73dcb",
"assets/asset/fonts/Inter-SemiBold.ttf": "07a48beb92b401297a76ff9f6aedd0ed",
"assets/AssetManifest.json": "05efc9b01677d5b161d0f518a6fa0ff8",
"assets/FontManifest.json": "59433b70beb1410c3be98d0871262cd6",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"assets/images/bell.svg": "9e485a80d5760db01a64814c565e6f8f",
"assets/images/button.svg": "a8e95cffbf4b97a7e43c3ba48d35c79e",
"assets/images/camera.svg": "50e85175c64211e71653b21546eacd50",
"assets/images/camera_pic.svg": "e46746f395bebeb617807200f6d93dea",
"assets/images/cermony.png": "70ce4631e45e27a9adc32167073fc3d3",
"assets/images/cermony.svg": "fdc5c40ed759489d33a29cd8c162c427",
"assets/images/cross.svg": "85344091f7f8a80b7dee96397701b485",
"assets/images/date.png": "d14e25ca4da2bcadde399d9d69a1ee53",
"assets/images/date.svg": "66063c8d24bf0f9d4e3856ace38b8c74",
"assets/images/dropdown.jpg": "530aaa274a314f2e7228793f9f55b544",
"assets/images/dropdown.png": "d9b2b1e1a46855b2c9cdf209f6b0dea5",
"assets/images/drop_arrow.svg": "ea4d4cec2b8c72185ab0b5b0ef1c2c71",
"assets/images/edit.svg": "6cefa9b1996635de62539f687a3fbbc2",
"assets/images/hamburger.svg": "8099bf675d563896fbcdfaddbf79612e",
"assets/images/image.png": "5af38b761b2c35e3fa9edc3508fb0cbf",
"assets/images/images.jpeg": "0fa5cebcb356f026f7cbba01edda0ea3",
"assets/images/list.svg": "439a0d8baf13542a21c2848b4e8b5150",
"assets/images/list_ceramony.svg": "e0e4caa8a81dab1aa476d3f5864a338b",
"assets/images/location_icon.svg": "3319abd544db1bfcf17b87438b8f2775",
"assets/images/logo.svg": "c87c0e4455e258fc4a49e00db3be2ec8",
"assets/images/notification_icon.svg": "6be5e57fc66f73f77f8ae63e2777b491",
"assets/images/people.svg": "a77d22c6e8eca8f67bd24467990c245c",
"assets/images/photo.svg": "2cf490ffd0de2ff8a50712fe393f2472",
"assets/images/placeholder.png": "613c52dfc158ae1d6e8dda48056123d5",
"assets/images/plus.svg": "1068b5e5b5594c32715421d8bc34dda1",
"assets/images/search.svg": "16b572aab788b8e4bc678082641a15e0",
"assets/images/setting.svg": "fcc00a2df41484a6007d4aef1062a276",
"assets/images/tags%25201.svg": "37f6aee7cc228b73da02ed166f3cadb3",
"assets/images/tag_new.svg": "37f6aee7cc228b73da02ed166f3cadb3",
"assets/NOTICES": "49069b5a868978b8554c14b4c90a53d4",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "e7006a0a033d834ef9414d48db3be6fc",
"assets/shaders/ink_sparkle.frag": "0158490d9958b570451fd27a1f7b95ad",
"canvaskit/canvaskit.js": "2bc454a691c631b07a9307ac4ca47797",
"canvaskit/canvaskit.wasm": "bf50631470eb967688cca13ee181af62",
"canvaskit/profiling/canvaskit.js": "38164e5a72bdad0faa4ce740c9b8e564",
"canvaskit/profiling/canvaskit.wasm": "95a45378b69e77af5ed2bc72b2209b94",
"favicon.ico": "62092f629adbf458d4d6cb0748a757fd",
"flutter.js": "f85e6fb278b0fd20c349186fb46ae36d",
"icons/android-chrome-192x192.png": "83a66aebb386d2b68ed66a86d6a027c2",
"icons/android-chrome-512x512.png": "ea8570156e02d00d70adcde8fb3195a6",
"icons/apple-touch-icon.png": "3137846515916e1e572c5d746d40a5be",
"icons/favicon-16x16.png": "c018205aba90f17a0b03fbff6cb9e5d7",
"icons/favicon-32x32.png": "60f34efef846b0cd8da7cab1c1f608e4",
"icons/site.webmanifest": "053100cb84a50d2ae7f5492f7dd7f25e",
"index.html": "2e2b4d83aec01329439a1eb2bcd500f2",
"/": "2e2b4d83aec01329439a1eb2bcd500f2",
"main.dart.js": "09811b2176356f17578764f074a8e59e",
"manifest.json": "203dcf5669ab49e34ad468dee45400a3",
"version.json": "c4e00cb3e3c921db4e6678fe60b24bcc"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
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
