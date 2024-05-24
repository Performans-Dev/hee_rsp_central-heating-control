import 'package:central_heating_control/app/core/utils/osk/enum.dart';
import 'package:flutter/material.dart';

class OskKeyModel {
  int row;
  int column;
  KeyType keyType;
  String? value;
  dynamic display;
  OskType layoutType;

  OskKeyModel({
    required this.row,
    required this.column,
    required this.keyType,
    this.value,
    required this.display,
    required this.layoutType,
  });
}
