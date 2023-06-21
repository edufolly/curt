// ignore_for_file: avoid_print

import 'package:curt/curt.dart';

///
///
///
void main() async {
  final Curt curt = Curt();
  final CurtResponse response = await curt.get(Uri.parse('https://google.com'));
  print('Status Code: ${response.statusCode}');
  print('Headers: ${response.headers}');
  print('Body:\n${response.body}');
}
