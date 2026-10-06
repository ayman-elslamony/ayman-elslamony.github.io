import 'dart:js_interop';
import 'dart:js_interop_unsafe';

@JS('gtag')
external void _gtag(JSString command, JSString name, JSObject params);

/// Calls `gtag('event', name, params)` when the page defined `gtag`.
void sendEvent(String name, Map<String, String> params) {
  if (!globalContext.has('gtag')) return;
  final jsParams = JSObject();
  params.forEach((key, value) => jsParams[key] = value.toJS);
  try {
    _gtag('event'.toJS, name.toJS, jsParams);
  } catch (_) {
    // Analytics must never break a click.
  }
}
