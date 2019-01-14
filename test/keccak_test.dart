import 'package:flutter_test/flutter_test.dart';

import 'package:keccak/keccak.dart';
import 'dart:typed_data';
import 'package:convert/convert.dart';

void main() {
  test('compute keccak hashes', () {
    expect(hex.encode(Keccak.keccak(Uint8List.fromList("".codeUnits))),
        "c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470");
    expect(
        hex.encode(Keccak.keccak(Uint8List.fromList(
            "The quick brown fox jumps over the lazy dog".codeUnits))),
        "4d741b6f1eb29cb2a9b9911c82f56fa8d73b04959d3d9d222895df6c0b28aa15");
    expect(
        hex.encode(Keccak.keccak(Uint8List.fromList(
            "The quick brown fox jumps over the lazy dog.".codeUnits))),
        "578951e24efd62a3d63a86f7cd19aaa53c898fe287d2552133220370240b572d");
    expect(
        hex.encode(Keccak.keccak(Uint8List.fromList(
            "I'd just like to interject for a moment. What you're referring to as Linux, is in fact, GNU/Linux, or as I've recently taken to calling it, GNU plus Linux. Linux is not an operating system unto itself"
                .codeUnits))),
        "d6a63dc2e3ab16360c1dd26fa4b343af9dde6b4ae275793b1d64eaffdc02f1d9");
    expect(
        hex.encode(Keccak.keccak(Uint8List.fromList([
          0,
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          24,
          25,
          26,
          27,
          28,
          29,
          30,
          31,
        ]))),
        "8ae1aa597fa146ebd3aa2ceddf360668dea5e526567e92b0321816a4e895bd2d");
    expect(() => Keccak.keccak(null), throwsNoSuchMethodError);
  });
}
