import 'package:web/web.dart' as web;

/// Reads `sessionStorage`; storage can throw (private mode, blocked site data), and a
/// welcome banner must never break the page.
String? readSession(String key) {
  try {
    return web.window.sessionStorage.getItem(key);
  } catch (_) {
    return null;
  }
}

void writeSession(String key, String value) {
  try {
    web.window.sessionStorage.setItem(key, value);
  } catch (_) {}
}
