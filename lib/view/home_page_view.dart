import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/constants/image_constants.dart';
import 'package:meetmeyou_web/extensions/all_extensions.dart';
import 'package:meetmeyou_web/helper/common_widgets.dart';
import 'package:meetmeyou_web/widgets/image_view.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: MediaQuery.of(context).size.width > 900
          ? homePageBigScreenView(context)
          : homePageSmallScreenView(context),

    );
  }

  /// large screen view
  Widget homePageBigScreenView(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: DimensionConstants.d20.h),
        Padding(
          padding: MediaQuery.of(context).size.width > 600
              ? EdgeInsets.symmetric(
              horizontal: DimensionConstants.d30.w)
              : EdgeInsets.symmetric(
              horizontal: DimensionConstants.d20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              simpleApplicationColumn(context),
              SizedBox(width: DimensionConstants.d60.w),
              SizedBox(
                  height: MediaQuery.of(context).size.width > 1200 ? MediaQuery.of(context).size.height / 1.2 : MediaQuery.of(context).size.height / 1.6,
                  child: const ImageView(
                    path: ImageConstants.phone, fit: BoxFit.cover,))
            ],
          ),
        ),
        SizedBox(height: DimensionConstants.d20.h),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: MediaQuery.of(context).size.width > 600 ? EdgeInsets.symmetric(horizontal: DimensionConstants.d30.w, vertical: DimensionConstants.d50.h)
                : EdgeInsets.symmetric(
                horizontal: DimensionConstants.d20.w),
            child:  Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    homePageCardUi(context, ImageConstants.manageContacts,
                        "manage_contacts_easily".tr(),
                        "manage_contacts_desc".tr()),
                    homePageCardUi(context, ImageConstants.shareAcrossPlatforms,
                        "share_across_platforms".tr(),
                        "share_across_platforms_desc".tr()),
                    homePageCardUi(context, ImageConstants.offerMultipleDate,
                        "offer_multiple_date_choice".tr(),
                        "offer_multiple_date_choice_desc".tr())
                  ],
                ),
                SizedBox(height: DimensionConstants.d30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    homePageCardUi(context, ImageConstants.dynamicForms,
                        "dynamic_forms_to_be_filled".tr(),
                        "dynamic_forms_to_be_filled_desc".tr()),
                    homePageCardUi(context, ImageConstants.generatesEmailAndWeb,
                        "generates_email_web_invite".tr(),
                        "generates_email_web_invite_desc".tr()),
                    homePageCardUi(context, ImageConstants.muchMore,
                        "and_much_much_more".tr(),
                        "and_much_much_more_desc".tr())
                  ],
                ),
                SizedBox(height: DimensionConstants.d20.h),
              ],
            ),
          ),
        ),
        CommonWidgets.footer()
      ],
    );
  }

  Widget simpleApplicationColumn(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("a_simple_application".tr()).semiBoldText(
              ColorConstants.colorBlack,
              DimensionConstants.d35.sp,
              TextAlign.left),
          SizedBox(height: DimensionConstants.d20.h),
          Text("the_app_allows_text".tr()).regularText(
              ColorConstants.colorBlack,
              DimensionConstants.d14.sp,
              TextAlign.left),
          SizedBox(height: DimensionConstants.d20.h),
          CommonWidgets.appPlayStoreBtn(context)
        ],
      ),
    );
  }


  /// small screen view
  Widget homePageSmallScreenView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: MediaQuery.of(context).size.width > 600
              ? EdgeInsets.symmetric(
              horizontal: DimensionConstants.d30.w)
              : EdgeInsets.symmetric(
              horizontal: DimensionConstants.d20.w),
          child: Column(
            children: [
              SizedBox(height: DimensionConstants.d20.h),
              Text("a_simple_application".tr()).semiBoldText(
                  ColorConstants.colorBlack,
                  DimensionConstants.d30.sp,
                  TextAlign.center),
              SizedBox(height: DimensionConstants.d20.h),
              Text("the_app_allows_text".tr()).regularText(
                  ColorConstants.colorBlack,
                  DimensionConstants.d12.sp,
                  TextAlign.left),
              SizedBox(height: DimensionConstants.d20.h),
              CommonWidgets.appPlayStoreBtn(context),
              SizedBox(height: DimensionConstants.d20.h),
              SizedBox(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: const ImageView(
                    path: ImageConstants.phone, fit: BoxFit.cover,)),
              SizedBox(height: DimensionConstants.d20.h),
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: MediaQuery.of(context).size.width > 600 ? EdgeInsets.symmetric(horizontal: DimensionConstants.d30.w, vertical: DimensionConstants.d50.h)
                : EdgeInsets.symmetric(
                horizontal: DimensionConstants.d20.w, vertical: DimensionConstants.d50.h),
            child: Column(
              children: [
                homePageCardUi(context, ImageConstants.manageContacts,
                    "manage_contacts_easily".tr(),
                    "manage_contacts_desc".tr()),
                SizedBox(height: DimensionConstants.d12.h),
                homePageCardUi(context, ImageConstants.shareAcrossPlatforms,
                    "share_across_platforms".tr(),
                    "share_across_platforms_desc".tr()),
                SizedBox(height: DimensionConstants.d12.h),
                homePageCardUi(context, ImageConstants.offerMultipleDate,
                    "offer_multiple_date_choice".tr(),
                    "offer_multiple_date_choice_desc".tr()),
                SizedBox(height: DimensionConstants.d12.h),
                homePageCardUi(context, ImageConstants.dynamicForms,
                    "dynamic_forms_to_be_filled".tr(),
                    "dynamic_forms_to_be_filled_desc".tr()),
                SizedBox(height: DimensionConstants.d12.h),
                homePageCardUi(context, ImageConstants.generatesEmailAndWeb,
                    "generates_email_web_invite".tr(),
                    "generates_email_web_invite_desc".tr()),
                SizedBox(height: DimensionConstants.d12.h),
                homePageCardUi(context, ImageConstants.muchMore,
                    "and_much_much_more".tr(),
                    "and_much_much_more_desc".tr())
              ],
            ),
          ),
        ),
        CommonWidgets.footer()
      ],
    );
  }
