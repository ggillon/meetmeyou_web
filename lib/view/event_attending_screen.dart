import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/extensions/all_extensions.dart';
import 'package:meetmeyou_web/helper/common_widgets.dart';
import 'package:meetmeyou_web/models/contact.dart';
import 'package:meetmeyou_web/provider/event_attending_provider.dart';
import 'package:meetmeyou_web/view/base_view.dart';

class EventAttendingScreen extends StatelessWidget {
  const EventAttendingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseView<EventAttendingProvider>(
        onModelReady: (provider) async {
          provider.getContactsFromProfile(context);
          await provider.getEventParam(context, provider.eventId.toString(), "AttendanceVisibility");
        },
        builder: (context, provider, _){
          return SafeArea(
            child: Padding(
              padding: MediaQuery.of(context).size.width > 1050
                  ? EdgeInsets.symmetric(
                  horizontal: DimensionConstants.d50.w)
                  : EdgeInsets.symmetric(
                  horizontal: DimensionConstants.d15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: DimensionConstants.d5.h),
                  provider.state == ViewState.Busy
                      ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      const Center(child: CircularProgressIndicator()),
                        SizedBox(height: DimensionConstants.d5.h),
                        Text("loading_contacts".tr()).mediumText(
                            ColorConstants.primaryColor,
                            DimensionConstants.d14.sp,
                            TextAlign.left),
                      ],
                    ),
                  )
                      : (provider.eventAttendingLists.isEmpty && provider.eventNotAttendingLists.isEmpty && provider.eventInvitedLists.isEmpty) ?
                  Expanded(
                    child: Center(
                        child: Text("sorry_no_contacts_found".tr()).mediumText(
                            ColorConstants.primaryColor,
                            DimensionConstants.d14.sp,
                            TextAlign.left)
                    ),
                  )
                      :  Expanded(
                    child: Column(
                      children: [
                        provider.eventAttendingLists.isEmpty ? Container() :   Expanded(
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("attending".tr()).boldText(ColorConstants.colorBlack,
                                  DimensionConstants.d15.sp, TextAlign.center),
                              SizedBox(height: DimensionConstants.d5.h),
                              eventAttendingList(context,
                                  provider.eventAttendingLists, provider),
                            ],
                          ),
                        ),
                        (provider.allowNonAttendingOrInvited || provider.eventDetail.organiserId.toString() == provider.auth.currentUser!.uid.toString()) ?
                        (provider.eventNotAttendingLists.isEmpty ? Container() :  SizedBox(height: DimensionConstants.d5.h)) : Container(),
                        (provider.allowNonAttendingOrInvited || provider.eventDetail.organiserId.toString() == provider.auth.currentUser!.uid.toString()) ?
                        (provider.eventNotAttendingLists.isEmpty ? Container() : Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("not_attending".tr()).boldText(ColorConstants.colorBlack,
                                  DimensionConstants.d15.sp, TextAlign.center),
                              SizedBox(height: DimensionConstants.d5.h),
                              eventAttendingList(context,
                                  provider.eventNotAttendingLists, provider),
                            ],
                          ),
                        )) : Container(),
                        (provider.allowNonAttendingOrInvited || provider.eventDetail.organiserId.toString() == provider.auth.currentUser!.uid.toString())
                            ?  (provider.eventNotAttendingLists.isEmpty ? Container() : SizedBox(height: DimensionConstants.d5.h)) : Container(),
                        (provider.allowNonAttendingOrInvited || provider.eventDetail.organiserId.toString() == provider.auth.currentUser!.uid.toString())
                            ? (provider.eventInvitedLists.isEmpty ? Container() :  Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("invited".tr()).boldText(ColorConstants.colorBlack,
                                  DimensionConstants.d15.sp, TextAlign.center),
                              SizedBox(height: DimensionConstants.d5.h),
                              eventAttendingList(context,
                                  provider.eventInvitedLists, provider)
                            ],
                          ),
                        )) : Container(),
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

  Widget eventAttendingList(BuildContext context,
      List<Contact> cList, EventAttendingProvider provider) {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: cList.length,
          itemBuilder: (context, index) {
            bool currentUser = cList[index].uid == provider.auth.currentUser?.uid;
            return contactProfileCard(context, cList, index, provider, currentUser);
          }),
    );
  }

  Widget contactProfileCard(BuildContext context,
      List<Contact> cList, int index, EventAttendingProvider provider, bool currentUser) {
    return GestureDetector(
      onTap: (){},
      child: Container()
    );
  }
}
