import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/constants/image_constants.dart';
import 'package:meetmeyou_web/extensions/all_extensions.dart';
import 'package:meetmeyou_web/helper/common_widgets.dart';
import 'package:meetmeyou_web/widgets/image_view.dart';
import 'dart:html' as html;

import 'package:url_launcher/url_launcher.dart';

class DataPrivacyView extends StatelessWidget {
  DataPrivacyView({Key? key}) : super(key: key);

  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'admin@meetmeyou.com',
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:  MediaQuery.of(context).size.width > 800 ?  Column(
        children: [
          dataAndPrivacyContainer(context),
          dataDeletionContainer(context),
          CommonWidgets.footer()
        ],
      ) : Column(
        children: [
          dataAndPrivacyContainerSmallScreen(context),
          dataDeletionContainerSmallView(context),
          CommonWidgets.footer()
        ],
      ),
    );
  }

  Widget dataAndPrivacyContainer(BuildContext context){
    return Container(
      color: const Color(0XFFF2F2F2),
      height: containerHeight(context, MediaQuery.of(context).size.width),
      width: double.infinity,
      child: Padding(
        padding: MediaQuery.of(context).size.width > 1000
            ? EdgeInsets.symmetric(
            horizontal: DimensionConstants.d40.w)
            : EdgeInsets.symmetric(
            horizontal: DimensionConstants.d20.w),
        child: Column(
          children: [
            SizedBox(height: DimensionConstants.d40.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3.0,
                  child: Column(
                    children: [
                      Text("data_and_privacy_policy".tr()).semiBoldText(
                          ColorConstants.colorBlack,
                          DimensionConstants.d20.sp,
                          TextAlign.center),
                      SizedBox(height: DimensionConstants.d20.h),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: "data_and_privacy_policy_desc".tr(), style: TextStyle(
                                color:  ColorConstants.colorBlack, fontSize: DimensionConstants.d14.sp
                            )),
                            TextSpan(
                              text: 'here',
                              style: TextStyle(color:  ColorConstants.primaryColor, fontSize: DimensionConstants.d14.sp, decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                html.window.open('https://www.termsfeed.com/live/1775afca-122b-4296-8fa8-75733a5f3d84', 'new tab2');
                              },
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: DimensionConstants.d20.h),
                    ],
                  ),
                ),
                SizedBox(
                    height: imageHeight(MediaQuery.of(context).size.width),
                  child: const ImageView(path: ImageConstants.dataAndPrivacy, fit: BoxFit.cover,)
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget dataDeletionContainer(BuildContext context){
    return SizedBox(
      height: containerHeight(context, MediaQuery.of(context).size.width),
      width: double.infinity,
      child: Padding(
        padding: MediaQuery.of(context).size.width > 1000
            ? EdgeInsets.symmetric(
            horizontal: DimensionConstants.d40.w)
            : EdgeInsets.symmetric(
            horizontal: DimensionConstants.d20.w),
        child: Column(
          children: [
            SizedBox(height: DimensionConstants.d40.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    height: imageHeight(MediaQuery.of(context).size.width),
                    child: const ImageView(path: ImageConstants.dataDeletion, fit: BoxFit.cover,)
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3.0,
                  child: Column(
                    children: [
                      Text("GDPR_and_data_deletion".tr()).semiBoldText(
                          ColorConstants.colorBlack,
                          DimensionConstants.d20.sp,
                          TextAlign.center),
                      SizedBox(height: DimensionConstants.d20.h),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: "data_deletion_desc1".tr(), style: TextStyle(
                                color:  ColorConstants.colorBlack, fontSize: DimensionConstants.d14.sp
                            )),
                            TextSpan(
                              text: 'admin@meetmeyou.com ',
                              style: TextStyle(color:  Colors.blue, fontSize: DimensionConstants.d14.sp, decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                launchUrl(emailLaunchUri);
                              },
                            ),
                            TextSpan(text: "data_deletion_desc2".tr(), style: TextStyle(
                                color:  ColorConstants.colorBlack, fontSize: DimensionConstants.d14.sp
                            )),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: DimensionConstants.d20.h),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// small screen view~~~~

  Widget dataAndPrivacyContainerSmallScreen(BuildContext context){
    return Container(
      color: const Color(0XFFF2F2F2),
    //  height: MediaQuery.of(context).size.height/1.2,
      width: double.infinity,
      child: Padding(
        padding: MediaQuery.of(context).size.width > 1000
            ? EdgeInsets.symmetric(
            horizontal: DimensionConstants.d40.w)
            : EdgeInsets.symmetric(
            horizontal: DimensionConstants.d20.w),
        child: Column(
          children: [
            SizedBox(height: DimensionConstants.d40.h),
            SizedBox(
             // width: MediaQuery.of(context).size.width / 3.0,
              child: Column(
                children: [
                  Text("data_and_privacy_policy".tr()).semiBoldText(
                      ColorConstants.colorBlack,
                      DimensionConstants.d20.sp,
                      TextAlign.center),
                  SizedBox(height: DimensionConstants.d20.h),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: "data_and_privacy_policy_desc".tr(), style: TextStyle(
                            color:  ColorConstants.colorBlack, fontSize: DimensionConstants.d14.sp
                        )),
                        TextSpan(
                          text: 'here',
                          style: TextStyle(color:  ColorConstants.primaryColor, fontSize: DimensionConstants.d14.sp, decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            html.window.open('https://www.termsfeed.com/live/1775afca-122b-4296-8fa8-75733a5f3d84', 'new tab2');
                          },
                        ),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: DimensionConstants.d20.h),
                ],
              ),
            ),
            SizedBox(height: DimensionConstants.d25.h),
            SizedBox(
                height: imageHeight(MediaQuery.of(context).size.width),
               width: MediaQuery.of(context).size.width / 1.25,
                child: const ImageView(path: ImageConstants.dataAndPrivacy, fit: BoxFit.cover,)
            )
          ],
        ),
      ),
    );
  }

  Widget dataDeletionContainerSmallView(BuildContext context){
    return SizedBox(
     // height: MediaQuery.of(context).size.height/1.2,
      width: double.infinity,
      child: Padding(
        padding: MediaQuery.of(context).size.width > 1000
            ? EdgeInsets.symmetric(
            horizontal: DimensionConstants.d40.w)
            : EdgeInsets.symmetric(
            horizontal: DimensionConstants.d20.w),
        child: Column(
          children: [
            SizedBox(height: DimensionConstants.d40.h),
            SizedBox(
                height: imageHeight(MediaQuery.of(context).size.width),
               width: MediaQuery.of(context).size.width / 1.25,
                child: const ImageView(path: ImageConstants.dataDeletion, fit: BoxFit.cover,)
            ),
            SizedBox(height: DimensionConstants.d25.h),
            SizedBox(
            //  width: MediaQuery.of(context).size.width / 3.0,
              child: Column(
                children: [
                  Text("GDPR_and_data_deletion".tr()).semiBoldText(
                      ColorConstants.colorBlack,
                      DimensionConstants.d20.sp,
                      TextAlign.center),
                  SizedBox(height: DimensionConstants.d20.h),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: "data_deletion_desc1".tr(), style: TextStyle(
                          color:  ColorConstants.colorBlack, fontSize: DimensionConstants.d14.sp
                        )),
                        TextSpan(
                          text: 'admin@meetmeyou.com',
                          style: TextStyle(color: Colors.blue, fontSize: DimensionConstants.d14.sp, decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            launchUrl(emailLaunchUri);
                          },
                        ),
                        TextSpan(text: "data_deletion_desc2".tr(), style: TextStyle(
                            color:  ColorConstants.colorBlack, fontSize: DimensionConstants.d14.sp
                        )),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
                  // Text("data_deletion_desc".tr()).regularText(
                  //     ColorConstants.colorBlack,
                  //     DimensionConstants.d14.sp,
                  //     TextAlign.left),
                  SizedBox(height: DimensionConstants.d20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  imageHeight(double size){
    if(size > 1350){
      return DimensionConstants.d600;
    } else if(size > 1150){
      return DimensionConstants.d500;
    } else if(size > 950){
      return DimensionConstants.d400;
    } else if(size > 800){
      return DimensionConstants.d350;
    } else{
      return DimensionConstants.d400;
    }
  }

  containerHeight(BuildContext context, double size){
    if(size > 1350){
      return  MediaQuery.of(context).size.height/1.2;
    }else if(size > 1150){
      return  MediaQuery.of(context).size.height/1.5;
    } else if(size > 950){
      return  MediaQuery.of(context).size.height/1.8;
    } else if(size > 800){
      return  MediaQuery.of(context).size.height/1.9;
    }
  }
}
