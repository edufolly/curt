import 'dart:io';

import 'package:http/http.dart';

///
///
///
class Curt {
  final String executable;
  final bool debug;
  final bool insecure;
  final int timeout;

  ///
  ///
  ///
  Curt({
    this.executable = 'curl',
    this.debug = false,
    this.insecure = false,
    this.timeout = 10000,
  });

  ///
  ///
  ///
  Future<Response> get(String url) async {
    List<String> args = <String>['-v'];

    if (insecure) {
      args.add('-k');
    }

    args.add(url);

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

    List<String> verboseLines = run.stderr.toString().split('\n');

    RegExp headerRegExp = RegExp(r'(?<key>.*?): (?<value>.*)');

    RegExp protocolRegExp = RegExp(r'HTTP(.*?) (?<statusCode>\d*)');

    int statusCode = -1;
    Map<String, String> headers = <String, String>{};

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
          headers[match.namedGroup('key').toString()] =
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

    String body = run.stdout.toString();

    return Response(body, statusCode, headers: headers);
  }
}
