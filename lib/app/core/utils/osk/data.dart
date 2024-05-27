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

//#region 0-3
    OskKeyModel(
      row: 0,
      column: 3,
      keyType: KeyType.character,
      value: "r",
      display: "r",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 0,
      column: 3,
      keyType: KeyType.character,
      value: "R",
      display: "R",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 0,
      column: 3,
      keyType: KeyType.character,
      value: "4",
      display: "4",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 0,
      column: 3,
      keyType: KeyType.character,
      value: "4",
      display: "4",
      layoutType: OskType.specialCharacters,
    ),
//#endregion
//#region 0-4
    OskKeyModel(
      row: 0,
      column: 4,
      keyType: KeyType.character,
      value: "t",
      display: "t",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 0,
      column: 4,
      keyType: KeyType.character,
      value: "T",
      display: "T",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 0,
      column: 4,
      keyType: KeyType.character,
      value: "5",
      display: "5",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 0,
      column: 4,
      keyType: KeyType.character,
      value: "5",
      display: "5",
      layoutType: OskType.specialCharacters,
    ),
//#endregion
//#region 0-5
    OskKeyModel(
      row: 0,
      column: 5,
      keyType: KeyType.character,
      value: "y",
      display: "y",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 0,
      column: 5,
      keyType: KeyType.character,
      value: "Y",
      display: "Y",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 0,
      column: 5,
      keyType: KeyType.character,
      value: "6",
      display: "6",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 0,
      column: 5,
      keyType: KeyType.character,
      value: "6",
      display: "6",
      layoutType: OskType.specialCharacters,
    ),
//#endregion

//#region 0-6
    OskKeyModel(
      row: 0,
      column: 6,
      keyType: KeyType.character,
      value: "u",
      display: "u",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 0,
      column: 6,
      keyType: KeyType.character,
      value: "U",
      display: "U",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 0,
      column: 6,
      keyType: KeyType.character,
      value: "7",
      display: "7",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 0,
      column: 6,
      keyType: KeyType.character,
      value: "7",
      display: "7",
      layoutType: OskType.specialCharacters,
    ),
//#endregion
//#region 0-7
    OskKeyModel(
      row: 0,
      column: 7,
      keyType: KeyType.character,
      value: "ı",
      display: "ı",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 0,
      column: 7,
      keyType: KeyType.character,
      value: "I",
      display: "I",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 0,
      column: 7,
      keyType: KeyType.character,
      value: "8",
      display: "8",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 0,
      column: 7,
      keyType: KeyType.character,
      value: "8",
      display: "8",
      layoutType: OskType.specialCharacters,
    ),
//#endregion

//#region 0-8
    OskKeyModel(
      row: 0,
      column: 8,
      keyType: KeyType.character,
      value: "o",
      display: "o",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 0,
      column: 8,
      keyType: KeyType.character,
      value: "O",
      display: "O",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 0,
      column: 8,
      keyType: KeyType.character,
      value: "9",
      display: "9",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 0,
      column: 8,
      keyType: KeyType.character,
      value: "9",
      display: "9",
      layoutType: OskType.specialCharacters,
    ),
//#endregion

//#region 0-9
    OskKeyModel(
      row: 0,
      column: 9,
      keyType: KeyType.character,
      value: "p",
      display: "p",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 0,
      column: 9,
      keyType: KeyType.character,
      value: "P",
      display: "P",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 0,
      column: 9,
      keyType: KeyType.character,
      value: "0",
      display: "0",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 0,
      column: 9,
      keyType: KeyType.character,
      value: "0",
      display: "0",
      layoutType: OskType.specialCharacters,
    ),
//#endregion

//#region 0-10
    OskKeyModel(
      row: 0,
      column: 10,
      keyType: KeyType.character,
      value: "ğ",
      display: "ğ",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 0,
      column: 10,
      keyType: KeyType.character,
      value: "Ğ",
      display: "Ğ",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 0,
      column: 10,
      keyType: KeyType.character,
      value: "!",
      display: "!",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 0,
      column: 10,
      keyType: KeyType.character,
      value: "!",
      display: "!",
      layoutType: OskType.specialCharacters,
    ),
