import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_stack/image_stack.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/constants/route_constants.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/extensions/all_extensions.dart';
import 'package:meetmeyou_web/helper/common_widgets.dart';
import 'package:meetmeyou_web/helper/date_time_helper.dart';
import 'package:meetmeyou_web/helper/shared_pref.dart';
import 'package:meetmeyou_web/main.dart';
import 'package:meetmeyou_web/models/date_option.dart';
import 'package:meetmeyou_web/provider/event_attending_multi_date_provider.dart';
import 'package:meetmeyou_web/view/base_view.dart';
import 'package:provider/provider.dart';

class EventAttendingMultiDateScreen extends StatelessWidget {
  const EventAttendingMultiDateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseView<EventAttendingMultiDateProvider>(
        onModelReady: (provider) {
          provider.getMultipleDateOptionsFromEvent(context).then((value) {
            provider.imageUrlAndAttendingKeysList(context);
          });
        },
        builder: (context, provider, _){
          return provider.state == ViewState.Busy ? const Center(
            child: CircularProgressIndicator(),
          ) : SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                CommonWidgets.welcomeCommonAppBar(context,
                    userName: SharedPreference.prefs!.getString(SharedPreference.displayName)),
                SizedBox(height: DimensionConstants.d20.h),
                Expanded(
                  child: Padding(
                    padding: MediaQuery.of(context).size.width > 800 ?  EdgeInsets.symmetric(horizontal: DimensionConstants.d60.w) :
                    EdgeInsets.symmetric(horizontal: DimensionConstants.d20.w),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            provider.loginInfo =
                                Provider.of<LoginInfo>(context, listen: false);
                            provider.loginInfo.setLoginState(true);
                            context.go(RouteConstants.eventDetailScreen);
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("${"go_to_event".tr()} >>").mediumText(
                                Colors.blue,
                                DimensionConstants.d14.sp,
                                TextAlign.left,
                                underline: true),
                          ),
                        ),
                        SizedBox(height: DimensionConstants.d10.h),
                        optionsDesign(provider),
                        SizedBox(height: DimensionConstants.d20.h),
                        multiDateGridView(context, provider)
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget optionsDesign(EventAttendingMultiDateProvider provider) {
    return Row(
      children: [
        const Icon(Icons.calendar_today),
        SizedBox(width: DimensionConstants.d10.w),
        Text("${provider.multipleDate.length} ${"options".tr()}")
            .mediumText(ColorConstants.colorBlackDown, DimensionConstants.d14.sp,
            TextAlign.center),
      ],
    );
  }

  Widget multiDateGridView(BuildContext context, EventAttendingMultiDateProvider provider){
    return Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
          //  color: Colors.red,
          // height: scaler.getHeight(22.0),
            width: double.infinity,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: provider.multipleDate.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0),
              itemBuilder: (BuildContext context, int index) {
                return Column(
                 // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gridViewOfMultiDateAlertDialog(context, provider.multipleDate, index),
                    SizedBox(height: DimensionConstants.d5.h),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        provider.eventDetail.attendingProfileKeys = [];
                        provider.eventDetail.attendingProfileKeys = provider.eventAttendingKeysList[index];
                        provider.eventDetail.attendingProfileKeys.add(provider.eventDetail.organiserId.toString());
                        SharedPreference.prefs!.setStringList(SharedPreference.attendingProfileKeys, provider.eventAttendingKeysList[index]);
                        context.go(RouteConstants.eventAttendingScreen);
                        provider.updateLoadingStatus(true);
                      },
                      child: provider.eventAttendingPhotoUrlLists[index].isEmpty ? Container() : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: DimensionConstants.d15.w),
                          ImageStack(
                            imageList: provider.eventAttendingPhotoUrlLists[index],
                            totalCount: 3,
                            imageRadius: 20,
                            imageCount: 3,
                            imageBorderColor:
                            ColorConstants.colorWhite,
                            backgroundColor:
                            ColorConstants.primaryColor,
                            imageBorderWidth: 1,
                            extraCountTextStyle: TextStyle(
                                fontSize: 7.7,
                                color:
                                ColorConstants.colorWhite,
                                fontWeight: FontWeight.w500),
                            showTotalCount: false,
                          ),
                          SizedBox(width: DimensionConstants.d5.w),
                          SizedBox(
                            // alignment: Alignment.centerLeft,
                            // color: Colors.red,
                            width: 20,
                            child: Text(provider.eventAttendingPhotoUrlLists[index].length.toString()).regularText(
                                ColorConstants.colorGray,
                                DimensionConstants.d10.sp,
                                TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                          SizedBox(width: DimensionConstants.d4.w),
                          Text("available".tr()).regularText(
                              ColorConstants.colorGray,
                              DimensionConstants.d10.sp,
                              TextAlign.center),
                        ],
                      ),
                    ),
                  ],
                );
              },
            )),
      ),
    );
  }

  gridViewOfMultiDateAlertDialog(BuildContext context, List<DateOption> multiDate, int index, {int? selectedIndex}){
    return  Container(
      margin: EdgeInsets.symmetric(vertical: DimensionConstants.d1.h, horizontal: DimensionConstants.d1.w),
      padding:  MediaQuery.of(context).size.width > 800 ? EdgeInsets.symmetric(vertical: DimensionConstants.d20.h, horizontal: DimensionConstants.d10.w) :
      EdgeInsets.symmetric(vertical: DimensionConstants.d10.h, horizontal: DimensionConstants.d10.w),
      decoration: BoxDecoration(
          color: ColorConstants.colorLightGray,
          borderRadius: BorderRadius.circular(DimensionConstants.d8.r),
          boxShadow: [
            BoxShadow(
                color: selectedIndex == index ? ColorConstants.primaryColor : ColorConstants.colorWhitishGray,
                spreadRadius: 1)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              "${DateTimeHelper.getMonthByName(multiDate[index].start)} "
                  " ${multiDate[index].start.year}")
              .semiBoldText(Colors.deepOrangeAccent, 11,
              TextAlign.center),
          SizedBox(height: DimensionConstants.d5.h),
          Text(multiDate[index].start.day
              .toString())
              .boldText(ColorConstants.colorBlack, 24.0,
              TextAlign.center),
        ],
      ),
    );
  }
}
