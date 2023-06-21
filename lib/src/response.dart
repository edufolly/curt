import 'dart:io';
import 'package:curt/src/http_headers.dart';
import 'package:http/http.dart';

class CurtResponse {
  final String body;
  final int statusCode;
  final CurtHttpHeaders headers;
  final List<Cookie> cookies;

  CurtResponse(this.body, this.statusCode, {required this.headers})
      : cookies = headers.cookies;
}