/// ~~~~~~~~~~~

  Widget homePageCardUi(BuildContext context, String imgPath, String heading,
      String desc) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.d8.r),
      ),
      child: SizedBox(
        width: homeCardWidth(MediaQuery.of(context).size.width),
        height: homeCardHeight(MediaQuery.of(context).size.width),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(DimensionConstants.d8.r),
                  topLeft: Radius.circular(DimensionConstants.d8.r)),
              child: SizedBox(
                width: homeCardWidth(MediaQuery.of(context).size.width),
                height: DimensionConstants.d300,
                child: ImageView(path: imgPath, fit: BoxFit.cover,),
              ),
            ),
            SizedBox(height: DimensionConstants.d15.h),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: DimensionConstants.d5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(heading).boldText(
                      ColorConstants.colorBlack,
                      MediaQuery.of(context).size.width > 1000 ? DimensionConstants.d16.sp : (MediaQuery.of(context).size.width < 1000 && MediaQuery.of(context).size.width >900
                          ? DimensionConstants.d14.sp :  DimensionConstants.d16.sp),
                      TextAlign.left),
                  SizedBox(height: DimensionConstants.d20.h),
                  Text(desc).regularText(
                      ColorConstants.colorBlack,
                      MediaQuery.of(context).size.width > 1000 ? DimensionConstants.d12.sp : (MediaQuery.of(context).size.width < 1000 && MediaQuery.of(context).size.width >900
                          ? DimensionConstants.d10.sp :  DimensionConstants.d12.sp),
                      TextAlign.left),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  homeCardWidth(double size) {
    if (size > 1500) {
      return DimensionConstants.d400;
    } else if (size > 1300) {
      return DimensionConstants.d350;
    } else if (size > 1150) {
      return DimensionConstants.d300;
    } else if (size > 1000){
      return DimensionConstants.d250;
    } else if (size > 900){
      return DimensionConstants.d200;
    } else if (size < 900){
      return double.infinity;
    }

  }

  homeCardHeight(double size) {
    if (size > 1200) {
      return DimensionConstants.d450;
    } else if (size > 900) {
      return DimensionConstants.d475;
    }else if (size < 900){
      return DimensionConstants.d425;
    }

  }
}

