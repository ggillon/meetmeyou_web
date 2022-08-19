import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/constants/image_constants.dart';
import 'package:meetmeyou_web/constants/route_constants.dart';
import 'package:meetmeyou_web/extensions/all_extensions.dart';
import 'package:meetmeyou_web/widgets/image_view.dart';

class CommonWidgets{

 static Widget commonAppBar(BuildContext context, bool navigate, {String? routeName}){
    return Card(
        margin: EdgeInsets.zero,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: DimensionConstants.d18.h, horizontal: DimensionConstants.d10.w),
            width: double.infinity,
            height: DimensionConstants.d75.h,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: DimensionConstants.d80.w,
                    alignment: Alignment.centerLeft,
                    child: ImageView(path: ImageConstants.webLogo, width: DimensionConstants.d80.w,)),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child:  Text("Welcome Sam Kalra")
                        .semiBoldText(ColorConstants.colorBlack,
                        DimensionConstants.d16.sp, TextAlign.left),
                  ),
                ),
                Container(
                  width: DimensionConstants.d80.w,
                  alignment: Alignment.centerRight,
                  child: PopupMenuButton<int>(
                    itemBuilder: (context) => [
                      // PopupMenuItem 1
                      PopupMenuItem(
                        value: 1,
                        child: Text("view_edit_profile".tr())
                            .mediumText(ColorConstants.primaryColor,
                            DimensionConstants.d14.sp, TextAlign.left),
                      ),
                      // PopupMenuItem 2
                      PopupMenuItem(
                        value: 2,
                        child:  Text("logout".tr())
                            .mediumText(ColorConstants.colorBlack,
                            DimensionConstants.d14.sp, TextAlign.left),
                      ),
                    ],
                    offset: Offset(0, 50),
                    color: Colors.white,
                    elevation: 2,
                    icon: Icon(Icons.menu, color: ColorConstants.primaryColor, size: 30),
                    onSelected: (value) {
                      if (value == 1) {
                        if(navigate){
                          context.go(routeName!);
                        }
                      } else if (value == 2) {
                      }
                    },
                  ),
                ),
              ],
            ))
    );
  }

 static Widget respondBtn(BuildContext context, String txt,
     Color bgColor, Color txtColor,
     {VoidCallback? onTapFun, double? txtSize}) {
   return GestureDetector(
       onTap: onTapFun,
       child: Container(
         height: DimensionConstants.d40.h,
         alignment: Alignment.center,
         padding: EdgeInsets.symmetric(horizontal: DimensionConstants.d10.w, vertical: DimensionConstants.d5.h),
         decoration: BoxDecoration(
             borderRadius:BorderRadius.circular(DimensionConstants.d8.r),
             color: bgColor
           // border: Border.all(
           //   color: ColorConstants.colorBlack.withOpacity(0.2),
           //   width: 1.0,
           // ),
         ),
         child: Text(txt)
             .mediumText(txtColor, txtSize ?? DimensionConstants.d15.sp, TextAlign.center),
       )
   );
 }
}