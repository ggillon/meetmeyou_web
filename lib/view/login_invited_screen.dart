import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
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
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

class LoginInvitedScreen extends StatefulWidget {
  const LoginInvitedScreen({Key? key, required this.eid}) : super(key: key);
  final String eid;

  @override
  _LoginInvitedScreenState createState() => _LoginInvitedScreenState();
}

class _LoginInvitedScreenState extends State<LoginInvitedScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  LoginInvitedProvider provider = locator<LoginInvitedProvider>();

  @override
  void dispose() {
    provider.loginInfo = Provider.of<LoginInfo>(_scaffoldkey.currentContext!, listen: false);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  bool showFloatingBtn = false;
  bool isIosPlatform = false;
  @override
  Widget build(BuildContext context) {
    return BaseView<LoginInvitedProvider>(
        onModelReady: (provider) async {
          this.provider = provider;
         // print(MediaQuery.of(context).size.width);
          bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
          bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
          bool isMac = Theme.of(context).platform == TargetPlatform.macOS;
          if(isIOS || isMac){
            isIosPlatform = true;
            provider.updateLoadingStatus(true);
          }
          if(isIOS || isAndroid){
            showFloatingBtn = true;
            provider.updateLoadingStatus(true);
          }
          WidgetsBinding.instance.addPostFrameCallback((_){

            provider.loginInfo =  Provider.of<LoginInfo>(context, listen: false);
            provider.loginInfo.onAppStart();

          });

          await provider.getEvent(context, widget.eid);
          //   provider.loginInfo.isDisposed = false;
          //  provider.loginInfo.updateLoadingStatus(true);
        },
        builder: (context, provider, _) {
          return (provider.state == ViewState.Busy)
              ? Scaffold(
            key: _scaffoldkey,
                body: Center(
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
                  ),
              )
              : Scaffold(
            key: _scaffoldkey,
            floatingActionButton: showFloatingBtn ? floatingActionBtn() : Container(),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                body: provider.data == true ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      SizedBox(height: DimensionConstants.d5.h),
                      Text("signing_please_wait".tr()).regularText(
                          ColorConstants.primaryColor,
                          DimensionConstants.d12.sp,
                          TextAlign.left),
                    ],
                  ),
                ) : SafeArea(
                    child: provider.eventResponse == null ?  Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: DimensionConstants.d5.h),
                          Text("no_event_found".tr()).regularText(
                              ColorConstants.primaryColor,
                              DimensionConstants.d12.sp,
                              TextAlign.left),
                        ],
                      ),
                    ) :  SingleChildScrollView(
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
                                              provider.eventResponse!.start,
                                          provider.eventResponse!.end,
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
                  ),
              );
        },
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
              "sign_up_with_google".tr(), ImageConstants.ic_google, onTap: () async {
           // SharedPreference.prefs!.setString(SharedPreference.userId, "ZKsRCGO51CWRh4NslebxT3ZsEBY2");
           // await provider.login(context);
           //  provider.loginInfo = Provider.of<LoginInfo>(context, listen: false);
           //  provider.loginInfo.setLoginState(true);
           //  provider.loginInfo.setLogoutState(false);
           //  context.go(RouteConstants.eventDetailScreen);
              provider.data == true
                  ? const Center(
                child:
                CircularProgressIndicator(),
              )
                  : provider.signInWithGoogle(context);
           //  SharedPreference.prefs!.setBool(SharedPreference.checkAppleLoginFilledProfile, true);
           //  context.go(RouteConstants.editProfileScreen);
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
          isIosPlatform ? SizedBox(height: DimensionConstants.d10.h) : Container(),
          isIosPlatform ? socialMediaLoginBtn(
              "sign_up_with_apple".tr(), ImageConstants.ic_apple, onTap: () {
             context.go(RouteConstants.eventDetailScreen);
            provider.data == true
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : provider.signInWithApple(context).then((value) async {
                //  await provider.checkFilledProfile(context);
            });
          }) : Container()
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

  Widget floatingActionBtn(){
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: DimensionConstants.d10.w),
      padding: EdgeInsets.symmetric(
          horizontal: DimensionConstants.d10.w,
          vertical: DimensionConstants.d12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DimensionConstants.d8.r),
        color: ColorConstants.primaryColor
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: (){
              showFloatingBtn = false;
              provider.updateLoadingStatus(true);
            },
              child: Icon(Icons.close, color: ColorConstants.colorWhite, size: 25,)),
          SizedBox(width: DimensionConstants.d4.w),
          Expanded(
            child: Text("meet_me_you_mobile_app_allows".tr()).mediumText(ColorConstants.colorWhite,
                DimensionConstants.d14.sp, TextAlign.left, maxLines: 3, overflow: TextOverflow.ellipsis),
          ),
          SizedBox(width: DimensionConstants.d8.w),
          installBtn()
        ],
      ),
    );
  }

  Widget installBtn(){
    return GestureDetector(
      onTap: (){
     //   launch("https://play.google.com/store/apps/details?id=com.meetmeyou.meetmeyou");
     //    if(Theme.of(context).platform == TargetPlatform.iOS){
     //      launchUrl(
     //          Uri.parse("https://apps.apple.com/ke/app/meetmeyou/id1580553300"), mode: LaunchMode.externalApplication);
     //    } else if(Theme.of(context).platform == TargetPlatform.android){
     //      launchUrl(
     //          Uri.parse("https://play.google.com/store/apps/details?id=com.meetmeyou.meetmeyou&gl=GB"), mode: LaunchMode.externalApplication);
     //    }
        if(Theme.of(context).platform == TargetPlatform.iOS){
          html.window.open('https://apps.apple.com/ke/app/meetmeyou/id1580553300', 'new tab');
        } else if(Theme.of(context).platform == TargetPlatform.android){
          html.window.open('https://play.google.com/store/apps/details?id=com.meetmeyou.meetmeyou&gl=GB', 'new tab1');
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: DimensionConstants.d12.w,
            vertical: DimensionConstants.d7.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DimensionConstants.d20.r),
            color: ColorConstants.colorWhite
        ),
        child: Text("install".tr()).boldText(ColorConstants.primaryColor,
            DimensionConstants.d17.sp, TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
