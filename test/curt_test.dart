import 'dart:io';

import 'package:curt/src/curt_base.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

///
///
///
class BasicTestResult {
  final int statusCode;
  final Matcher headersMatcher;
  final Matcher bodyMatcher;

  ///
  ///
  ///
  BasicTestResult({
    required this.statusCode,
    required this.headersMatcher,
    required this.bodyMatcher,
  });
}

///
///
///
void main() {
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

    for (MapEntry<String, BasicTestResult> entry in tests.entries) {
      test('GET ${entry.key}', () async {
        Response response = await curt.get(entry.key);
        expect(response.statusCode, entry.value.statusCode);
        expect(response.headers, entry.value.headersMatcher);
        expect(response.body, entry.value.bodyMatcher);
      });

      test('DELETE ${entry.key}', () async {
        Response response = await curt.delete(entry.key);
        expect(response.statusCode, entry.value.statusCode);
        expect(response.headers, entry.value.headersMatcher);
        expect(response.body, entry.value.bodyMatcher);
      });
    }
  });

  ///
  group('Basic Local Tests', () {
    final Curt curt = Curt(insecure: true);
    final String server = '127.0.0.1';
    final int httpPort = 8080;
    final int httpsPort = 8443;
    final Duration timeLimit = const Duration(seconds: 15);

    final String containerImage = 'mendhak/http-https-echo:29';
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
        containerImage
      ]).timeout(timeLimit);

      expect(result.exitCode, 0, reason: result.stderr);

      /// Time to container starts.
      await Future.delayed(const Duration(seconds: 10));
    });

    ///
    test('Simple HTTP GET', () async {
      Response response = await curt.get('http://$server:$httpPort/');
      expect(response.statusCode, 200);
      expect(response.headers, isNotEmpty);
      expect(response.body, isNotEmpty);
    });

    ///
    test('Simple HTTP POST', () async {
      Response response = await curt.post('http://$server:$httpPort/');
      expect(response.statusCode, 200);
      expect(response.headers, isNotEmpty);
      expect(response.body, isNotEmpty);
    });

    ///
    test('Simple HTTPS GET', () async {
      Response response = await curt.get('https://$server:$httpsPort/');
      expect(response.statusCode, 200);
      expect(response.headers, isNotEmpty);
      expect(response.body, isNotEmpty);
    });

    ///
    test('Simple HTTPS POST', () async {
      Response response = await curt.post('https://$server:$httpsPort/');
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
  });
}
