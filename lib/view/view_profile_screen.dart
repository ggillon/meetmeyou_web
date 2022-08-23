
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/constants/image_constants.dart';
import 'package:meetmeyou_web/constants/route_constants.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/extensions/all_extensions.dart';
import 'package:meetmeyou_web/helper/common_widgets.dart';
import 'package:meetmeyou_web/provider/view_profile_provider.dart';
import 'package:meetmeyou_web/view/base_view.dart';
import 'package:meetmeyou_web/widgets/image_view.dart';

class ViewProfileScreen extends StatelessWidget {
  const ViewProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseView<ViewProfileProvider>(
        onModelReady: (provider){
          provider.getUserDetail(context);
        },
        builder: (context, provider, _){
          return provider.state == ViewState.Busy ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                SizedBox(height: DimensionConstants.d5.h),
                Text("getting_profile".tr())
                    .regularText(ColorConstants.primaryColor,
                    DimensionConstants.d12.sp, TextAlign.left),
              ],
            ),
          ) : SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonWidgets.commonAppBar(context, false, userName: provider.userDetail.displayName),
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
                          CommonWidgets.respondBtn(context, "edit_profile".tr(), ColorConstants.primaryColor, ColorConstants.colorWhite, txtSize: DimensionConstants.d12.sp, onTapFun: (){
                            context.go(RouteConstants.editProfileScreen);
                          }, width: DimensionConstants.d100, height: DimensionConstants.d45, padding:  EdgeInsets.symmetric(horizontal: DimensionConstants.d1.w)),
                        ],
                      ),
                      SizedBox(height: DimensionConstants.d15.h),
                      userDetails(context, provider, provider.userDetail.profileUrl ?? ""),
                      SizedBox(height: DimensionConstants.d15.h),
                      phoneNoAndAddressFun(ImageConstants.phone_no_icon, "Phone_number".tr(), "${provider.userDetail.countryCode} ${provider.userDetail.phone}"),
                      SizedBox(height: DimensionConstants.d10.h),
                      phoneNoAndAddressFun(ImageConstants.address_icon, "address".tr(), provider.userDetail.address ?? ""),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget userDetails(BuildContext context, ViewProfileProvider provider, String profileUrl) {
    return Row(
      children: [
        SizedBox(
          width: DimensionConstants.d110,
          height: DimensionConstants.d110,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(DimensionConstants.d12.r),
            child:
            (profileUrl == "")
                ? Container(
              color: ColorConstants.primaryColor,
              width: DimensionConstants.d110,
              height: DimensionConstants.d110,
            )
                : ImageView(
              path: profileUrl,
              width: DimensionConstants.d110,
              height: DimensionConstants.d110,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: DimensionConstants.d4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(provider.userDetail.displayName ?? "").boldText(
                  ColorConstants.colorBlack,
                  DimensionConstants.d15.sp,
                  TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              SizedBox(height: DimensionConstants.d5.h),
              Text(provider.userDetail.email ?? "").mediumText(
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
