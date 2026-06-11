import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:pointycastle/export.dart';

import 'package:wpgg_flutter/core/crypto/payload_crypto.dart';

void main() {
  test('encryptPayload produces v1 envelope with base64 fields', () {
    final pair = _generateRsaKeyPair();
    final jwk = _publicJwkFromKey(pair.publicKey);
    final envelope = encryptPayload(jwk, {
      'email': 'a@b.com',
      'password': 'hunter2',
    });

    expect(envelope['v'], payloadCryptoVersion);
    expect(envelope['key'], isA<String>());
    expect(envelope['iv'], isA<String>());
    expect(envelope['data'], isA<String>());
    expect((envelope['key'] as String).isNotEmpty, isTrue);
  });
}

AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> _generateRsaKeyPair() {
  final secureRandom = FortunaRandom();
  final seed = List<int>.generate(32, (i) => i);
  secureRandom.seed(KeyParameter(Uint8List.fromList(seed)));

  final keyGen = RSAKeyGenerator()
    ..init(
      ParametersWithRandom(
        RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64),
        secureRandom,
      ),
    );
  final pair = keyGen.generateKeyPair();
  return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(
    pair.publicKey as RSAPublicKey,
    pair.privateKey as RSAPrivateKey,
  );
}

Map<String, dynamic> _publicJwkFromKey(RSAPublicKey key) {
  return {
    'kty': 'RSA',
    'n': _bigIntToBase64Url(key.modulus!),
    'e': _bigIntToBase64Url(key.exponent!),
  };
}

String _bigIntToBase64Url(BigInt value) {
  var bytes = _bigIntToBytes(value);
  while (bytes.length > 1 && bytes[0] == 0) {
    bytes = bytes.sublist(1);
  }
  return base64Url.encode(bytes).replaceAll('=', '');
}

Uint8List _bigIntToBytes(BigInt value) {
  if (value == BigInt.zero) {
    return Uint8List.fromList([0]);
  }
  final hex = value.toRadixString(16);
  final padded = hex.length.isOdd ? '0$hex' : hex;
  return Uint8List.fromList(
    List.generate(
      padded.length ~/ 2,
      (i) => int.parse(padded.substring(i * 2, i * 2 + 2), radix: 16),
    ),
  );
}
