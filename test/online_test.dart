import 'package:curt/curt.dart';
import 'package:test/test.dart';

///
///
///
void main() {
  ///
  group('Online Tests', () {
    final Curt curt = Curt(debug: true);

    test('GET https://google.com', () async {
      final CurtResponse response = await curt.get(
        Uri.parse('https://google.com'),
      );
      expect(response.statusCode, 301);
      expect(response.headers, isNotEmpty);
      expect(response.body, isNotEmpty);
    });

    test('HEAD https://google.com.br', () async {
      final CurtResponse response = await curt.head(
        Uri.parse('https://google.com.br'),
      );
      expect(response.statusCode, 301);
      expect(response.headers, isNotEmpty);
      expect(response.body, isEmpty);
    });
  });
}
