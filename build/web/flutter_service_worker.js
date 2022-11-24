'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "c4e00cb3e3c921db4e6678fe60b24bcc",
"index.html": "862356626b26a096b8a30a89324f5e5e",
"/": "862356626b26a096b8a30a89324f5e5e",
"main.dart.js": "4b43be870a89c99d635bbf3f6b9a0d99",
"flutter.js": "f85e6fb278b0fd20c349186fb46ae36d",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "d7f4ed22c0d07fdcd164b663cd71532c",
"assets/asset/fonts/Inter-Medium.ttf": "ed533866b5c83114c7dddbcbc2288b19",
"assets/asset/fonts/Inter-Light.ttf": "d55f45d07cfe01e8797bd1566561f718",
"assets/asset/fonts/Inter-Bold.ttf": "275bfea5dc74c33f51916fee80feae67",
"assets/asset/fonts/Inter-Regular.ttf": "079af0e2936ccb99b391ddc0bbb73dcb",
"assets/asset/fonts/Inter-SemiBold.ttf": "07a48beb92b401297a76ff9f6aedd0ed",
"assets/images/search.svg": "a90611a9714d0702c29467ec85af9cd6",
"assets/images/list.svg": "a137471146b5ffc61cc7315c3a8acffd",
"assets/images/hamburger.svg": "ecfb4d5ce2f38d03d676dbfae702ffd2",
"assets/images/tag_new.svg": "5136f72c23ea3cfb2031f4908d64bd8c",
"assets/images/images.jpeg": "0fa5cebcb356f026f7cbba01edda0ea3",
"assets/images/drop_arrow.svg": "af1760163160043dab71a8b6b8e88208",
"assets/images/tags%25201.svg": "5136f72c23ea3cfb2031f4908d64bd8c",
"assets/images/bell.svg": "4f27e6dcadca6ec441006d97e0d3189d",
"assets/images/plus.svg": "68537417bd4521fe529a445246dfceb5",
"assets/images/people.svg": "b8012f8e07f11a8098d3f1ba7cc03442",
"assets/images/placeholder.png": "613c52dfc158ae1d6e8dda48056123d5",
"assets/images/button.svg": "c44302b669337afcf4d53ed44217fbcc",
"assets/images/setting.svg": "1f3aee1fcb22ffc33360bf1442ecc503",
"assets/images/date.png": "d14e25ca4da2bcadde399d9d69a1ee53",
"assets/images/camera.svg": "8732e31ba7bf510c213c2fc2fd28dd41",
"assets/images/list_ceramony.svg": "010f69121776eefaa0450ea85796ab76",
"assets/images/cermony.svg": "05ada0cf9661bfe33defc4b7f4f944a3",
"assets/images/dropdown.png": "d9b2b1e1a46855b2c9cdf209f6b0dea5",
"assets/images/edit.svg": "9ceed9af3e90d1ac864fdc810c683470",
"assets/images/dropdown.jpg": "530aaa274a314f2e7228793f9f55b544",
"assets/images/camera_pic.svg": "9107f59d78448c43fa996c2691eb5a5d",
"assets/images/location_icon.svg": "eadd1945ac47e981325472bd68ee54f5",
"assets/images/cross.svg": "f1a00d1d8bdcff2225ed34f2fea72ffb",
"assets/images/cermony.png": "70ce4631e45e27a9adc32167073fc3d3",
"assets/images/logo.svg": "6771102281a67f5bdced890c5164ee8a",
"assets/images/date.svg": "da46f0451599255ad13828218ed8bcbc",
"assets/images/notification_icon.svg": "17abe40e445a74b32d55d7e7dec6663f",
"assets/images/image.png": "5af38b761b2c35e3fa9edc3508fb0cbf",
"assets/images/photo.svg": "37c5edf3dd7ed290bde549c9452b4645",
"assets/AssetManifest.json": "05efc9b01677d5b161d0f518a6fa0ff8",
"assets/NOTICES": "0290054002071b4bbb753af555a5acd1",
"assets/FontManifest.json": "59433b70beb1410c3be98d0871262cd6",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/fluttertoast/assets/toastify.js": "e7006a0a033d834ef9414d48db3be6fc",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/shaders/ink_sparkle.frag": "8714de954ede2fa44d9515eead80fb70",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"canvaskit/canvaskit.js": "2bc454a691c631b07a9307ac4ca47797",
"canvaskit/profiling/canvaskit.js": "38164e5a72bdad0faa4ce740c9b8e564",
"canvaskit/profiling/canvaskit.wasm": "95a45378b69e77af5ed2bc72b2209b94",
"canvaskit/canvaskit.wasm": "bf50631470eb967688cca13ee181af62"
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
