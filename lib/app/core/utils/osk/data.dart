import 'package:central_heating_control/app/core/utils/osk/enum.dart';
import 'package:central_heating_control/app/core/utils/osk/model.dart';
import 'package:flutter/material.dart';

final List<List<String>> lowercaseKeys = [
  ["q", "w", "e", "r", "t", "y", "u", "ı", "o", "p", "ğ", "ü"],
  ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ş", "i"],
  ["z", "x", "c", "v", "b", "n", "m", "ö", "ç"]
];

final List<List<String>> numericKeys = [
  ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "!", "?"],
  ["@", "#", "\$", "%", "*", "(", ")", "'", "\"", "≠", "‴"],
  ["%", "_", "+", "=", "/", ";", ":", ",", "."]
];

final List<List<String>> numericKeys2 = [
  ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "!", "?"],
  ["€", "£", "¥", "_", "[", "]", "{", "}", "ˎ", "≤", "≥"],
  [".", "|", "∼", "∖", "<", ">", "!", "?"]
];

class OskData {
  static final List<OskKeyModel> keys = [
    //#region 0-0

    OskKeyModel(
      row: 0,
      column: 0,
      keyType: KeyType.character,
      value: "q",
      display: "q",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 0,
      column: 0,
      keyType: KeyType.character,
      value: "Q",
      display: "Q",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 0,
      column: 0,
      keyType: KeyType.character,
      value: "1",
      display: "1",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 0,
      column: 0,
      keyType: KeyType.character,
      value: "1",
      display: "1",
      layoutType: OskType.specialCharacters,
    ),

    //#endregion

//#region 0-1
    OskKeyModel(
      row: 0,
      column: 1,
      keyType: KeyType.character,
      value: "w",
      display: "w",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 0,
      column: 1,
      keyType: KeyType.character,
      value: "W",
      display: "W",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 0,
      column: 1,
      keyType: KeyType.character,
      value: "2",
      display: "2",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 0,
      column: 1,
      keyType: KeyType.character,
      value: "2",
      display: "2",
      layoutType: OskType.specialCharacters,
    ),
//#endregion
//#region 0-2
    OskKeyModel(
      row: 0,
      column: 2,
      keyType: KeyType.character,
      value: "e",
      display: "e",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 0,
      column: 2,
      keyType: KeyType.character,
      value: "E",
      display: "E",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 0,
      column: 2,
      keyType: KeyType.character,
      value: "3",
      display: "3",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 0,
      column: 2,
      keyType: KeyType.character,
      value: "3",
      display: "3",
      layoutType: OskType.specialCharacters,
    ),
//#endregion
//#region 1-0

    OskKeyModel(
      row: 1,
      column: 0,
      keyType: KeyType.character,
      value: "a",
      display: "a",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 1,
      column: 0,
      keyType: KeyType.character,
      value: "A",
      display: "A",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 1,
      column: 0,
      keyType: KeyType.character,
      value: "@",
      display: "@",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 1,
      column: 0,
      keyType: KeyType.character,
      value: "€",
      display: "€",
      layoutType: OskType.specialCharacters,
    ),
//#endregion
    OskKeyModel(
      row: 3,
      column: 3,
      keyType: KeyType.enter,
      display: Icons.send,
      layoutType: OskType.all,
    ),
    OskKeyModel(
      row: 3,
      column: 0,
      keyType: KeyType.shift,
      display: Icons.arrow_back_sharp,
      layoutType: OskType.lowerCase,
    ),
    OskKeyModel(
      row: 3,
      column: 0,
      keyType: KeyType.shift,
      display: Icons.arrow_back_ios_new,
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 3,
      column: 0,
      keyType: KeyType.shift,
      display: "#+=",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 3,
      column: 0,
      keyType: KeyType.shift,
      display: "123",
      layoutType: OskType.specialCharacters,
    ),
    OskKeyModel(
      row: 3,
      column: 1,
      keyType: KeyType.alt,
      display: ".?123",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 3,
      column: 1,
      keyType: KeyType.alt,
      display: ".?123",
      layoutType: OskType.lowerCase,
    ),
    OskKeyModel(
      row: 3,
      column: 1,
      keyType: KeyType.alt,
      display: "ABC",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 3,
      column: 1,
      keyType: KeyType.alt,
      display: "ABC",
      layoutType: OskType.specialCharacters,
    ),
    OskKeyModel(
      row: 3,
      column: 3,
      keyType: KeyType.backspace,
      display: Icons.backspace_outlined,
      layoutType: OskType.all,
    ),
  ];

  /// shift onTap=> Layouttype swtch olucak.
  /// lowercase => uppercase e
  /// uppercase=> lowercase
  /// numbers=special
  /// special=number
  ///
  /// alt onTap=>
  /// lowercase= numbers
  /// uppsercase=numbers
  /// numbers=lowercase
  /// special=lowercase (eğer name ise type uppercase büyük küçük olcağı klavye tipine bağlıdır.)
  ///
  /// sayfaya döngüyle row column basılcak. data controllerdan filtreleyecğiz. burdan direkt datayı alıcaz.
  /// bütün tuşlar ontapı controllerdaki bir fonskyona gönderecek burada keytype ve value 2 parametre gidiceck.
  /// receiveOnTap(type,value?)
  /// switch(type) ile işlemler yapılcak.
}