//#endregion

//#region 0-11
    OskKeyModel(
      row: 0,
      column: 11,
      keyType: KeyType.character,
      value: "ü",
      display: "ü",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 0,
      column: 11,
      keyType: KeyType.character,
      value: "Ü",
      display: "Ü",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 0,
      column: 11,
      keyType: KeyType.character,
      value: "?",
      display: "?",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 0,
      column: 11,
      keyType: KeyType.character,
      value: "?",
      display: "?",
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

//#region 1-1

    OskKeyModel(
      row: 1,
      column: 1,
      keyType: KeyType.character,
      value: "s",
      display: "s",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 1,
      column: 1,
      keyType: KeyType.character,
      value: "S",
      display: "S",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 1,
      column: 1,
      keyType: KeyType.character,
      value: "#",
      display: "#",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 1,
      column: 1,
      keyType: KeyType.character,
      value: "£",
      display: "£",
      layoutType: OskType.specialCharacters,
    ),
//#endregion

//#region 1-2

    OskKeyModel(
      row: 1,
      column: 2,
      keyType: KeyType.character,
      value: "d",
      display: "d",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 1,
      column: 2,
      keyType: KeyType.character,
      value: "D",
      display: "D",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 1,
      column: 2,
      keyType: KeyType.character,
      value: "\$",
      display: "\$",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 1,
      column: 2,
      keyType: KeyType.character,
      value: "¥",
      display: "¥",
      layoutType: OskType.specialCharacters,
    ),
//#endregion

//#region 1-3

    OskKeyModel(
      row: 1,
      column: 3,
      keyType: KeyType.character,
      value: "f",
      display: "f",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 1,
      column: 3,
      keyType: KeyType.character,
      value: "F",
      display: "F",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 1,
      column: 3,
      keyType: KeyType.character,
      value: "&",
      display: "&",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 1,
      column: 3,
      keyType: KeyType.character,
      value: "_",
      display: "_",
      layoutType: OskType.specialCharacters,
    ),
//#endregion

//#region 1-4

    OskKeyModel(
      row: 1,
      column: 4,
      keyType: KeyType.character,
      value: "g",
      display: "g",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 1,
      column: 4,
      keyType: KeyType.character,
      value: "G",
      display: "G",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 1,
      column: 4,
      keyType: KeyType.character,
      value: "*",
      display: "*",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 1,
      column: 4,
      keyType: KeyType.character,
      value: "[",
      display: "[",
      layoutType: OskType.specialCharacters,
    ),
//#endregion

//#region 1-5

    OskKeyModel(
      row: 1,
      column: 5,
      keyType: KeyType.character,
      value: "h",
      display: "h",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 1,
      column: 5,
      keyType: KeyType.character,
      value: "H",
      display: "H",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 1,
      column: 5,
      keyType: KeyType.character,
      value: "(",
      display: "(",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 1,
      column: 5,
      keyType: KeyType.character,
      value: "]",
      display: "]",
      layoutType: OskType.specialCharacters,
    ),
//#endregion

//#region 1-6

    OskKeyModel(
      row: 1,
      column: 6,
      keyType: KeyType.character,
      value: "j",
      display: "j",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 1,
      column: 6,
      keyType: KeyType.character,
      value: "J",
      display: "J",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 1,
      column: 6,
      keyType: KeyType.character,
      value: ")",
      display: ")",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 1,
      column: 6,
      keyType: KeyType.character,
      value: "{",
      display: "{",
      layoutType: OskType.specialCharacters,
    ),
//#endregion
//#region 1-7

    OskKeyModel(
      row: 1,
      column: 7,
      keyType: KeyType.character,
      value: "k",
      display: "k",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 1,
      column: 7,
      keyType: KeyType.character,
      value: "K",
      display: "K",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 1,
      column: 7,
      keyType: KeyType.character,
      value: "'",
      display: "'",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 1,
      column: 7,
      keyType: KeyType.character,
      value: "}",
      display: "}",
      layoutType: OskType.specialCharacters,
    ),
//#endregion

//#region 1-8

    OskKeyModel(
      row: 1,
      column: 8,
      keyType: KeyType.character,
      value: "l",
      display: "l",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 1,
      column: 8,
      keyType: KeyType.character,
      value: "L",
      display: "L",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 1,
      column: 8,
      keyType: KeyType.character,
      value: "\"",
      display: "\"",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 1,
      column: 8,
      keyType: KeyType.character,
      value: "ˎ",
      display: "ˎ",
      layoutType: OskType.specialCharacters,
    ),
//#endregion

//#region 1-9

    OskKeyModel(
      row: 1,
      column: 9,
      keyType: KeyType.character,
      value: "ş",
      display: "ş",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 1,
      column: 9,
      keyType: KeyType.character,
      value: "Ş",
      display: "Ş ",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 1,
      column: 9,
      keyType: KeyType.character,
      value: "≠",
      display: "≠",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 1,
      column: 9,
      keyType: KeyType.character,
      value: "≤",
      display: "≤",
      layoutType: OskType.specialCharacters,
    ),
//#endregion
//#region 1-10

    OskKeyModel(
      row: 1,
      column: 10,
      keyType: KeyType.character,
      value: "i",
      display: "i",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 1,
      column: 10,
      keyType: KeyType.character,
      value: "İ",
      display: "İ ",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 1,
      column: 10,
      keyType: KeyType.character,
      value: "‴",
      display: "‴",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 1,
      column: 10,
      keyType: KeyType.character,
      value: "≥",
      display: "≥",
      layoutType: OskType.specialCharacters,
    ),
//#endregion

//#region 2-0

    OskKeyModel(
      row: 2,
      column: 0,
      keyType: KeyType.character,
      value: "z",
      display: "z",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 2,
      column: 0,
      keyType: KeyType.character,
      value: "Z",
      display: "Z",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 2,
      column: 0,
      keyType: KeyType.character,
      value: "%",
      display: "%",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 2,
      column: 0,
      keyType: KeyType.character,
      value: ".",
      display: ".",
      layoutType: OskType.specialCharacters,
    ),
//#endregion
//#region 2-1

    OskKeyModel(
      row: 2,
      column: 1,
      keyType: KeyType.character,
      value: "x",
      display: "x",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 2,
      column: 1,
      keyType: KeyType.character,
      value: "X",
      display: "X",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 2,
      column: 1,
      keyType: KeyType.character,
      value: "_",
      display: "_",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 2,
      column: 1,
      keyType: KeyType.character,
      value: "|",
      display: "|",
      layoutType: OskType.specialCharacters,
    ),
//#endregion

//#region 2-2

    OskKeyModel(
      row: 2,
      column: 2,
      keyType: KeyType.character,
      value: "c",
      display: "c",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 2,
      column: 2,
      keyType: KeyType.character,
      value: "C",
      display: "C",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 2,
      column: 2,
      keyType: KeyType.character,
      value: "+",
      display: "+",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 2,
      column: 2,
      keyType: KeyType.character,
      value: "∼",
      display: "∼",
      layoutType: OskType.specialCharacters,
    ),
//#endregion

//#region 2-3

    OskKeyModel(
      row: 2,
      column: 3,
      keyType: KeyType.character,
      value: "v",
      display: "v",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 2,
      column: 3,
      keyType: KeyType.character,
      value: "V",
      display: "V",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 2,
      column: 3,
      keyType: KeyType.character,
      value: "=",
      display: "=",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 2,
      column: 3,
      keyType: KeyType.character,
      value: "∖",
      display: "∖",
      layoutType: OskType.specialCharacters,
    ),
//#endregion

//#region 2-4

    OskKeyModel(
      row: 2,
      column: 4,
      keyType: KeyType.character,
      value: "b",
      display: "b",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 2,
      column: 4,
      keyType: KeyType.character,
      value: "B",
      display: "B",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 2,
      column: 4,
      keyType: KeyType.character,
      value: "/",
      display: "/",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 2,
      column: 4,
      keyType: KeyType.character,
      value: "<",
      display: "<",
      layoutType: OskType.specialCharacters,
    ),
//#endregion

//#region 2-5

    OskKeyModel(
      row: 2,
      column: 5,
      keyType: KeyType.character,
      value: "n",
      display: "n",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 2,
      column: 5,
      keyType: KeyType.character,
      value: "N",
      display: "N",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 2,
      column: 5,
      keyType: KeyType.character,
      value: ";",
      display: ";",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 2,
      column: 5,
      keyType: KeyType.character,
      value: ">",
      display: ">",
      layoutType: OskType.specialCharacters,
    ),
//#endregion

//#region 2-6

    OskKeyModel(
      row: 2,
      column: 6,
      keyType: KeyType.character,
      value: "m",
      display: "m",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 2,
      column: 6,
      keyType: KeyType.character,
      value: "M",
      display: "M",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 2,
      column: 6,
      keyType: KeyType.character,
      value: ":",
      display: ":",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 2,
      column: 6,
      keyType: KeyType.character,
      value: "!",
      display: "!",
      layoutType: OskType.specialCharacters,
    ),
//#endregion

//#region 2-7

    OskKeyModel(
      row: 2,
      column: 7,
      keyType: KeyType.character,
      value: "ö",
      display: "ö",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 2,
      column: 7,
      keyType: KeyType.character,
      value: "Ö",
      display: "Ö",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 2,
      column: 7,
      keyType: KeyType.character,
      value: ",",
      display: ",",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 2,
      column: 7,
      keyType: KeyType.character,
      value: "?",
      display: "?",
      layoutType: OskType.specialCharacters,
    ),
//#endregion

//#region 2-8

    OskKeyModel(
      row: 2,
      column: 8,
      keyType: KeyType.character,
      value: "ç",
      display: "ç",
      layoutType: OskType.lowerCase,
    ),

    OskKeyModel(
      row: 2,
      column: 8,
      keyType: KeyType.character,
      value: "Ç",
      display: "Ç",
      layoutType: OskType.upperCase,
    ),
    OskKeyModel(
      row: 2,
      column: 8,
      keyType: KeyType.character,
      value: "-",
      display: "-",
      layoutType: OskType.numbers,
    ),
    OskKeyModel(
      row: 2,
      column: 8,
      keyType: KeyType.character,
      value: ".",
      display: ".",
      layoutType: OskType.specialCharacters,
    ),
//#endregion

//#region 2-9
    OskKeyModel(
      row: 2,
      column: 9,
      keyType: KeyType.backspace,
      display: Icons.backspace_outlined,
      layoutType: OskType.all,
    ),
//#endregion

//#region row-3
    OskKeyModel(
      row: 3,
      column: 4,
      keyType: KeyType.enter,
      display: Icons.subdirectory_arrow_left,
      layoutType: OskType.all,
    ),
    OskKeyModel(
      row: 3,
      column: 0,
      keyType: KeyType.shift,
      display: Icons.arrow_upward_outlined,
      layoutType: OskType.lowerCase,
    ),
    OskKeyModel(
      row: 3,
      column: 0,
      keyType: KeyType.shift,
      display: Icons.arrow_downward,
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
      keyType: KeyType.space,
      display: Icons.space_bar,
      layoutType: OskType.all,
    ),
    OskKeyModel(
      row: 3,
      column: 5,
      keyType: KeyType.hideKeyboard,
      display: Icons.keyboard_alt_outlined,
      layoutType: OskType.all,
    ),
    //#endregion
  
  
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
