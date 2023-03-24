import 'package:curt/curt.dart';
import 'package:http/http.dart';

///
///
///
void main() async {
  final Curt curt = Curt();
  Response response = await curt.get('https://google.com');
  print('Status Code: ${response.statusCode}');
  print('Headers: ${response.headers}');
  print('Body:\n${response.body}');
}
