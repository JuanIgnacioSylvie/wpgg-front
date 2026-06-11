import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

const int payloadCryptoVersion = 1;
const int _aesKeyBytes = 32;
const int _gcmIvBytes = 12;

/// Encrypts a JSON-serializable [payload] with AES-256-GCM + RSA-OAEP (SHA-256).
Map<String, dynamic> encryptPayload(
  Map<String, dynamic> jwk,
  Object? payload,
) {
  final publicKey = _rsaPublicKeyFromJwk(jwk);
  final aesKey = _secureRandomBytes(_aesKeyBytes);
  final iv = _secureRandomBytes(_gcmIvBytes);
  final plaintext = utf8.encode(jsonEncode(payload ?? <String, dynamic>{}));

  final gcm = GCMBlockCipher(AESEngine())
    ..init(
      true,
      AEADParameters(
        KeyParameter(aesKey),
        128,
        iv,
        Uint8List(0),
      ),
    );
  final sealed = gcm.process(Uint8List.fromList(plaintext));

  final oaep = OAEPEncoding.withSHA256(RSAEngine())
    ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));
  final wrappedKey = oaep.process(aesKey);

  return {
    'v': payloadCryptoVersion,
    'key': base64.encode(wrappedKey),
    'iv': base64.encode(iv),
    'data': base64.encode(sealed),
  };
}

RSAPublicKey _rsaPublicKeyFromJwk(Map<String, dynamic> jwk) {
  final n = _base64UrlToBigInt(jwk['n'] as String);
  final e = _base64UrlToBigInt(jwk['e'] as String);
  return RSAPublicKey(n, e);
}

BigInt _base64UrlToBigInt(String value) {
  var normalized = value;
  final mod = normalized.length % 4;
  if (mod > 0) {
    normalized += '=' * (4 - mod);
  }
  final bytes = base64Url.decode(normalized);
  return _bytesToBigInt(bytes);
}

BigInt _bytesToBigInt(Uint8List bytes) {
  var result = BigInt.zero;
  for (final byte in bytes) {
    result = (result << 8) + BigInt.from(byte);
  }
  return result;
}

Uint8List _secureRandomBytes(int length) {
  final random = Random.secure();
  return Uint8List.fromList(
    List<int>.generate(length, (_) => random.nextInt(256)),
  );
}
