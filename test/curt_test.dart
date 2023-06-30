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
    'Basic Tests',
    () {
      final Curt curt = Curt();

      final TestainersHttpBin container = TestainersHttpBin();

      const String scheme = 'http';
      const String server = '127.0.0.1';

      ///
      setUpAll(() async {
        await container.start();
      });

      test('GET $scheme://$server:${container.httpPort}/status/200', () async {
        final CurtResponse response = await curt.get(
          Uri.parse('$scheme://$server:${container.httpPort}/status/200'),
        );
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isEmpty);
      });

      test('GET $scheme://$server:${container.httpPort}/status/403', () async {
        final CurtResponse response = await curt.get(
          Uri.parse('$scheme://$server:${container.httpPort}/status/403'),
        );
        expect(response.statusCode, 403);
        expect(response.headers, isNotEmpty);
        expect(response.body, isEmpty);
      });

      test('GET $scheme://$server:${container.httpPort}/status/404', () async {
        final CurtResponse response = await curt.get(
          Uri.parse('$scheme://$server:${container.httpPort}/status/404'),
        );
        expect(response.statusCode, 404);
        expect(response.headers, isNotEmpty);
        expect(response.body, isEmpty);
      });

      test('GET $scheme://$server:${container.httpPort}/status/500', () async {
        final CurtResponse response = await curt.get(
          Uri.parse('$scheme://$server:${container.httpPort}/status/500'),
        );
        expect(response.statusCode, 500);
        expect(response.headers, isNotEmpty);
        expect(response.body, isEmpty);
      });

      test('POST $scheme://$server:${container.httpPort}/status/200', () async {
        final CurtResponse response = await curt.post(
          Uri.parse('$scheme://$server:${container.httpPort}/status/200'),
        );
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isEmpty);
      });

      test('POST $scheme://$server:${container.httpPort}/status/403', () async {
        final CurtResponse response = await curt.post(
          Uri.parse('$scheme://$server:${container.httpPort}/status/403'),
        );
        expect(response.statusCode, 403);
        expect(response.headers, isNotEmpty);
        expect(response.body, isEmpty);
      });

      test('POST $scheme://$server:${container.httpPort}/status/404', () async {
        final CurtResponse response = await curt.post(
          Uri.parse('$scheme://$server:${container.httpPort}/status/404'),
        );
        expect(response.statusCode, 404);
        expect(response.headers, isNotEmpty);
        expect(response.body, isEmpty);
      });

      test('POST $scheme://$server:${container.httpPort}/status/500', () async {
        final CurtResponse response = await curt.post(
          Uri.parse('$scheme://$server:${container.httpPort}/status/500'),
        );
        expect(response.statusCode, 500);
        expect(response.headers, isNotEmpty);
        expect(response.body, isEmpty);
      });

      test('PUT $scheme://$server:${container.httpPort}/status/200', () async {
        final CurtResponse response = await curt.put(
          Uri.parse('$scheme://$server:${container.httpPort}/status/200'),
        );
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isEmpty);
      });

      test('PUT $scheme://$server:${container.httpPort}/status/403', () async {
        final CurtResponse response = await curt.put(
          Uri.parse('$scheme://$server:${container.httpPort}/status/403'),
        );
        expect(response.statusCode, 403);
        expect(response.headers, isNotEmpty);
        expect(response.body, isEmpty);
      });

      test('PUT $scheme://$server:${container.httpPort}/status/404', () async {
        final CurtResponse response = await curt.put(
          Uri.parse('$scheme://$server:${container.httpPort}/status/404'),
        );
        expect(response.statusCode, 404);
        expect(response.headers, isNotEmpty);
        expect(response.body, isEmpty);
      });

      test('PUT $scheme://$server:${container.httpPort}/status/500', () async {
        final CurtResponse response = await curt.put(
          Uri.parse('$scheme://$server:${container.httpPort}/status/500'),
        );
        expect(response.statusCode, 500);
        expect(response.headers, isNotEmpty);
        expect(response.body, isEmpty);
      });

      test('DELETE $scheme://$server:${container.httpPort}/status/200',
          () async {
        final CurtResponse response = await curt.delete(
          Uri.parse('$scheme://$server:${container.httpPort}/status/200'),
        );
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isEmpty);
      });

      test('DELETE $scheme://$server:${container.httpPort}/status/403',
          () async {
        final CurtResponse response = await curt.delete(
          Uri.parse('$scheme://$server:${container.httpPort}/status/403'),
        );
        expect(response.statusCode, 403);
        expect(response.headers, isNotEmpty);
        expect(response.body, isEmpty);
      });

      test('DELETE $scheme://$server:${container.httpPort}/status/404',
          () async {
        final CurtResponse response = await curt.delete(
          Uri.parse('$scheme://$server:${container.httpPort}/status/404'),
        );
        expect(response.statusCode, 404);
        expect(response.headers, isNotEmpty);
        expect(response.body, isEmpty);
      });

      test('DELETE $scheme://$server:${container.httpPort}/status/500',
          () async {
        final CurtResponse response = await curt.delete(
          Uri.parse('$scheme://$server:${container.httpPort}/status/500'),
        );
        expect(response.statusCode, 500);
        expect(response.headers, isNotEmpty);
        expect(response.body, isEmpty);
      });

      test('Body Length 123', () async {
        final CurtResponse response = await curt.get(
          Uri.parse('$scheme://$server:${container.httpPort}/range/123'),
        );

        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.headers.contentLength, 123);
        expect(response.body, isNotEmpty);
        expect(response.body.length, 123);
      });

      test('Body Length 321', () async {
        final CurtResponse response = await curt.get(
          Uri.parse('$scheme://$server:${container.httpPort}/range/321'),
        );

        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.headers.contentLength, 321);
        expect(response.body, isNotEmpty);
        expect(response.body.length, 321);
      });

      test('Body Length 999', () async {
        final CurtResponse response = await curt.get(
          Uri.parse('$scheme://$server:${container.httpPort}/range/999'),
        );

        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.headers.contentLength, 999);
        expect(response.body, isNotEmpty);
        expect(response.body.length, 999);
      });

      test('Redirect', () async {
        final Curt curt = Curt(followRedirects: true);

        final Uri uri = Uri(
          scheme: scheme,
          host: server,
          port: container.httpPort,
          path: 'redirect-to',
          queryParameters: <String, dynamic>{
            'url': '$scheme://$server:${container.httpPort}/status/200',
          },
        );

        final CurtResponse response = await curt.get(uri);

        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.headers.value(HttpHeaders.locationHeader), isNull);
        expect(response.body, isEmpty);
      });

      ///
      tearDownAll(container.stop);
    },
    onPlatform: <String, dynamic>{
      'mac-os': const Skip('No docker installed on GitHub actions.'),
      'windows': const Skip('Need a windows container image.'),
    },
  );

  ///
  group(
    'Basic Local Tests',
    () {
      final Curt curt = Curt(insecure: true);

      final TestainersHttpHttpsEcho container = TestainersHttpHttpsEcho();

      const String server = '127.0.0.1';

      ///
      setUpAll(() async {
        await container.start();
      });

      ///
      test('Simple HTTP GET', () async {
        final CurtResponse response =
            await curt.get(Uri.parse('http://$server:${container.httpPort}/'));
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      ///
      test('Simple HTTP POST', () async {
        final CurtResponse response =
            await curt.post(Uri.parse('http://$server:${container.httpPort}/'));
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      ///
      test('Simple HTTP PUT', () async {
        final CurtResponse response =
            await curt.put(Uri.parse('http://$server:${container.httpPort}/'));
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      ///
      test('Simple HTTP DELETE', () async {
        final CurtResponse response = await curt
            .delete(Uri.parse('http://$server:${container.httpPort}/'));
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      ///
      test('Simple HTTPS GET', () async {
        final CurtResponse response = await curt
            .get(Uri.parse('https://$server:${container.httpsPort}/'));
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      ///
      test('Simple HTTPS POST', () async {
        final CurtResponse response = await curt
            .post(Uri.parse('https://$server:${container.httpsPort}/'));
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      ///
      test('Simple HTTPS PUT', () async {
        final CurtResponse response = await curt
            .put(Uri.parse('https://$server:${container.httpsPort}/'));
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      ///
      test('Simple HTTPS DELETE', () async {
        final CurtResponse response = await curt
            .delete(Uri.parse('https://$server:${container.httpsPort}/'));
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
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
