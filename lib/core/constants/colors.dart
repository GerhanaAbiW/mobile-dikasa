import 'package:flutter/material.dart';
import 'package:mobile_dikasa/core/utils/convert_color_hex_to_argb.dart';

class AppColors {
  const AppColors._();

  // =========================
  // Core Brand Colors
  // =========================
  static final Color primaryBlue = hexToArgb('#097BC2');
  static final Color deepBlue = hexToArgb('#077CD3');
  static final Color accentOrange = hexToArgb('#FF8227');
  static final Color darkBlue = hexToArgb('#2C5E7A');

  // =========================
  // Semantic Colors
  // =========================
  static final Color success = hexToArgb('#5CB5AB');
  static final Color danger = hexToArgb('#9D1414');
  static final Color overlay30Black = hexToArgb('#4D0F0F0F');

  // =========================
  // Full Palette (FIGMA + SVG)
  // =========================
  static final Color c077CD3 = deepBlue;
  static final Color c097BC2 = primaryBlue;
  static final Color c0F0F0F = hexToArgb('#0F0F0F');
  static final Color c2C5E7A = darkBlue;
  static final Color c367AA0 = hexToArgb('#367AA0');
  static final Color c37474F = hexToArgb('#37474F');
  static final Color c3E6881 = hexToArgb('#3E6881');
  static final Color c529DC8 = hexToArgb('#529DC8');
  static final Color c546168 = hexToArgb('#546168');
  static final Color c5CB5AB = success;
  static final Color c656565 = hexToArgb('#656565');
  static final Color c707070 = hexToArgb('#707070');
  static final Color c726F6F = hexToArgb('#726F6F');
  static final Color c737373 = hexToArgb('#737373');
  static final Color c757F85 = hexToArgb('#757F85');
  static final Color c7B868B = hexToArgb('#7B868B');
  static final Color c8F8F8F = hexToArgb('#8F8F8F');
  static final Color c949494 = hexToArgb('#949494');
  static final Color c959595 = hexToArgb('#959595');
  static final Color c979797 = hexToArgb('#979797');
  static final Color c9B9B9B = hexToArgb('#9B9B9B');
  static final Color c9D1414 = danger;
  static final Color cA0A0A0 = hexToArgb('#A0A0A0');
  static final Color cA4A4A4 = hexToArgb('#A4A4A4');
  static final Color cAFAFAF = hexToArgb('#AFAFAF');
  static final Color cB5B5B5 = hexToArgb('#B5B5B5');
  static final Color cBBBBBB = hexToArgb('#BBBBBB');
  static final Color cBEBEBE = hexToArgb('#BEBEBE');
  static final Color cC0C0C0 = hexToArgb('#C0C0C0');
  static final Color cC5C5C5 = hexToArgb('#C5C5C5');
  static final Color cC8C8C8 = hexToArgb('#C8C8C8');
  static final Color cCDE9F6 = hexToArgb('#CDE9F6');
  static final Color cCECECE = hexToArgb('#CECECE');
  static final Color cD1D1D1 = hexToArgb('#D1D1D1');
  static final Color cD6D6D6 = hexToArgb('#D6D6D6');
  static final Color cD9D9D9 = hexToArgb('#D9D9D9');
  static final Color cE0E3E5 = hexToArgb('#E0E3E5');
  static final Color cE6E6E6 = hexToArgb('#E6E6E6');
  static final Color cEAEAEA = hexToArgb('#EAEAEA');
  static final Color cECEFF1 = hexToArgb('#ECEFF1');
  static final Color cEDEDED = hexToArgb('#EDEDED');
  static final Color cEEEEEE = hexToArgb('#EEEEEE');
  static final Color cF3F3F3 = hexToArgb('#F3F3F3');
  static final Color cF4F4F4 = hexToArgb('#F4F4F4');
  static final Color cF6F6F6 = hexToArgb('#F6F6F6');
  static final Color cF8F8F8 = hexToArgb('#F8F8F8');
  static final Color cFBFCFC = hexToArgb('#FBFCFC');
  static final Color cFCFCFC = hexToArgb('#FCFCFC');
  static final Color cFF8227 = accentOrange;
  static final Color cFFFFFF = hexToArgb('#FFFFFF');
  static final Color c4D0F0F0F = overlay30Black;

  static final List<Color> all = List<Color>.unmodifiable(<Color>[
    c077CD3,
    c097BC2,
    c0F0F0F,
    c2C5E7A,
    c367AA0,
    c37474F,
    c3E6881,
    c529DC8,
    c546168,
    c5CB5AB,
    c656565,
    c707070,
    c726F6F,
    c737373,
    c757F85,
    c7B868B,
    c8F8F8F,
    c949494,
    c959595,
    c979797,
    c9B9B9B,
    c9D1414,
    cA0A0A0,
    cA4A4A4,
    cAFAFAF,
    cB5B5B5,
    cBBBBBB,
    cBEBEBE,
    cC0C0C0,
    cC5C5C5,
    cC8C8C8,
    cCDE9F6,
    cCECECE,
    cD1D1D1,
    cD6D6D6,
    cD9D9D9,
    cE0E3E5,
    cE6E6E6,
    cEAEAEA,
    cECEFF1,
    cEDEDED,
    cEEEEEE,
    cF3F3F3,
    cF4F4F4,
    cF6F6F6,
    cF8F8F8,
    cFBFCFC,
    cFCFCFC,
    cFF8227,
    cFFFFFF,
    c4D0F0F0F,
  ]);
}

