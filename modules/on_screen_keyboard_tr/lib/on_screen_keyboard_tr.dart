// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_element

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum OSKInputType {
  text,
  name,
  email, //
  alphanumeric,
  number,
}

enum _KeyType {
  character,
  backspace,
  enter,
  hideKeyboard,
  shift,
  alt,
  space,
}

enum _OSKLayoutType {
  all,
  upperCase,
  lowerCase,
  numbers,
  specialCharacters,
}

class _OSKKeyData {
  static final List<_OSKKeyDefinition> keys = [
    //#region 0-0

    _OSKKeyDefinition(
      row: 0,
      column: 0,
      keyType: _KeyType.character,
      value: "q",
      display: "q",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 0,
      column: 0,
      keyType: _KeyType.character,
      value: "Q",
      display: "Q",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 0,
      keyType: _KeyType.character,
      value: "1",
      display: "1",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 0,
      keyType: _KeyType.character,
      value: "1",
      display: "1",
      layoutType: _OSKLayoutType.specialCharacters,
    ),

    //#endregion

    //#region 0-1
    _OSKKeyDefinition(
      row: 0,
      column: 1,
      keyType: _KeyType.character,
      value: "w",
      display: "w",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 0,
      column: 1,
      keyType: _KeyType.character,
      value: "W",
      display: "W",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 1,
      keyType: _KeyType.character,
      value: "2",
      display: "2",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 1,
      keyType: _KeyType.character,
      value: "2",
      display: "2",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 0-2
    _OSKKeyDefinition(
      row: 0,
      column: 2,
      keyType: _KeyType.character,
      value: "e",
      display: "e",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 0,
      column: 2,
      keyType: _KeyType.character,
      value: "E",
      display: "E",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 2,
      keyType: _KeyType.character,
      value: "3",
      display: "3",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 2,
      keyType: _KeyType.character,
      value: "3",
      display: "3",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 0-3
    _OSKKeyDefinition(
      row: 0,
      column: 3,
      keyType: _KeyType.character,
      value: "r",
      display: "r",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 0,
      column: 3,
      keyType: _KeyType.character,
      value: "R",
      display: "R",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 3,
      keyType: _KeyType.character,
      value: "4",
      display: "4",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 3,
      keyType: _KeyType.character,
      value: "4",
      display: "4",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 0-4
    _OSKKeyDefinition(
      row: 0,
      column: 4,
      keyType: _KeyType.character,
      value: "t",
      display: "t",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 0,
      column: 4,
      keyType: _KeyType.character,
      value: "T",
      display: "T",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 4,
      keyType: _KeyType.character,
      value: "5",
      display: "5",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 4,
      keyType: _KeyType.character,
      value: "5",
      display: "5",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 0-5
    _OSKKeyDefinition(
      row: 0,
      column: 5,
      keyType: _KeyType.character,
      value: "y",
      display: "y",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 0,
      column: 5,
      keyType: _KeyType.character,
      value: "Y",
      display: "Y",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 5,
      keyType: _KeyType.character,
      value: "6",
      display: "6",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 5,
      keyType: _KeyType.character,
      value: "6",
      display: "6",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 0-6
    _OSKKeyDefinition(
      row: 0,
      column: 6,
      keyType: _KeyType.character,
      value: "u",
      display: "u",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 0,
      column: 6,
      keyType: _KeyType.character,
      value: "U",
      display: "U",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 6,
      keyType: _KeyType.character,
      value: "7",
      display: "7",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 6,
      keyType: _KeyType.character,
      value: "7",
      display: "7",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 0-7
    _OSKKeyDefinition(
      row: 0,
      column: 7,
      keyType: _KeyType.character,
      value: "ı",
      display: "ı",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 0,
      column: 7,
      keyType: _KeyType.character,
      value: "I",
      display: "I",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 7,
      keyType: _KeyType.character,
      value: "8",
      display: "8",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 7,
      keyType: _KeyType.character,
      value: "8",
      display: "8",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 0-8
    _OSKKeyDefinition(
      row: 0,
      column: 8,
      keyType: _KeyType.character,
      value: "o",
      display: "o",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 0,
      column: 8,
      keyType: _KeyType.character,
      value: "O",
      display: "O",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 8,
      keyType: _KeyType.character,
      value: "9",
      display: "9",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 8,
      keyType: _KeyType.character,
      value: "9",
      display: "9",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 0-9
    _OSKKeyDefinition(
      row: 0,
      column: 9,
      keyType: _KeyType.character,
      value: "p",
      display: "p",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 0,
      column: 9,
      keyType: _KeyType.character,
      value: "P",
      display: "P",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 9,
      keyType: _KeyType.character,
      value: "0",
      display: "0",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 9,
      keyType: _KeyType.character,
      value: "0",
      display: "0",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 0-10
    _OSKKeyDefinition(
      row: 0,
      column: 10,
      keyType: _KeyType.character,
      value: "ğ",
      display: "ğ",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 0,
      column: 10,
      keyType: _KeyType.character,
      value: "Ğ",
      display: "Ğ",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 10,
      keyType: _KeyType.character,
      value: ",",
      display: ",",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 10,
      keyType: _KeyType.character,
      value: ",",
      display: ",",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 0-11
    _OSKKeyDefinition(
      row: 0,
      column: 11,
      keyType: _KeyType.character,
      value: "ü",
      display: "ü",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 0,
      column: 11,
      keyType: _KeyType.character,
      value: "Ü",
      display: "Ü",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 11,
      keyType: _KeyType.character,
      value: ".",
      display: ".",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 0,
      column: 11,
      keyType: _KeyType.character,
      value: ",",
      display: ",",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 1-0

    _OSKKeyDefinition(
      row: 1,
      column: 0,
      keyType: _KeyType.character,
      value: "a",
      display: "a",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 1,
      column: 0,
      keyType: _KeyType.character,
      value: "A",
      display: "A",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 1,
      column: 0,
      keyType: _KeyType.character,
      value: "@",
      display: "@",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 1,
      column: 0,
      keyType: _KeyType.character,
      value: "€",
      display: "€",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 1-1

    _OSKKeyDefinition(
      row: 1,
      column: 1,
      keyType: _KeyType.character,
      value: "s",
      display: "s",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 1,
      column: 1,
      keyType: _KeyType.character,
      value: "S",
      display: "S",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 1,
      column: 1,
      keyType: _KeyType.character,
      value: "#",
      display: "#",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 1,
      column: 1,
      keyType: _KeyType.character,
      value: "£",
      display: "£",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 1-2

    _OSKKeyDefinition(
      row: 1,
      column: 2,
      keyType: _KeyType.character,
      value: "d",
      display: "d",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 1,
      column: 2,
      keyType: _KeyType.character,
      value: "D",
      display: "D",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 1,
      column: 2,
      keyType: _KeyType.character,
      value: "\$",
      display: "\$",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 1,
      column: 2,
      keyType: _KeyType.character,
      value: "¥",
      display: "¥",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 1-3

    _OSKKeyDefinition(
      row: 1,
      column: 3,
      keyType: _KeyType.character,
      value: "f",
      display: "f",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 1,
      column: 3,
      keyType: _KeyType.character,
      value: "F",
      display: "F",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 1,
      column: 3,
      keyType: _KeyType.character,
      value: "&",
      display: "&",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 1,
      column: 3,
      keyType: _KeyType.character,
      value: "_",
      display: "_",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 1-4

    _OSKKeyDefinition(
      row: 1,
      column: 4,
      keyType: _KeyType.character,
      value: "g",
      display: "g",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 1,
      column: 4,
      keyType: _KeyType.character,
      value: "G",
      display: "G",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 1,
      column: 4,
      keyType: _KeyType.character,
      value: "*",
      display: "*",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 1,
      column: 4,
      keyType: _KeyType.character,
      value: "[",
      display: "[",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 1-5

    _OSKKeyDefinition(
      row: 1,
      column: 5,
      keyType: _KeyType.character,
      value: "h",
      display: "h",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 1,
      column: 5,
      keyType: _KeyType.character,
      value: "H",
      display: "H",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 1,
      column: 5,
      keyType: _KeyType.character,
      value: "(",
      display: "(",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 1,
      column: 5,
      keyType: _KeyType.character,
      value: "]",
      display: "]",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 1-6

    _OSKKeyDefinition(
      row: 1,
      column: 6,
      keyType: _KeyType.character,
      value: "j",
      display: "j",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 1,
      column: 6,
      keyType: _KeyType.character,
      value: "J",
      display: "J",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 1,
      column: 6,
      keyType: _KeyType.character,
      value: ")",
      display: ")",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 1,
      column: 6,
      keyType: _KeyType.character,
      value: "{",
      display: "{",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion
    //#region 1-7

    _OSKKeyDefinition(
      row: 1,
      column: 7,
      keyType: _KeyType.character,
      value: "k",
      display: "k",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 1,
      column: 7,
      keyType: _KeyType.character,
      value: "K",
      display: "K",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 1,
      column: 7,
      keyType: _KeyType.character,
      value: "'",
      display: "'",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 1,
      column: 7,
      keyType: _KeyType.character,
      value: "}",
      display: "}",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 1-8

    _OSKKeyDefinition(
      row: 1,
      column: 8,
      keyType: _KeyType.character,
      value: "l",
      display: "l",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 1,
      column: 8,
      keyType: _KeyType.character,
      value: "L",
      display: "L",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 1,
      column: 8,
      keyType: _KeyType.character,
      value: "\"",
      display: "\"",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 1,
      column: 8,
      keyType: _KeyType.character,
      value: "ˎ",
      display: "ˎ",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 1-9

    _OSKKeyDefinition(
      row: 1,
      column: 9,
      keyType: _KeyType.character,
      value: "ş",
      display: "ş",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 1,
      column: 9,
      keyType: _KeyType.character,
      value: "Ş",
      display: "Ş ",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 1,
      column: 9,
      keyType: _KeyType.character,
      value: "≠",
      display: "≠",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 1,
      column: 9,
      keyType: _KeyType.character,
      value: "≤",
      display: "≤",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion
    //#region 1-10

    _OSKKeyDefinition(
      row: 1,
      column: 10,
      keyType: _KeyType.character,
      value: "i",
      display: "i",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 1,
      column: 10,
      keyType: _KeyType.character,
      value: "İ",
      display: "İ ",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 1,
      column: 10,
      keyType: _KeyType.character,
      value: "‴",
      display: "‴",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 1,
      column: 10,
      keyType: _KeyType.character,
      value: "≥",
      display: "≥",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 2-0

    _OSKKeyDefinition(
      row: 2,
      column: 0,
      keyType: _KeyType.character,
      value: "z",
      display: "z",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 2,
      column: 0,
      keyType: _KeyType.character,
      value: "Z",
      display: "Z",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 2,
      column: 0,
      keyType: _KeyType.character,
      value: "%",
      display: "%",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 2,
      column: 0,
      keyType: _KeyType.character,
      value: ".",
      display: ".",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion
    //#region 2-1

    _OSKKeyDefinition(
      row: 2,
      column: 1,
      keyType: _KeyType.character,
      value: "x",
      display: "x",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 2,
      column: 1,
      keyType: _KeyType.character,
      value: "X",
      display: "X",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 2,
      column: 1,
      keyType: _KeyType.character,
      value: "_",
      display: "_",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 2,
      column: 1,
      keyType: _KeyType.character,
      value: "|",
      display: "|",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 2-2

    _OSKKeyDefinition(
      row: 2,
      column: 2,
      keyType: _KeyType.character,
      value: "c",
      display: "c",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 2,
      column: 2,
      keyType: _KeyType.character,
      value: "C",
      display: "C",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 2,
      column: 2,
      keyType: _KeyType.character,
      value: "+",
      display: "+",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 2,
      column: 2,
      keyType: _KeyType.character,
      value: "∼",
      display: "∼",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 2-3

    _OSKKeyDefinition(
      row: 2,
      column: 3,
      keyType: _KeyType.character,
      value: "v",
      display: "v",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 2,
      column: 3,
      keyType: _KeyType.character,
      value: "V",
      display: "V",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 2,
      column: 3,
      keyType: _KeyType.character,
      value: "=",
      display: "=",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 2,
      column: 3,
      keyType: _KeyType.character,
      value: "∖",
      display: "∖",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 2-4

    _OSKKeyDefinition(
      row: 2,
      column: 4,
      keyType: _KeyType.character,
      value: "b",
      display: "b",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 2,
      column: 4,
      keyType: _KeyType.character,
      value: "B",
      display: "B",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 2,
      column: 4,
      keyType: _KeyType.character,
      value: "/",
      display: "/",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 2,
      column: 4,
      keyType: _KeyType.character,
      value: "<",
      display: "<",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 2-5

    _OSKKeyDefinition(
      row: 2,
      column: 5,
      keyType: _KeyType.character,
      value: "n",
      display: "n",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 2,
      column: 5,
      keyType: _KeyType.character,
      value: "N",
      display: "N",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 2,
      column: 5,
      keyType: _KeyType.character,
      value: ";",
      display: ";",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 2,
      column: 5,
      keyType: _KeyType.character,
      value: ">",
      display: ">",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 2-6

    _OSKKeyDefinition(
      row: 2,
      column: 6,
      keyType: _KeyType.character,
      value: "m",
      display: "m",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 2,
      column: 6,
      keyType: _KeyType.character,
      value: "M",
      display: "M",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 2,
      column: 6,
      keyType: _KeyType.character,
      value: ":",
      display: ":",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 2,
      column: 6,
      keyType: _KeyType.character,
      value: "!",
      display: "!",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 2-7

    _OSKKeyDefinition(
      row: 2,
      column: 7,
      keyType: _KeyType.character,
      value: "ö",
      display: "ö",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 2,
      column: 7,
      keyType: _KeyType.character,
      value: "Ö",
      display: "Ö",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 2,
      column: 7,
      keyType: _KeyType.character,
      value: "?",
      display: "?",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 2,
      column: 7,
      keyType: _KeyType.character,
      value: "?",
      display: "?",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 2-8

    _OSKKeyDefinition(
      row: 2,
      column: 8,
      keyType: _KeyType.character,
      value: "ç",
      display: "ç",
      layoutType: _OSKLayoutType.lowerCase,
    ),

    _OSKKeyDefinition(
      row: 2,
      column: 8,
      keyType: _KeyType.character,
      value: "Ç",
      display: "Ç",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 2,
      column: 8,
      keyType: _KeyType.character,
      value: "-",
      display: "-",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 2,
      column: 8,
      keyType: _KeyType.character,
      value: ".",
      display: ".",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    //#endregion

    //#region 2-9
    _OSKKeyDefinition(
      row: 2,
      column: 9,
      keyType: _KeyType.backspace,
      display: Icons.backspace_outlined,
      layoutType: _OSKLayoutType.all,
    ),
    //#endregion

    //#region row-3
    _OSKKeyDefinition(
      row: 3,
      column: 4,
      keyType: _KeyType.enter,
      display: Icons.subdirectory_arrow_left,
      layoutType: _OSKLayoutType.all,
    ),
    _OSKKeyDefinition(
      row: 3,
      column: 0,
      keyType: _KeyType.shift,
      display: Icons.arrow_upward_outlined,
      layoutType: _OSKLayoutType.lowerCase,
    ),
    _OSKKeyDefinition(
      row: 3,
      column: 0,
      keyType: _KeyType.shift,
      display: Icons.arrow_downward,
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 3,
      column: 0,
      keyType: _KeyType.shift,
      display: "#+=",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 3,
      column: 0,
      keyType: _KeyType.shift,
      display: "123",
      layoutType: _OSKLayoutType.specialCharacters,
    ),
    _OSKKeyDefinition(
      row: 3,
      column: 1,
      keyType: _KeyType.alt,
      display: ".?123",
      layoutType: _OSKLayoutType.upperCase,
    ),
    _OSKKeyDefinition(
      row: 3,
      column: 1,
      keyType: _KeyType.alt,
      display: ".?123",
      layoutType: _OSKLayoutType.lowerCase,
    ),
    _OSKKeyDefinition(
      row: 3,
      column: 1,
      keyType: _KeyType.alt,
      display: "ABC",
      layoutType: _OSKLayoutType.numbers,
    ),
    _OSKKeyDefinition(
      row: 3,
      column: 1,
      keyType: _KeyType.alt,
      display: "ABC",
      layoutType: _OSKLayoutType.specialCharacters,
    ),

    _OSKKeyDefinition(
      row: 3,
      column: 3,
      keyType: _KeyType.space,
      display: Icons.space_bar,
      layoutType: _OSKLayoutType.all,
    ),
    _OSKKeyDefinition(
      row: 3,
      column: 5,
      keyType: _KeyType.hideKeyboard,
      display: Icons.keyboard_alt_outlined,
      layoutType: _OSKLayoutType.all,
    ),
    //#endregion
  ];
}

class _OSKKeyDefinition {
  int row;
  int column;
  _KeyType keyType;
  String? value;
  dynamic display;
  _OSKLayoutType layoutType;
  bool isNumber;

  _OSKKeyDefinition({
    required this.row,
    required this.column,
    required this.keyType,
    this.value,
    required this.display,
    required this.layoutType,
    this.isNumber = false,
  });
}

class _OSKController extends GetxController {
  final OSKInputType inputType;
  final String initialValue;
  final String label;
  final bool numberOnly;
  final String hintText;
  final _layoutType = _OSKLayoutType.lowerCase.obs;
  final _currentText = ''.obs;
  final _isShiftActive = false.obs;
  final void Function(String)? feedbackFunction;

  _OSKController({
    required this.inputType,
    required this.initialValue,
    required this.label,
    required this.hintText,
    required this.numberOnly,
    this.feedbackFunction,
  }) {
    _currentText.value = initialValue;

    _inputType.value = inputType;
    if (numberOnly) {
      _layoutType.value = _OSKLayoutType.numbers;
    }
    if (feedbackFunction != null) {
      ever(_currentText, feedbackFunction!);
    }

    update();
  }

  @override
  void onReady() {
    updateKeyboardLayout();
    super.onReady();
  }

  final Rx<OSKInputType> _inputType = OSKInputType.text.obs;
  OSKInputType get getInputType => _inputType.value;

  String get currentText => _currentText.value;
  _OSKLayoutType get layoutType => _layoutType.value;
  bool get isShiftActive => _isShiftActive.value;

  void setText(String newText) {
    _currentText.value = newText;
  }

  void setLayoutType(_OSKLayoutType type) {
    _layoutType.value = type;
  }

  void updateKeyboardLayout() {
    if (getInputType == OSKInputType.name) {
      if (_currentText.value.isEmpty || _currentText.value.endsWith(" ")) {
        _layoutType.value = _OSKLayoutType.upperCase;
      } else {
        _layoutType.value = _OSKLayoutType.lowerCase;
      }
    }
    update();
  }

  List<_OSKKeyDefinition> get filteredKeys {
    return _OSKKeyData.keys.where((key) {
      if (numberOnly &&
          (key.keyType == _KeyType.alt || key.keyType == _KeyType.shift)) {
        return false;
      }
      return key.layoutType == layoutType ||
          key.layoutType == _OSKLayoutType.all;
    }).toList();
  }

  List<_OSKKeyDefinition> getKeys({
    required _OSKLayoutType layouttype,
    required int row,
    required int column,
  }) {
    return _OSKKeyData.keys
        .where((element) =>
            (element.layoutType == layouttype ||
                element.layoutType == _OSKLayoutType.all) &&
            element.row == row &&
            element.column == column)
        .toList();
  }

  void receiveOnTap(_KeyType type, String value) {
    switch (type) {
      case _KeyType.character:
        _currentText.value += value;
        break;
      case _KeyType.space:
        _currentText.value += " ";
        break;
      case _KeyType.enter:
        Get.back(result: currentText);
        break;
      case _KeyType.hideKeyboard:
        Get.back(result: "");
        break;
      case _KeyType.backspace:
        if (currentText.isNotEmpty) {
          _currentText.value = currentText.substring(0, currentText.length - 1);
        }
        break;
      case _KeyType.shift:
        if (getInputType == OSKInputType.name) {
          _inputType.value = OSKInputType.text;
          update();
        }
        if (!numberOnly) {
          switch (_layoutType.value) {
            case _OSKLayoutType.lowerCase:
              _layoutType.value = _OSKLayoutType.upperCase;
              break;
            case _OSKLayoutType.upperCase:
              _layoutType.value = _OSKLayoutType.lowerCase;
              break;
            case _OSKLayoutType.numbers:
              _layoutType.value = _OSKLayoutType.specialCharacters;
              break;
            case _OSKLayoutType.specialCharacters:
              _layoutType.value = _OSKLayoutType.numbers;
              break;
            default:
              break;
          }
        }
        break;
      case _KeyType.alt:
        if (getInputType == OSKInputType.name) {
          _inputType.value = OSKInputType.text;
          update();
        }
        if (!numberOnly) {
          switch (_layoutType.value) {
            case _OSKLayoutType.lowerCase:
            case _OSKLayoutType.upperCase:
              _layoutType.value = _OSKLayoutType.numbers;
              break;
            case _OSKLayoutType.numbers:
            case _OSKLayoutType.specialCharacters:
              _layoutType.value = _OSKLayoutType.lowerCase;
              break;
            default:
              break;
          }
        }
        break;
      default:
        break;
    }
    if (feedbackFunction != null) {
      feedbackFunction!(_currentText.value);
    }
    update();

    updateKeyboardLayout();
  }
}

class _KeyWidget extends StatelessWidget {
  final _OSKKeyDefinition model;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onLongTap;
  final BuildContext ctx;

  const _KeyWidget({
    super.key,
    required this.model,
    this.onTap,
    required this.ctx,
    this.onLongTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Container();
    if (model.display is String) {
      child = Text(
        model.display as String,
        style: TextStyle(
            fontSize: 25, color: Theme.of(ctx).textTheme.titleMedium?.color),
      );
    } else if (model.display is IconData) {
      child = Icon(
        model.display as IconData,
        size: 30,
      );
    }

    double width;
    double height;
    Color color;

    switch (model.keyType) {
      case _KeyType.enter:
      case _KeyType.hideKeyboard:
        width = 90;
        height = 57;
        color = Theme.of(ctx).hoverColor.withOpacity(0.3);
      case _KeyType.shift:
      case _KeyType.alt:
        width = 90;
        height = 57;
        color = Theme.of(ctx).hoverColor.withOpacity(0.3);

        break;
      case _KeyType.backspace:
        width = 185;
        height = 57;
        color = Theme.of(ctx).hoverColor.withOpacity(0.3);

        break;
      case _KeyType.space:
        width = 410;
        height = 57;
        color = Get.isDarkMode
            ? Theme.of(ctx).dividerColor.withOpacity(0.7)
            : Theme.of(context).dividerColor.withOpacity(0.2);
        break;
      case _KeyType.character:
        width = 60.5;
        height = 57;
        color = Get.isDarkMode
            ? Theme.of(ctx).dividerColor.withOpacity(0.7)
            : Theme.of(context).dividerColor.withOpacity(0.2);

        break;
      default:
        width = 60;
        height = 57;
        color = Get.isDarkMode
            ? Theme.of(ctx).hintColor.withOpacity(0.5)
            : Theme.of(ctx).hintColor.withOpacity(0.1);

        break;
    }

    return Card(
      elevation: onTap == null ? 0 : 3,
      margin: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          width: width,
          height: height,
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _OSKKeyScreen extends StatefulWidget {
  final OSKInputType inputType;
  final String? label;
  final dynamic initialValue;
  final String? hintText;
  final BuildContext ctx;
  final int? maxLength;
  final int? minLength;
  final void Function(String)? feedbackFunction;

  const _OSKKeyScreen({
    super.key,
    required this.ctx,
    this.inputType = OSKInputType.text,
    this.label,
    this.initialValue,
    this.hintText,
    this.maxLength,
    this.minLength,
    this.feedbackFunction,
  });

  @override
  State<_OSKKeyScreen> createState() {
    return _OSKKeyScreenState();
  }
}

class _OSKKeyScreenState extends State<_OSKKeyScreen> {
  late _OSKController oskKeyController;
  late String label;
  late String hintText;
  late OSKInputType type;
  late dynamic initialValue;
  final numberOnlyChars = "0123456789,.";
  bool isSubmitEnabled = false;

  double cursorOpacity = 0;
  late Timer cursorTimer;
  @override
  void initState() {
    super.initState();
    label = widget.label ?? "";
    hintText = widget.hintText ?? "";
    type = widget.inputType;
    initialValue = widget.initialValue ?? "";
    oskKeyController = Get.put(
        _OSKController(
          inputType: type,
          label: label,
          initialValue: initialValue,
          hintText: hintText,
          numberOnly: type == OSKInputType.number,
          feedbackFunction: widget.feedbackFunction,
        ),
        permanent: false);

    cursorTimer = Timer.periodic(const Duration(milliseconds: 150), (t) {
      setState(() {
        cursorOpacity = cursorOpacity == 0 ? 1 : 0;
      });
    });
  }

  @override
  void dispose() {
    cursorTimer.cancel();
    super.dispose();
  }

  void _onKeyTap(String value, _KeyType type) {
    if (oskKeyController.getInputType == OSKInputType.number &&
        !numberOnlyChars.contains(value)) {
      return;
    }

    if (oskKeyController.getInputType == OSKInputType.name) {
      if (oskKeyController.currentText.isEmpty ||
          oskKeyController.currentText.endsWith(" ")) {
        value = value.toUpperCase();
      } else {
        value = value.toLowerCase();
      }
    }
    if (widget.maxLength != null &&
        oskKeyController.currentText.length >= widget.maxLength! &&
        type == _KeyType.character) {
      return;
    }

    if (type == _KeyType.character || type == _KeyType.space) {
      oskKeyController.receiveOnTap(type, value);
    } else if (type == _KeyType.enter) {
      // minLength kontrolü
      if (widget.minLength != null &&
          oskKeyController.currentText.length < widget.minLength!) {
        setState(() {
          isSubmitEnabled = false;
        });
      } else {
        setState(() {
          isSubmitEnabled = true;
        });
        Navigator.pop(context, oskKeyController.currentText);
      }
    } else {
      oskKeyController.receiveOnTap(type, value);
    }
    setState(() {
      isSubmitEnabled = widget.minLength == null ||
          oskKeyController.currentText.length >= widget.minLength!;
    });
    if (widget.feedbackFunction != null) {
      widget.feedbackFunction!(oskKeyController.currentText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<_OSKController>(
      builder: (oskKeyController) {
        var kb = Container(
          padding: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: Theme.of(widget.ctx).dividerColor.withOpacity(0.1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int row = 0; row < 4; row++)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int column = 0; column <= 11; column++)
                      ...oskKeyController
                          .getKeys(
                        row: row,
                        column: column,
                        layouttype: oskKeyController.layoutType,
                      )
                          .map(
                        (key) {
                          return _KeyWidget(
                            ctx: widget.ctx,
                            model: key,
                            onTap: () {
                              _onKeyTap(
                                key.value ?? "",
                                key.keyType,
                              );
                            },
                          );
                        },
                      ),
                  ],
                )
            ],
          ),
        );

        var labelWidget = Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 22,
                color: Theme.of(widget.ctx)
                    .textTheme
                    .labelMedium!
                    .color
                    ?.withOpacity(0.60)),
          ),
        );
        String descriptionText = "";
        if (widget.minLength != null && widget.maxLength != null) {
          if (widget.minLength == widget.maxLength) {
            descriptionText = " ${widget.maxLength} karakter girmelisin.";
          } else {
            descriptionText =
                "En az ${widget.minLength}, en çok ${widget.maxLength} karakter girmelisin.";
          }
        }
        if (widget.minLength != null && widget.maxLength == null) {
          descriptionText = "En az ${widget.minLength} karakter girmelisin.";
        }
        if (widget.minLength == null && widget.maxLength != null) {
          descriptionText = "En fazla ${widget.maxLength} karakter girmelisin.";
        }
        var descriptionWidget = Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            descriptionText,
            style: TextStyle(
                fontSize: 14,
                color: Theme.of(widget.ctx)
                    .textTheme
                    .labelMedium!
                    .color
                    ?.withOpacity(0.60)),
          ),
        );

        var hintTextWidget = Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            hintText,
            style: TextStyle(
              fontSize: 22,
              color: Theme.of(widget.ctx)
                  .textTheme
                  .labelMedium!
                  .color
                  ?.withOpacity(0.60),
            ),
          ),
        );
        var valueWidget = Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                oskKeyController.currentText,
                style: TextStyle(
                    fontSize: 22,
                    color: Theme.of(widget.ctx).textTheme.labelMedium!.color),
              ),
              AnimatedOpacity(
                opacity: cursorOpacity,
                duration: const Duration(milliseconds: 100),
                child: const Text(
                  "|",
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ],
          ),
        );

        var btnClear = Container(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton(
              onPressed: oskKeyController.currentText.isNotEmpty
                  ? () {
                      oskKeyController.setText("");
                    }
                  : null,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.close),
                  Text("Clear"),
                ],
              )),
        );

        var btnSubmit = Container(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton(
              onPressed: isSubmitEnabled
                  ? () {
                      Get.back(result: oskKeyController.currentText);
                    }
                  : null,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.send,
                  ),
                  Text("Submit"),
                ],
              )),
        );

        return Scaffold(
            backgroundColor: Theme.of(widget.ctx).canvasColor,
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            labelWidget,
                            Expanded(
                                child: Stack(
                              children: [
                                valueWidget,
                                if (oskKeyController.currentText.isEmpty)
                                  hintTextWidget
                              ],
                            )),
                            descriptionWidget
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: btnClear,
                            ),
                            Expanded(
                              child: btnSubmit,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                kb,
              ],
            ));
      },
    );
  }
}

class OnScreenKeyboard {
  /// Shows an on-screen keyboard with the given initial value, label, input type,
  /// hint text, and build context. The function returns a future that resolves
  /// with the result of the keyboard navigation.
  ///
  /// Parameters:
  /// - initialValue: The initial value to be displayed in the keyboard. Can be
  ///   of any type.
  /// - label: An optional label to be displayed above the keyboard.
  /// - type: The type of input expected from the user. Defaults to OSKInputType.name.
  /// - hintText: An optional hint text to be displayed in the keyboard.
  /// - context: The build context in which the keyboard is displayed.
  ///
  /// Returns: A future that resolves with the result of the keyboard navigation.
  static Future<dynamic> show({
    dynamic initialValue,
    String? label,
    OSKInputType type = OSKInputType.name,
    String? hintText,
    int? maxLength,
    int? minLength,
    required BuildContext context,
    void Function(String)? feedbackFunction,
    // function alıcak feedbackfunction bu fonskyon null değilse bu fonksiyonu çalıştırcak her basışta. controllerde rxfunction açıcaz.
  }) async {
    return await Get.to(
      transition: Transition.downToUp,
      () => _OSKKeyScreen(
        hintText: hintText,
        initialValue: initialValue,
        inputType: type,
        label: label,
        ctx: context,
        maxLength: maxLength,
        minLength: minLength,
        feedbackFunction: feedbackFunction,
      ),
    );
  }
}
