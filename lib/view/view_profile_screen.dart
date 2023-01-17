
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
import 'package:meetmeyou_web/helper/shared_pref.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/main.dart';
import 'package:meetmeyou_web/provider/view_profile_provider.dart';
import 'package:meetmeyou_web/view/base_view.dart';
import 'package:meetmeyou_web/widgets/image_view.dart';
import 'package:provider/provider.dart';

class ViewProfileScreen extends StatelessWidget {
  ViewProfileScreen({Key? key}) : super(key: key);

  ViewProfileProvider provider = locator<ViewProfileProvider>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseView<ViewProfileProvider>(
        onModelReady: (provider){
          this.provider = provider;
          provider.loginInfo = Provider.of<LoginInfo>(context, listen: false);
          SharedPreference.prefs!.setBool(SharedPreference.checkAppleLoginFilledProfile, true);
          provider.getUserProfile(context);
         // provider.loginInfo = Provider.of<LoginInfo>(context, listen: false);
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
                commonAppBar(context, false, userName: provider.userDetail.displayName),
                SizedBox(height: DimensionConstants.d20.h),
                Padding(
                  padding: MediaQuery.of(context).size.width > 1050 ? EdgeInsets.symmetric(horizontal: DimensionConstants.d50.w) :  EdgeInsets.symmetric(horizontal: DimensionConstants.d15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: (){
                          provider.loginInfo = Provider.of<LoginInfo>(context, listen: false);
                          provider.loginInfo.setLoginState(true);
                          context.go(RouteConstants.eventDetailScreen);
                        },
                        child:Text("${"go_to_event".tr()} >>").mediumText(Colors.blue, DimensionConstants.d14.sp, TextAlign.left, underline: true),
                      ),
                      SizedBox(height: DimensionConstants.d10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("my_account".tr()).boldText(ColorConstants.colorBlack, DimensionConstants.d15.sp, TextAlign.left),
                          CommonWidgets.respondBtn(context, "edit_profile".tr(), ColorConstants.primaryColor, ColorConstants.colorWhite, txtSize: DimensionConstants.d12.sp, onTapFun: (){
                            provider.loginInfo.setLoginState(false);
                            context.go(RouteConstants.editProfileScreen);
                          }, width: DimensionConstants.d100, height: DimensionConstants.d45, padding:  EdgeInsets.symmetric(horizontal: DimensionConstants.d1.w)),
                        ],
                      ),
                      SizedBox(height: DimensionConstants.d15.h),
                      userDetails(context, provider, provider.userDetail.profileUrl ?? ""),
                      SizedBox(height: DimensionConstants.d15.h),
                      phoneNoAndAddressFun(ImageConstants.phone_no_icon, "Phone_number".tr(), "${provider.userDetail.countryCode} ${provider.userDetail.phone}"),
                      SizedBox(height: DimensionConstants.d10.h),
                      phoneNoAndAddressFun(ImageConstants.map, "address".tr(), provider.userDetail.address ?? ""),
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

  Widget commonAppBar(BuildContext context, bool navigate, {String? routeName, String? userName}){
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
                MediaQuery.of(context).size.width > 500 ?  Container(width: DimensionConstants.d80.w,
                    alignment: Alignment.centerLeft,
                    child: ImageView(path: ImageConstants.webLogo, width: DimensionConstants.d80.w,)) :
                GestureDetector(
                    onTap: () async {
                      provider.getUserProfile(context);
                    },
                    child: ImageView(path: ImageConstants.mobileLogo, width: DimensionConstants.d80.w,)),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child:  Text(userName == null ? "Welcome" : "Welcome $userName")
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
                    onSelected: (value) async {
                      if (value == 1) {
                        if(navigate){
                          provider.loginInfo = Provider.of<LoginInfo>(context, listen: false);
                          provider.loginInfo.setLoginState(false);
                          context.go(routeName!);
                          provider.updateLoadingStatus(true);
                        }
                      } else if (value == 2) {
                        //    provider.isDisposed = false;
                        provider.loginInfo = Provider.of<LoginInfo>(context, listen: false);
                        provider.loginInfo.setLoginState(false);
                        provider.loginInfo.setLogoutState(true);
                        //await provider.auth.signOut();
                        context.go("${RouteConstants.loginInvitedScreen}?eid=${provider.eventId}");
                        SharedPreference.prefs!.clear();
                        provider.updateLoadingStatus(true);
                      }
                    },
                  ),
                ),
              ],
            ))
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
