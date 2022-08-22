
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/extensions/all_extensions.dart';
import 'package:meetmeyou_web/widgets/custom_shape.dart';


class CustomDialog extends StatelessWidget {
  final VoidCallback goingClick;
  final VoidCallback notGoingClick;
  final VoidCallback cancelClick;

  const CustomDialog(
      {Key? key, required this.goingClick, required this.notGoingClick, required this.cancelClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: CustomShape(
        width: DimensionConstants.d350,
        bgColor: Colors.white,
        radius: BorderRadius.all(Radius.circular(DimensionConstants.d16.r)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Ink(
              decoration: BoxDecoration(
                  color: ColorConstants.primaryColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(DimensionConstants.d16.r), topRight: Radius.circular(DimensionConstants.d16.r))),
              child: Padding(
                padding: const EdgeInsets.all(DimensionConstants.d10),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "respond".tr(),
                    ).mediumText(ColorConstants.colorWhite, DimensionConstants.d14.sp, TextAlign.center)),
              ),
            ),
            GestureDetector(
              onTap: goingClick,
              child: Padding(
                padding: const EdgeInsets.all(DimensionConstants.d8),
                child: Text("going".tr()).regularText(ColorConstants.primaryColor,DimensionConstants.d14.sp,TextAlign.center),
              ),
            ),
            const Divider(
              height: 1.0,
              color: Colors.black,
            ),
            GestureDetector(
              onTap: notGoingClick,
              child: Padding(
                padding: const EdgeInsets.all(DimensionConstants.d8),
                child: Text("not_going".tr()).regularText(ColorConstants.primaryColor, DimensionConstants.d14.sp,TextAlign.center),
              ),
            ),
            const Divider(
              height: 1.0,
              color: Colors.black,
            ),
            GestureDetector(
              onTap: cancelClick,
              child: Padding(
                padding: const EdgeInsets.all(DimensionConstants.d8),
                child: Text("cancel".tr()).regularText(ColorConstants.colorRed, DimensionConstants.d14.sp,TextAlign.center),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


