/// Non-web builds have no session storage.
String? readSession(String key) => null;

void writeSession(String key, String value) {}
