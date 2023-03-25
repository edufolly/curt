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
  final int timeout;

  ///
  ///
  ///
  Curt({
    this.executable = 'curl',
    this.debug = false,
    this.insecure = false,
    this.silent = true,
    this.timeout = 10000,
  });

  ///
  ///
  ///
  List<String> _curlBase(Map<String, String> headers) {
    List<String> args = <String>['-v'];

    if (insecure) {
      args.add('-k');
    }

    if (silent) {
      args.add('-s');
    }

    for (final MapEntry<String, String> header in headers.entries) {
      args
        ..add('-H')
        ..add('"${header.key}: ${header.value}"');
    }

    return args;
  }

  ///
  ///
  ///
  Future<Response> _run(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    List<String> extra = const <String>[],
  }) async {
    List<String> args = _curlBase(headers);

    args.addAll(extra);

    args.add(uri.toString());

    if (debug) {
      print('$executable ${args.join(' ')}');
    }

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

    return _parseResponse(run.stderr.toString(), run.stdout.toString());
  }

  ///
  ///
  ///
  Response _parseResponse(String control, String body) {
    List<String> verboseLines = control.split('\n');

    RegExp headerRegExp = RegExp(r'(?<key>.*?): (?<value>.*)');

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

    return Response(body, statusCode, headers: responseHeaders);
  }

  ///
  ///
  ///
  Future<Response> get(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
  }) async =>
      _run(uri, headers: headers);

  ///
  ///
  ///
  Future<Response> post(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    String? data,
  }) async {
    List<String> extra = <String>['-X', 'POST'];

    if (data != null) {
      extra
        ..add('-d')
        ..add(data);
    }

    return _run(uri, headers: headers, extra: extra);
  }

  ///
  ///
  ///
  Future<Response> postJson(
    Uri uri, {
    required Map<String, dynamic> body,
    Map<String, String> headers = const <String, String>{},
  }) async {
    Map<String, String> newHeaders = Map.of(headers);
    newHeaders['Content-Type'] = 'application/json';
    return post(uri, headers: newHeaders, data: json.encode(body));
  }

  ///
  ///
  ///
  Future<Response> delete(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
  }) async =>
      _run(uri, headers: headers, extra: ['-X', 'DELETE']);
}
