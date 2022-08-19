
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/constants/image_constants.dart';
import 'package:meetmeyou_web/constants/route_constants.dart';
import 'package:meetmeyou_web/extensions/all_extensions.dart';
import 'package:meetmeyou_web/helper/common_widgets.dart';
import 'package:meetmeyou_web/widgets/image_view.dart';

class ViewProfileScreen extends StatelessWidget {
  const ViewProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonWidgets.commonAppBar(context, false),
            SizedBox(height: DimensionConstants.d20.h),
            Padding(
              padding: MediaQuery.of(context).size.width > 1050 ? EdgeInsets.symmetric(horizontal: DimensionConstants.d50.w) :  EdgeInsets.symmetric(horizontal: DimensionConstants.d15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${"go_to_event".tr()} >>").mediumText(Colors.blue, DimensionConstants.d14.sp, TextAlign.left, underline: true),
                  SizedBox(height: DimensionConstants.d10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("my_account".tr()).boldText(ColorConstants.colorBlack, DimensionConstants.d15.sp, TextAlign.left),
                      CommonWidgets.respondBtn(context, "edit_profile".tr(), ColorConstants.primaryColor, ColorConstants.colorWhite, txtSize: DimensionConstants.d13.sp, onTapFun: (){
                        context.go(RouteConstants.editProfileScreen);
                      }),
                    ],
                  ),
                  SizedBox(height: DimensionConstants.d15.h),
                  userDetails(context),
                  SizedBox(height: DimensionConstants.d15.h),
                  phoneNoAndAddressFun(ImageConstants.phone_no_icon, "Phone_number".tr(), "+91 9813058323"),
                  SizedBox(height: DimensionConstants.d10.h),
                  phoneNoAndAddressFun(ImageConstants.address_icon, "address".tr(), "India"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget userDetails(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: DimensionConstants.d110,
          height: DimensionConstants.d110,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(DimensionConstants.d12.r),
            child: Container(
              color: ColorConstants.primaryColor,
              width: DimensionConstants.d110,
              height: DimensionConstants.d110,
            )
            // profilePic == null
            //     ? Container(
            //   color: ColorConstants.primaryColor,
            //   width: scaler.getWidth(22),
            //   height: scaler.getWidth(22),
            // )
            //     : ImageView(
            //   path: profilePic,
            //   width: scaler.getWidth(22),
            //   height: scaler.getWidth(22),
            //   fit: BoxFit.cover,
            // ),
          ),
        ),
        SizedBox(width: DimensionConstants.d4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Sam Kalra").boldText(
                  ColorConstants.colorBlack,
                  DimensionConstants.d15.sp,
                  TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              SizedBox(height: DimensionConstants.d5.h),
              Text("samkalra1786@gmail.com").mediumText(
                      ColorConstants.colorBlack,
                      DimensionConstants.d13.sp,
                      TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)
            ],
          ),
        ),
      ],
    );
  }

  Widget phoneNoAndAddressFun(String icon, String field, String value,
      {bool countryCode = false, String? cCode}) {
    return Row(
      children: [
        ImageView(path: icon),
        SizedBox(width: DimensionConstants.d10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(field).boldText(ColorConstants.colorBlack,
                  DimensionConstants.d15.sp, TextAlign.left),
              SizedBox(height: DimensionConstants.d5.h),
              Text(countryCode ? "${cCode!} $value" : value).regularText(
                  ColorConstants.colorGray,
                  DimensionConstants.d13.sp,
                  TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        )
      ],
    );
  }
}
