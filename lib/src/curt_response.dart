import 'dart:io';
import 'package:curt/src/curt_http_headers.dart';

///
///
///
class CurtResponse {
  final String body;
  final int statusCode;
  final CurtHttpHeaders headers;
  final List<Cookie> cookies;

  ///
  ///
  ///
  CurtResponse(
    this.body,
    this.statusCode, {
    required this.headers,
  }) : cookies = headers.cookies;

  ///
  ///
  ///
  CurtResponse.onError({this.body = '', this.statusCode = 500})
      : headers = CurtHttpHeaders(),
        cookies = <Cookie>[];
}
