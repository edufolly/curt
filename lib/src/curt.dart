// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:curt/src/curt_http_headers.dart';
import 'package:curt/src/curt_method.dart';
import 'package:curt/src/curt_response.dart';

///
///
///
class Curt {
  static const String opensslConfigOverridePath = '/tmp/curt-openssl.cnf';

  final Map<String, String> environment = <String, String>{};
  final String executable;
  final bool debug;
  final bool insecure;
  final bool silent;
  final bool followRedirects;
  final int? maxRedirects;
  final bool linuxOpensslTLSOverride;
  final int timeout;

  ///
  ///
  ///
  Curt({
    this.executable = 'curl',
    this.debug = false,
    this.insecure = false,
    this.silent = true,
    this.followRedirects = false,
    this.maxRedirects,
    this.linuxOpensslTLSOverride = false,
    this.timeout = 10000,
  }) {
    /// https://askubuntu.com/questions/1250787/when-i-try-to-curl-a-website-i-get-ssl-error
    /// This openssl problem can happen on any distro with curl linking
    /// dynamically to openssl, even though the link is specific to ubuntu.
    /// The workaround here is to create a config override for openssl, and run
    /// curl with that config override - this will allow TLS v1.0 and v1.1
    /// requests to work, which are blocked by openssl, NOT curl
    if (Platform.isLinux && linuxOpensslTLSOverride) {
      final StringBuffer buffer = StringBuffer()
        ..writeln('openssl_conf = openssl_init')
        ..writeln('[openssl_init]')
        ..writeln('ssl_conf = ssl_sect')
        ..writeln('[ssl_sect]')
        ..writeln('system_default = system_default_sect')
        ..writeln('[system_default_sect]')
        ..writeln('CipherString = DEFAULT@SECLEVEL=1');

      File(opensslConfigOverridePath)
        ..createSync(recursive: true)
        ..writeAsStringSync(buffer.toString());

      environment['OPENSSL_CONF'] = opensslConfigOverridePath;
    }
  }

  ///
  ///
  ///
  Future<CurtResponse> send(
    Uri uri, {
    required CurtMethod method,
    Map<String, String> headers = const <String, String>{},
    List<Cookie> cookies = const <Cookie>[],
    String? data,
  }) async {
    final List<String> args = <String>['--verbose'];

    switch (method) {
      case CurtMethod.HEAD:
        args.add('--head');
        break;
      default:
        args
          ..add('--request')
          ..add(method.name);
        break;
    }

    /// Insecure
    if (insecure) {
      args.add('--insecure');
    }

    /// Silent
    if (silent) {
      args.add('--silent');
    }

    /// Follow Redirects
    if (followRedirects) {
      args.add('--location');

      if (maxRedirects != null) {
        args
          ..add('--max-redirs')
          ..add('$maxRedirects');
      }
    }

    /// Headers
    for (final MapEntry<String, String> header in headers.entries) {
      args
        ..add('--header')
        ..add('${header.key}: ${header.value}');
    }

    /// Cookies
    for (final Cookie cookie in cookies) {
      args
        ..add('--cookie')
        ..add('${cookie.name}=${cookie.value}');
    }

    /// Body data
    if (data != null) {
      args
        ..add('--data')
        ..add(data);
    }

    /// URL
    args.add(uri.toString());

    if (debug) {
      print('$executable ${args.join(' ')}');
    }

    ///
    /// Run
    ///
    final ProcessResult run = await Process.run(
      executable,
      args,
      environment: environment,
    ).timeout(
      Duration(
        milliseconds: timeout,
      ),
    );

    if (run.exitCode != 0) {
      if (debug) {
        print('Exit Code: ${run.exitCode}');
        print(run.stdout);
        print(run.stderr);
      }
      throw Exception('Error: ${run.exitCode} - ${run.stderr}');
    }

    ///
    /// Parse
    ///
    final List<String> verboseLines = run.stderr.toString().split('\n');

    final RegExp headerRegExp = RegExp('(?<key>.*?): (?<value>.*)');

    final RegExp protocolRegExp = RegExp(r'HTTP(.*?) (?<statusCode>\d*)');

    int statusCode = -1;

    final CurtHttpHeaders responseHeaders = CurtHttpHeaders();

    for (final String verboseLine in verboseLines) {
      if (debug) {
        print(verboseLine);
      }

      if (verboseLine.isEmpty) {
        continue;
      }

      if (verboseLine.substring(0, 1) == '<') {
        final String line = verboseLine.substring(2);

        RegExpMatch? match = headerRegExp.firstMatch(line);
        if (match != null) {
          responseHeaders.add(
            match.namedGroup('key').toString(),
            match.namedGroup('value').toString(),
          );
          continue;
        }

        match = protocolRegExp.firstMatch(line);
        if (match != null) {
          statusCode =
              int.tryParse(match.namedGroup('statusCode').toString()) ?? -1;
          responseHeaders.clear();
        }
      }
    }

    return CurtResponse(
      method == CurtMethod.HEAD ? '' : run.stdout.toString(),
      statusCode,
      headers: responseHeaders,
    );
  }

