# curt

[![Build With Love](https://img.shields.io/badge/%20built%20with-%20%E2%9D%A4-ff69b4.svg)](https://github.com/edufolly/curt/stargazers)
[![Pub Package](https://img.shields.io/pub/v/curt?color=orange)](https://pub.dev/packages/curt)
[![Licence](https://img.shields.io/github/license/edufolly/curt?color=blue)](https://github.com/edufolly/curt/blob/main/LICENSE)
[![Build](https://img.shields.io/github/actions/workflow/status/edufolly/curt/main.yml?branch=main)](https://github.com/edufolly/curt/releases/latest)
[![Coverage Report](https://img.shields.io/badge/coverage-report-C08EA1)](https://edufolly.github.io/curt/coverage/)

A convenient package that allows developers to interact with the curl command
within elegance of the Dart programming language.

This wrapper simplifies the process of sending HTTP requests, handling
responses, and managing data transfers, providing a more intuitive and efficient
way to work with curl functionality in the Dart ecosystem. By encapsulating the
complexity of curl within a straightforward wrapper, developers can leverage its
power and flexibility while benefiting from the simplicity and elegance of the
Dart programming language.

## Funding

Your contribution will help drive the development of quality tools for the
Flutter and Dart developer community. Any amount will be appreciated. Thank you
for your continued support!

[![BuyMeACoffee](https://www.buymeacoffee.com/assets/img/guidelines/download-assets-sm-2.svg)](https://www.buymeacoffee.com/edufolly)

## PIX

Sua contribuição ajudará a impulsionar o desenvolvimento de ferramentas de
qualidade para a comunidade de desenvolvedores Flutter e Dart. Qualquer quantia
será apreciada. Obrigado pelo seu apoio contínuo!

[![PIX](helpers/pix.png)](https://nubank.com.br/pagar/2bt2q/RBr4Szfuwr)

## Motivation

Allow https connections with TLS less than 1.2 through [curl](https://curl.se/).

Legacy systems or older applications that rely on older TLS versions for
compatibility reasons. These systems might not have been upgraded to support TLS
1.2 or higher due to various constraints, such as limited resources, technical
limitations, or compatibility issues with certain dependencies. In such cases,
allowing HTTPS connections with TLS versions less than 1.2 through curl would
enable these systems to continue functioning without major modifications.

Certain devices or environments might enforce outdated TLS configurations due to
specific security policies or restrictions. These networks may still rely on
older TLS versions for various reasons, such as interoperability with legacy
systems or compliance with specific regulations. Allowing curl to establish
HTTPS connections with TLS versions less than 1.2 would ensure compatibility and
connectivity in these constrained environments.

However, it's important to note that TLS versions prior to 1.2 (such as TLS 1.0
and TLS 1.1) are considered less secure and potentially vulnerable to various
security threats. TLS 1.2 introduced significant improvements in terms of
security, encryption algorithms, and cryptographic protocols. Therefore, it's
generally recommended to use TLS 1.2 or higher for secure communications.

## Example

```dart
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
```
