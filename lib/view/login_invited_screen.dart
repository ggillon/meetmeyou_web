import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meetmeyou_web/constants/api_constants.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/constants/image_constants.dart';
import 'package:meetmeyou_web/constants/route_constants.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/extensions/all_extensions.dart';
import 'package:meetmeyou_web/helper/common_widgets.dart';
import 'package:meetmeyou_web/helper/date_time_helper.dart';
import 'package:meetmeyou_web/helper/shared_pref.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/main.dart';
import 'package:meetmeyou_web/models/event.dart';
import 'package:meetmeyou_web/provider/login_invited_provider.dart';
import 'package:meetmeyou_web/view/base_view.dart';
import 'package:meetmeyou_web/widgets/image_view.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginInvitedScreen extends StatelessWidget {
  LoginInvitedScreen({Key? key}) : super(key: key);

  LoginInvitedProvider provider = locator<LoginInvitedProvider>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseView<LoginInvitedProvider>(
        onModelReady: (provider) async {
          this.provider = provider;
           provider.loginInfo =  Provider.of<LoginInfo>(context, listen: false);
          // provider.loginInfo.onAppStart();
          await provider.getEvent(context, "mRPe-CIWU");
          //   provider.loginInfo.isDisposed = false;
          //  provider.loginInfo.updateLoadingStatus(true);
        },
        builder: (context, provider, _) {
          return provider.state == ViewState.Busy
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      SizedBox(height: DimensionConstants.d5.h),
                      Text("loading_event_please_wait".tr()).regularText(
                          ColorConstants.primaryColor,
                          DimensionConstants.d12.sp,
                          TextAlign.left),
                    ],
                  ),
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Card(
                            margin: EdgeInsets.zero,
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: DimensionConstants.d18.h,
                                    horizontal: DimensionConstants.d40.w),
                                width: double.infinity,
                                height: DimensionConstants.d75.h,
                                alignment: Alignment.centerLeft,
                                child: const ImageView(
                                    path: ImageConstants.webLogo))),
                        Padding(
                          padding: MediaQuery.of(context).size.width > 1050
                              ? EdgeInsets.symmetric(
                                  horizontal: DimensionConstants.d50.w)
                              : EdgeInsets.symmetric(
                                  horizontal: DimensionConstants.d15.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.bottomCenter,
                                children: [
                                  CommonWidgets.imageView(context,
                                      provider.eventResponse?.photoURL ?? ""),
                                  Positioned(
                                    bottom: -DimensionConstants.d75,
                                    child: CommonWidgets.titleDateLocationCard(
                                        context,
                                        provider.eventResponse?.title ?? "",
                                        DateTime.fromMillisecondsSinceEpoch(
                                            provider.eventResponse?.start ??
                                                ""),
                                        DateTime.fromMillisecondsSinceEpoch(
                                            provider.eventResponse?.end ?? ""),
                                        provider.eventResponse?.location ?? "",
                                        provider.eventResponse?.organiserName ??
                                            ""),
                                  )
                                ],
                              ),
                              SizedBox(height: DimensionConstants.d75.h),
                              Text("event_description".tr()).boldText(
                                  ColorConstants.colorBlack,
                                  DimensionConstants.d15.sp,
                                  TextAlign.left,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              SizedBox(height: DimensionConstants.d10.h),
                              Text(provider.eventResponse?.description ?? "")
                                  .regularText(ColorConstants.colorGray,
                                      DimensionConstants.d12.sp, TextAlign.left,
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis),
                              SizedBox(height: DimensionConstants.d15.h),
                              respondToInviteContainer(context),
                              SizedBox(height: DimensionConstants.d20.h),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                        "for_advance_function_download_app_on_your_smartphone"
                                            .tr())
                                    .mediumText(
                                        ColorConstants.colorBlack,
                                        DimensionConstants.d12.sp,
                                        TextAlign.left),
                              ),
                              SizedBox(height: DimensionConstants.d10.h),
                              CommonWidgets.appPlayStoreBtn(context),
                              SizedBox(height: DimensionConstants.d10.h),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget respondToInviteContainer(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: MediaQuery.of(context).size.width > 1200
          ? EdgeInsets.symmetric(horizontal: DimensionConstants.d60.w)
          : EdgeInsets.symmetric(horizontal: DimensionConstants.d50.w),
      padding: EdgeInsets.symmetric(
          horizontal: DimensionConstants.d15.w,
          vertical: DimensionConstants.d15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DimensionConstants.d10.r),
        border: Border.all(
          color: ColorConstants.colorBlack.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          Text("to_respond_to_invite".tr()).boldText(ColorConstants.colorBlack,
              DimensionConstants.d12.sp, TextAlign.center),
          SizedBox(height: DimensionConstants.d10.h),
          socialMediaLoginBtn(
              "sign_up_with_google".tr(), ImageConstants.ic_google, onTap: () {
            SharedPreference.prefs!.setString(SharedPreference.userId, "ZKsRCGO51CWRh4NslebxT3ZsEBY2");
            //SharedPreference.prefs!.setBool(SharedPreference.isLogin, true);
            // provider.loginInfo = Provider.of<LoginInfo>(context, listen: false);
            // provider.loginInfo.setLoginState(true);
            // provider.loginInfo.setLogoutState(false);
            //  provider.loginInfo.dispose();
          //  context.go(RouteConstants.eventDetailScreen);
              provider.data == true
                  ? const Center(
                child:
                CircularProgressIndicator(),
              )
                  : provider.signInWithGoogle(context);
          }),
          SizedBox(height: DimensionConstants.d10.h),
          socialMediaLoginBtn(
              "sign_up_with_facebook".tr(), ImageConstants.ic_fb, onTap: () {
            //  context.go(RouteConstants.eventDetailScreen);
            provider.data == true
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : provider.signInWithFb(context);
          }),
          SizedBox(height: DimensionConstants.d10.h),
          socialMediaLoginBtn(
              "sign_up_with_apple".tr(), ImageConstants.ic_apple, onTap: () {
            //  context.go(RouteConstants.eventDetailScreen);
            provider.data == true
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : provider.signInWithApple(context);
          })
        ],
      ),
    );
  }

  Widget socialMediaLoginBtn(String heading, String path,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            horizontal: DimensionConstants.d10.w,
            vertical: DimensionConstants.d5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DimensionConstants.d8.r),
          border: Border.all(
            color: ColorConstants.colorBlack.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            ImageView(
              path: path,
              height: DimensionConstants.d20.h,
              width: DimensionConstants.d30.w,
            ),
            SizedBox(width: DimensionConstants.d5.w),
            Text(heading).mediumText(ColorConstants.colorBlack,
                DimensionConstants.d12.sp, TextAlign.center),
          ],
        ),
      ),
    );
  }
}
