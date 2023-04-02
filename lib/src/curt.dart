import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

///
///
///
class Curt {
  final String executable;
  final bool debug;
  final bool insecure;
  final bool silent;
  final bool followRedirects;
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
    this.timeout = 10000,
  });

  ///
  ///
  ///
  Future<Response> send(
    Uri uri, {
    required String method,
    Map<String, String> headers = const <String, String>{},
    String? data,
  }) async {
    List<String> args = <String>['-v', '-X', method];

    /// Insecure
    if (insecure) {
      args.add('-k');
    }

    /// Silent
    if (silent) {
      args.add('-s');
    }

    /// Follow Redirects
    if (followRedirects) {
      args.add('-L');
    }

    /// Headers
    for (final MapEntry<String, String> header in headers.entries) {
      args
        ..add('-H')
        ..add('${header.key}: ${header.value}');
    }

    /// Body data
    if (data != null) {
      args
        ..add('-d')
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
    ProcessResult run = await Process.run(executable, args).timeout(
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
    List<String> verboseLines = run.stderr.toString().split('\n');

    RegExp headerRegExp = RegExp('(?<key>.*?): (?<value>.*)');

    RegExp protocolRegExp = RegExp(r'HTTP(.*?) (?<statusCode>\d*)');

    int statusCode = -1;
    Map<String, String> responseHeaders = <String, String>{};

    for (final String verboseLine in verboseLines) {
      if (debug) {
        print(verboseLine);
      }

      if (verboseLine.isEmpty) {
        continue;
      }

      if (verboseLine.substring(0, 1) == '<') {
        String line = verboseLine.substring(2);

        RegExpMatch? match = headerRegExp.firstMatch(line);
        if (match != null) {
          responseHeaders[match.namedGroup('key').toString()] =
              match.namedGroup('value').toString();
          continue;
        }

        match = protocolRegExp.firstMatch(line);
        if (match != null) {
          statusCode =
              int.tryParse(match.namedGroup('statusCode').toString()) ?? -1;
        }
      }
    }

    return Response(
      run.stdout.toString(),
      statusCode,
      headers: responseHeaders,
    );
  }

  ///
  ///
  ///
  Future<Response> sendJson(
    Uri uri, {
    required String method,
    required Map<String, dynamic> body,
    Map<String, String> headers = const <String, String>{},
  }) {
    Map<String, String> newHeaders = Map<String, String>.of(headers);
    newHeaders['Content-Type'] = 'application/json';

    return send(
      uri,
      method: method,
      headers: newHeaders,
      data: json.encode(body),
    );
  }

  ///
  ///
  ///
  Future<Response> get(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
  }) =>
      send(uri, method: 'GET', headers: headers);

  ///
  ///
  ///
  Future<Response> post(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    String? data,
  }) =>
      send(uri, method: 'POST', headers: headers, data: data);

  ///
  ///
  ///
  Future<Response> postJson(
    Uri uri, {
    required Map<String, dynamic> body,
    Map<String, String> headers = const <String, String>{},
  }) =>
      sendJson(uri, method: 'POST', headers: headers, body: body);

  ///
  ///
  ///
  Future<Response> put(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    String? data,
  }) =>
      send(uri, method: 'PUT', headers: headers, data: data);

  ///
  ///
  ///
  Future<Response> putJson(
    Uri uri, {
    required Map<String, dynamic> body,
    Map<String, String> headers = const <String, String>{},
  }) =>
      sendJson(uri, method: 'PUT', headers: headers, body: body);

  ///
  ///
  ///
  Future<Response> delete(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
  }) =>
      send(uri, method: 'DELETE', headers: headers);
}
