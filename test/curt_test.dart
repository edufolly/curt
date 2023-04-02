import 'dart:io';
import 'dart:math';

import 'package:curt/src/curt.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

import '../helpers/basic_test_result.dart';

///
///
///
void main() {
  ///
  group('Basic Tests', () {
    final Curt curt = Curt();

    Map<String, BasicTestResult> tests = <String, BasicTestResult>{
      'https://httpbin.org/status/200': BasicTestResult(
        statusCode: 200,
        headersMatcher: isNotEmpty,
        bodyMatcher: isEmpty,
      ),
      'https://httpbin.org/status/403': BasicTestResult(
        statusCode: 403,
        headersMatcher: isNotEmpty,
        bodyMatcher: isEmpty,
      ),
      'https://httpbin.org/status/404': BasicTestResult(
        statusCode: 404,
        headersMatcher: isNotEmpty,
        bodyMatcher: isEmpty,
      ),
      'https://httpbin.org/status/500': BasicTestResult(
        statusCode: 500,
        headersMatcher: isNotEmpty,
        bodyMatcher: isEmpty,
      ),
    };

    for (final MapEntry<String, BasicTestResult> entry in tests.entries) {
      test('GET ${entry.key}', () async {
        Response response = await curt.get(Uri.parse(entry.key));
        expect(response.statusCode, entry.value.statusCode);
        expect(response.headers, entry.value.headersMatcher);
        expect(response.body, entry.value.bodyMatcher);
      });

      test('POST ${entry.key}', () async {
        Response response = await curt.post(Uri.parse(entry.key));
        expect(response.statusCode, entry.value.statusCode);
        expect(response.headers, entry.value.headersMatcher);
        expect(response.body, entry.value.bodyMatcher);
      });

      test('PUT ${entry.key}', () async {
        Response response = await curt.put(Uri.parse(entry.key));
        expect(response.statusCode, entry.value.statusCode);
        expect(response.headers, entry.value.headersMatcher);
        expect(response.body, entry.value.bodyMatcher);
      });

      test('DELETE ${entry.key}', () async {
        Response response = await curt.delete(Uri.parse(entry.key));
        expect(response.statusCode, entry.value.statusCode);
        expect(response.headers, entry.value.headersMatcher);
        expect(response.body, entry.value.bodyMatcher);
      });
    }
  });

  ///
  group('Redirect Tests', () {
    final Curt curt = Curt(followRedirects: true);

    test('Redirect', () async {
      Uri uri = Uri(
        scheme: 'https',
        host: 'httpbin.org',
        path: 'redirect-to',
        queryParameters: <String, dynamic>{
          'url': 'https://httpbin.org/status/200',
        },
      );

      Response response = await curt.get(uri);

      expect(response.statusCode, 200);
      expect(response.headers, isNotEmpty);
      expect(response.headers.containsKey('location'), isFalse);
      expect(response.body, isEmpty);
    });
  });

  ///
  group('Body Size Tests', () {
    final Curt curt = Curt();

    for (int gen = 0; gen < 3; gen++) {
      int bytes = Random().nextInt(1024);
      test('Body Length $bytes', () async {
        Response response = await curt.get(
          Uri.parse('http://httpbin.org/range/$bytes'),
        );

        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.headers.containsKey('Content-Length'), isTrue);
        expect(
          int.tryParse(response.headers['Content-Length'].toString()) ?? -1,
          bytes,
        );
        expect(response.body, isNotEmpty);
        expect(response.body.length, bytes);
      });
    }
  });

  ///
  group(
    'Basic Local Tests',
    () {
      final Curt curt = Curt(insecure: true);
      const String server = '127.0.0.1';
      const int httpPort = 8080;
      const int httpsPort = 8443;
      const Duration timeLimit = Duration(seconds: 15);

      const String containerImage = 'mendhak/http-https-echo:29';
      final String containerName = 'server${DateTime.now().millisecond}';

      ///
      setUpAll(() async {
        ProcessResult result = await Process.run('docker', <String>[
          '--version',
        ]).timeout(timeLimit);

        expect(result.exitCode, 0, reason: result.stderr);

        result = await Process.run('docker', <String>[
          'run',
          '--rm',
          '--name',
          containerName,
          '-p',
          '$httpPort:8080',
          '-p',
          '$httpsPort:8443',
          '-d',
          containerImage,
        ]).timeout(timeLimit);

        expect(result.exitCode, 0, reason: result.stderr);

        /// Time to container starts.
        await Future<void>.delayed(const Duration(seconds: 10));
      });

      ///
      test('Simple HTTP GET', () async {
        Response response =
            await curt.get(Uri.parse('http://$server:$httpPort/'));
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      ///
      test('Simple HTTP POST', () async {
        Response response =
            await curt.post(Uri.parse('http://$server:$httpPort/'));
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      ///
      test('Simple HTTP PUT', () async {
        Response response =
            await curt.put(Uri.parse('http://$server:$httpPort/'));
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      ///
      test('Simple HTTP DELETE', () async {
        Response response =
            await curt.delete(Uri.parse('http://$server:$httpPort/'));
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      ///
      test('Simple HTTPS GET', () async {
        Response response =
            await curt.get(Uri.parse('https://$server:$httpsPort/'));
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      ///
      test('Simple HTTPS POST', () async {
        Response response =
            await curt.post(Uri.parse('https://$server:$httpsPort/'));
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      ///
      test('Simple HTTPS PUT', () async {
        Response response =
            await curt.put(Uri.parse('https://$server:$httpsPort/'));
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      ///
      test('Simple HTTPS DELETE', () async {
        Response response =
            await curt.delete(Uri.parse('https://$server:$httpsPort/'));
        expect(response.statusCode, 200);
        expect(response.headers, isNotEmpty);
        expect(response.body, isNotEmpty);
      });

      ///
      tearDownAll(() async {
        ProcessResult result = await Process.run('docker', <String>[
          'stop',
          containerName,
        ]).timeout(timeLimit);

        expect(result.exitCode, 0, reason: result.stderr);
      });
    },
    onPlatform: <String, dynamic>{
      'mac-os': Skip('No docker installed.'),
    },
  );
}