  ///
  ///
  ///
  Future<CurtResponse> sendJson(
    Uri uri, {
    required CurtMethod method,
    required Map<String, dynamic> body,
    Map<String, String> headers = const <String, String>{},
    List<Cookie> cookies = const <Cookie>[],
    String contentType = 'application/json',
  }) {
    final Map<String, String> newHeaders = Map<String, String>.of(headers);
    newHeaders['Content-Type'] = contentType;

    return send(
      uri,
      method: method,
      headers: newHeaders,
      cookies: cookies,
      data: json.encode(body),
    );
  }

  ///
  ///
  ///
  Future<CurtResponse> get(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    List<Cookie> cookies = const <Cookie>[],
  }) =>
      send(uri, method: CurtMethod.GET, headers: headers, cookies: cookies);

  ///
  ///
  ///
  Future<CurtResponse> post(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    List<Cookie> cookies = const <Cookie>[],
    String? data,
  }) =>
      send(
        uri,
        method: CurtMethod.POST,
        headers: headers,
        data: data,
        cookies: cookies,
      );

  ///
  ///
  ///
  Future<CurtResponse> postJson(
    Uri uri, {
    required Map<String, dynamic> body,
    Map<String, String> headers = const <String, String>{},
    List<Cookie> cookies = const <Cookie>[],
    String contentType = 'application/json',
  }) =>
      sendJson(
        uri,
        method: CurtMethod.POST,
        headers: headers,
        body: body,
        cookies: cookies,
        contentType: contentType,
      );

  ///
  ///
  ///
  Future<CurtResponse> put(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    List<Cookie> cookies = const <Cookie>[],
    String? data,
  }) =>
      send(
        uri,
        method: CurtMethod.PUT,
        headers: headers,
        data: data,
        cookies: cookies,
      );

  ///
  ///
  ///
  Future<CurtResponse> putJson(
    Uri uri, {
    required Map<String, dynamic> body,
    Map<String, String> headers = const <String, String>{},
    List<Cookie> cookies = const <Cookie>[],
    String contentType = 'application/json',
  }) =>
      sendJson(
        uri,
        method: CurtMethod.PUT,
        headers: headers,
        body: body,
        cookies: cookies,
        contentType: contentType,
      );

  ///
  ///
  ///
  Future<CurtResponse> delete(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    List<Cookie> cookies = const <Cookie>[],
  }) =>
      send(uri, method: CurtMethod.DELETE, headers: headers, cookies: cookies);

  ///
  ///
  ///
  Future<CurtResponse> head(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    List<Cookie> cookies = const <Cookie>[],
  }) =>
      send(uri, method: CurtMethod.HEAD, headers: headers, cookies: cookies);
}
