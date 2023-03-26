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
