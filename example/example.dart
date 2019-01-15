// Copyright (c) 2018, Rashed Mohammed.
//
// Please see the included LICENSE file for more information.

import 'package:keccak/keccak.dart';
import 'dart:typed_data';
import 'package:convert/convert.dart';

void main() {
  // get the input
  String input = "";

  // convert input data into byte array (or) Uint8List
  var inputData = Uint8List.fromList(input.codeUnits);

  // compute the keccak hash
  // optionally specify the outputSize which should be
  // less than or equal to 32.
  var outputHashData = keccak(inputData);

  // if needed convert the output byte array into hex string.
  var output = hex.encode(outputHashData);
}