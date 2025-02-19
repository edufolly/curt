import 'dart:io';

import 'package:curt/src/curt.dart';
import 'package:curt/src/curt_response.dart';
import 'package:test/test.dart';
import 'package:testainers/testainers.dart';

///
///
///
void main() {
  ///
  group(
    'Local Tests',
    () {
      final Curt curt = Curt();

      final Curt insecure = Curt(insecure: true);

      final Curt followRedirects = Curt(followRedirects: true);

      final TestainersHttpbucket container = TestainersHttpbucket();

      const Map<String, String> headers = <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      };

      const String server = 'localhost';

      ///
      setUpAll(() async {
        await container.start();
      });

      test('GET HTTP 200', () async {
        final CurtResponse response = await curt.get(
          Uri.parse('http://$server:${container.httpPort}/status/200'),
        );
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      test('GET HTTP 403', () async {
        final CurtResponse response = await curt.get(
          Uri.parse('http://$server:${container.httpPort}/status/403'),
        );
        expect(response.statusCode, 403);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      test('GET HTTP 404', () async {
        final CurtResponse response = await curt.get(
          Uri.parse('http://$server:${container.httpPort}/status/404'),
        );
        expect(response.statusCode, 404);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      test('GET HTTP 500', () async {
        final CurtResponse response = await curt.get(
          Uri.parse('http://$server:${container.httpPort}/status/500'),
        );
        expect(response.statusCode, 500);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      test('POST HTTP 200', () async {
        final CurtResponse response = await curt.post(
          Uri.parse('http://$server:${container.httpPort}/status/200'),
          headers: headers,
        );
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      test('POST HTTP 403', () async {
        final CurtResponse response = await curt.post(
          Uri.parse('http://$server:${container.httpPort}/status/403'),
          headers: headers,
        );
        expect(response.statusCode, 403);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      test('POST HTTP 404', () async {
        final CurtResponse response = await curt.post(
          Uri.parse('http://$server:${container.httpPort}/status/404'),
          headers: headers,
        );
        expect(response.statusCode, 404);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      test('POST HTTP 500', () async {
        final CurtResponse response = await curt.post(
          Uri.parse('http://$server:${container.httpPort}/status/500'),
          headers: headers,
        );
        expect(response.statusCode, 500);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      test('PUT HTTP 200', () async {
        final CurtResponse response = await curt.put(
          Uri.parse('http://$server:${container.httpPort}/status/200'),
          headers: headers,
        );
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      test('PUT HTTP 403', () async {
        final CurtResponse response = await curt.put(
          Uri.parse('http://$server:${container.httpPort}/status/403'),
          headers: headers,
        );
        expect(response.statusCode, 403);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      test('PUT HTTP 404', () async {
        final CurtResponse response = await curt.put(
          Uri.parse('http://$server:${container.httpPort}/status/404'),
          headers: headers,
        );
        expect(response.statusCode, 404);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      test('PUT HTTP 500', () async {
        final CurtResponse response = await curt.put(
          Uri.parse('http://$server:${container.httpPort}/status/500'),
          headers: headers,
        );
        expect(response.statusCode, 500);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      test('DELETE HTTP 200', () async {
        final CurtResponse response = await curt.delete(
          Uri.parse('http://$server:${container.httpPort}/status/200'),
          headers: headers,
        );
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      test('DELETE HTTP 403', () async {
        final CurtResponse response = await curt.delete(
          Uri.parse('http://$server:${container.httpPort}/status/403'),
          headers: headers,
        );
        expect(response.statusCode, 403);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      test('DELETE HTTP 404', () async {
        final CurtResponse response = await curt.delete(
          Uri.parse('http://$server:${container.httpPort}/status/404'),
          headers: headers,
        );
        expect(response.statusCode, 404);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      test('DELETE HTTP 500', () async {
        final CurtResponse response = await curt.delete(
          Uri.parse('http://$server:${container.httpPort}/status/500'),
          headers: headers,
        );
        expect(response.statusCode, 500);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      test('HEAD HTTP 200', () async {
        final CurtResponse response = await curt.head(
          Uri.parse('http://$server:${container.httpPort}/status/200'),
          headers: headers,
        );
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isEmpty);
      });

      test('HEAD HTTP 403', () async {
        final CurtResponse response = await curt.head(
          Uri.parse('http://$server:${container.httpPort}/status/403'),
          headers: headers,
        );
        expect(response.statusCode, 403);
        expect(response.headers, isNotEmpty);
        expect(response.body, isEmpty);
      });

      test('HEAD HTTP 404', () async {
        final CurtResponse response = await curt.head(
          Uri.parse('http://$server:${container.httpPort}/status/404'),
          headers: headers,
        );
        expect(response.statusCode, 404);
        expect(response.headers, isNotEmpty);
        expect(response.body, isEmpty);
      });

      test('HEAD HTTP 500', () async {
        final CurtResponse response = await curt.head(
          Uri.parse('http://$server:${container.httpPort}/status/500'),
          headers: headers,
        );
        expect(response.statusCode, 500);
        expect(response.headers, isNotEmpty);
        expect(response.body, isEmpty);
      });

      test('Body Length 123', () async {
        final CurtResponse response = await curt.get(
          Uri.parse('http://$server:${container.httpPort}/length/123'),
        );

        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.headers.contentLength, 123);
        expect(response.body, isNotEmpty);
        expect(response.body.length, 123);
      });

      test('Body Length 321', () async {
        final CurtResponse response = await curt.get(
          Uri.parse('http://$server:${container.httpPort}/length/321'),
        );

        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.headers.contentLength, 321);
        expect(response.body, isNotEmpty);
        expect(response.body.length, 321);
      });

      test('Body Length 1024', () async {
        final CurtResponse response = await curt.get(
          Uri.parse('http://$server:${container.httpPort}/length/1024'),
        );

        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.headers.contentLength, 1024);
        expect(response.body, isNotEmpty);
        expect(response.body.length, 1024);
      });

      test('Redirect with no follow', () async {
        final Uri uri = Uri(
          scheme: 'http',
          host: server,
          port: container.httpPort,
          path: 'redirect',
          queryParameters: <String, dynamic>{
            'url': 'http://$server:${container.httpPort}/status/200',
          },
        );

        final CurtResponse response = await curt.get(uri);

        expect(response.statusCode, 302);
        expect(response.headers, isNotEmpty);
        expect(
          response.headers.value(HttpHeaders.locationHeader),
          uri.queryParameters['url'],
        );
        expect(response.body, isEmpty);
      });

      test('Redirect', () async {
        final Uri uri = Uri(
          scheme: 'http',
          host: server,
          port: container.httpPort,
          path: 'redirect',
          queryParameters: <String, dynamic>{
            'url': 'http://$server:${container.httpPort}/status/200',
          },
        );

        final CurtResponse response = await followRedirects.get(uri);

        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.headers.value(HttpHeaders.locationHeader), isNull);
        expect(response.body, isNotEmpty);
      });

      test('Simple HTTPS GET', () async {
        final CurtResponse response = await insecure.get(
          Uri.parse('https://$server:${container.httpsPort}/status/200'),
        );
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      ///
      test('Simple HTTPS POST', () async {
        final CurtResponse response = await insecure.post(
          Uri.parse('https://$server:${container.httpsPort}/status/200'),
          headers: headers,
        );
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      ///
      test('Simple HTTPS PUT', () async {
        final CurtResponse response = await insecure.put(
          Uri.parse('https://$server:${container.httpsPort}/status/200'),
          headers: headers,
        );
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      ///
      test('Simple HTTPS DELETE', () async {
        final CurtResponse response = await insecure.delete(
          Uri.parse('https://$server:${container.httpsPort}/status/200'),
          headers: headers,
        );
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      ///
      test('Simple HTTPS HEAD', () async {
        final CurtResponse response = await insecure.head(
          Uri.parse('https://$server:${container.httpsPort}/status/200'),
          headers: headers,
        );
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        // expect(response.body, isEmpty);
      });

      ///
      tearDownAll(container.stop);
    },
    onPlatform: <String, dynamic>{
      'mac-os': const Skip('No docker installed on GitHub actions.'),
      'windows': const Skip('Need a windows container image.'),
    },
  );
}
