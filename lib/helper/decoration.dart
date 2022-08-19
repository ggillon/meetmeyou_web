import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/constants/string_constants.dart';


class ViewDecoration {
  static InputDecoration inputDecorationWithCurve(String fieldName, {Widget? prefix}) {
    return InputDecoration(
        prefixIcon: prefix,
        hintText: fieldName,
        hintStyle: textFieldStyle(DimensionConstants.d14.sp, ColorConstants.colorGray),
        filled: true,
        isDense: true,
        errorMaxLines: 3,
        contentPadding: EdgeInsets.fromLTRB(DimensionConstants.d5.w, DimensionConstants.d12.h, DimensionConstants.d5.w, DimensionConstants.d12.h),
        fillColor: ColorConstants.colorLightGray,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: ColorConstants.colorGray, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(DimensionConstants.d4.r))),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: ColorConstants.colorGray, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(DimensionConstants.d4.r))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.primaryColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(DimensionConstants.d4.r))),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.colorRed, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(DimensionConstants.d4.r))),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.colorRed, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(DimensionConstants.d4.r))));
  }


  static TextStyle textFieldStyle(double size, Color color) {
    return TextStyle(
        color: color,
        fontFamily: StringConstants.spProDisplay,
        fontWeight: FontWeight.w400,
        fontSize: size);
  }
}
