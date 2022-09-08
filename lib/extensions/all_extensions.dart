import 'package:flutter/material.dart';
import 'package:meetmeyou_web/constants/string_constants.dart';

extension ExtendText on Text {
  regularText(Color color, double textSize, TextAlign alignment,
      {maxLines, overflow, bool underline = false}) {
    return Text(
      data!,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: alignment,
      style: TextStyle(
          color: color,
          fontFamily: StringConstants.spProDisplay,
          fontWeight: FontWeight.w400,
          fontSize: textSize,
          decoration:
          underline ? TextDecoration.underline : TextDecoration.none,),
    );
  }

  mediumText(Color color, double textSize, TextAlign alignment,
      {maxLines, overflow, bool underline = false}) {
    return Text(
      data!,
      maxLines: maxLines,
      textAlign: alignment,
      style: TextStyle(
          color: color,
          fontFamily: StringConstants.spProDisplay,
          fontWeight: FontWeight.w500,
          fontSize: textSize,
        decoration: underline ? TextDecoration.underline : TextDecoration.none),
    );
  }

  semiBoldText(Color color, double textSize, TextAlign alignment,
      {maxLines, overflow}) {
    return Text(
      data!,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: alignment,
      style: TextStyle(
          color: color,
          fontFamily: StringConstants.spProDisplay,
          fontWeight: FontWeight.w600,
          fontSize: textSize),
    );
  }

  boldText(Color color, double textSize, TextAlign alignment,
      {maxLines, overflow}) {
    return Text(
      data!,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: alignment,
      style: TextStyle(
          color: color,
          fontFamily: StringConstants.spProDisplay,
          fontWeight: FontWeight.w700,
          fontSize: textSize),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}