import 'dart:io';

class CurtHttpHeaders implements HttpHeaders {
  final Map<String, List<String>> _headers = <String, List<String>>{};

  List<Cookie> get cookies {
    if (!_headers.containsKey(HttpHeaders.setCookieHeader)) {
      return <Cookie>[];
    }
    final Map<String, String> rawInfo = <String, String>{};
    for (final String rawValue in _headers[HttpHeaders.setCookieHeader]!) {
      final Cookie cookie = Cookie.fromSetCookieValue(rawValue);
      rawInfo[cookie.name] = cookie.value; // This prevents duplicate cookies
    }
    return rawInfo.entries
        .map((MapEntry<String, String> entry) => Cookie(entry.key, entry.value))
        .toList();
  }

  // TODO(anyone): properly implement these stubbed properties and methods?
  /// All of these go unused for our current use cases, so they're being stubbed
  @override
  bool chunkedTransferEncoding = true;

  @override
  int contentLength = -1;

  @override
  ContentType? contentType;

  @override
  DateTime? date;

  @override
  DateTime? expires;

  @override
  String? host;

  @override
  DateTime? ifModifiedSince;

  @override
  bool persistentConnection = true;

  @override
  int? port;

  @override
  void noFolding(String name) {}

  void _add(String name, String value) {
    if (_headers.containsKey(name)) {
      if (!_headers[name]!.contains(value)) {
        _headers[name]!.add(value);
      }
    } else {
      _headers[name] = <String>[value];
    }
  }

  void _remove(String name, String value) {
    if (_headers.containsKey(name)) {
      _headers[name]!.remove(value);
      if (_headers[name]!.isEmpty) {
        _headers.remove(name);
      }
    }
  }

  void _addAll(String name, Iterable<String> values) {
    for (final String value in values) {
      _add(name, value);
    }
  }

  void _removeAll(String name, Iterable<String> values) {
    for (final String value in values) {
      _remove(name, value);
    }
  }

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    final String nameToUse = preserveHeaderCase ? name : name.toLowerCase();
    if (value is Iterable) {
      _headers[nameToUse] = value.map((dynamic v) => v.toString()).toList();
    } else {
      _headers[nameToUse] = <String>[value.toString()];
    }
  }

  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {
    final String nameToUse = preserveHeaderCase ? name : name.toLowerCase();
    if (value is Iterable) {
      _addAll(nameToUse, value.map((dynamic v) => v.toString()));
    } else {
      _add(nameToUse, value.toString());
    }
  }

  @override
  void clear() => _headers.clear();

  @override
  void remove(String name, Object value) {
    if (value is Iterable) {
      _removeAll(name, value.map((dynamic v) => v.toString()));
    } else {
      _remove(name, value.toString());
    }
  }

  @override
  void removeAll(String name) => _headers.remove(name);

  @override
  void forEach(void Function(String name, List<String> values) action) =>
      _headers.forEach(action);

  @override
  String? value(String name) {
    if (_headers.containsKey(name) && _headers[name]!.isNotEmpty) {
      return _headers[name]!.first;
    }
    return null;
  }

  @override
  List<String>? operator [](String name) => _headers[name];
}
