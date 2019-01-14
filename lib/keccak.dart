// Copyright (c) 2018, Rashed Mohammed.
//
// Please see the included LICENSE file for more information.

library keccak;

import 'dart:typed_data';
import 'dart:math';
import 'src/constants.dart';

class Keccak {
  static int _logicalShiftRight(int val, int n) =>
      (val >> n) & ~(-1 << (64 - n));

  static int _rotl64(int x, int y) {
    return ((x << y) | _logicalShiftRight(x, (64 - y)));
  }

  static void _keccakf(Uint64List st, [int rounds = KECCAK_ROUNDS]) {
    int t;
    Uint64List bc = Uint64List(5);

    for (int round = 0; round < rounds; round++) {
      // Theta
      for (int i = 0; i < 5; i++) {
        bc[i] = st[i] ^ st[i + 5] ^ st[i + 10] ^ st[i + 15] ^ st[i + 20];
      }

      for (int i = 0; i < 5; i++) {
        t = bc[(i + 4) % 5] ^ _rotl64(bc[(i + 1) % 5], 1);
        for (int j = 0; j < 25; j += 5) {
          st[j + i] ^= t;
        }
      }

      // Rho Pi
      t = st[1];
      for (int i = 0; i < 24; i++) {
        int j = keccakPiln[i];
        bc[0] = st[j];
        st[j] = _rotl64(t, keccakRotc[i]);
        t = bc[0];
      }

      // Chi
      for (int j = 0; j < 25; j += 5) {
        for (int i = 0; i < 5; i++) {
          bc[i] = st[j + i];
        }
        for (int i = 0; i < 5; i++) {
          st[j + i] ^= (~bc[(i + 1) % 5]) & bc[(i + 2) % 5];
        }
      }

      // Iota
      st[0] ^= keccakRoundConstants[round];
    }
  }

  /*
    Compute a hash of length outputSize from input 
  */
  static Uint8List _keccak(Uint8List input, int outputSize) {
    Uint64List st = Uint64List(25);
    Uint8List temp = Uint8List(144);
    ByteData inp = input.buffer.asByteData();

    int inlen = input.length;
    int offset = 0; // Offset of input array

    int rsiz, rsizw;

    rsiz =
        st.lengthInBytes == outputSize ? HASH_DATA_AREA : 200 - 2 * outputSize;
    rsizw = rsiz ~/ 8;

    for (; inlen >= rsiz; inlen -= rsiz, offset += rsiz) {
      for (int i = 0; i < rsizw; i++) {
        st[i] ^= inp.getUint64(offset + (i * 8), Endian.host);
      }
      _keccakf(st, KECCAK_ROUNDS);
    }

    for (int i = 0; i < inlen; i++) {
      temp[i] = input[offset + i];
    }
    temp[inlen++] = 1;
    for (int i = 0; i < rsiz - inlen; i++) {
      temp[inlen + i] = 0;
    }
    temp[rsiz - 1] |= 0x80;

    ByteData tempData = temp.buffer.asByteData();
    for (int i = 0; i < rsizw; i++) {
      st[i] ^= tempData.getUint64(i * 8, Endian.host);
    }

    _keccakf(st, KECCAK_ROUNDS);

    Uint8List output = st.buffer.asUint8List(0, outputSize);

    return output;
  }

  /* 
    Hashes the given input with keccak, into an output hash of 200 bytes. 
  */
  static Uint8List keccak1600(Uint8List input) {
    return _keccak(input, 200);
  }

  /* 
    Hashes the given input with keccak, into an output hash of 32 bytes.
    Copies outputLength bytes of the output and returns it. Output
    length cannot be larger than 32.
  */
  static Uint8List keccak(Uint8List input, [int outputLength = 32]) {
    if (outputLength > 32) {
      throw ArgumentError("Output length must be 32 bytes or less!");
    }

    Uint8List result = _keccak(input, 32);

    Uint8List output = Uint8List(outputLength);

    for (int i = 0; i < min(outputLength, 32); i++) {
      output[i] = result[i];
    }

    return output;
  }
}
