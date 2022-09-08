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
import 'package:meetmeyou_web/main.dart';
import 'package:meetmeyou_web/models/contact.dart';
import 'package:meetmeyou_web/provider/event_attending_provider.dart';
import 'package:meetmeyou_web/view/base_view.dart';
import 'package:meetmeyou_web/widgets/image_view.dart';
import 'package:provider/provider.dart';

class EventAttendingScreen extends StatelessWidget {
  const EventAttendingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseView<EventAttendingProvider>(
        onModelReady: (provider) async {
          provider.eventDetail.attendingProfileKeys = [];
          provider.eventDetail.nonAttendingProfileKeys = [];
          provider.eventDetail.invitedProfileKeys = [];
          provider.eventDetail.attendingProfileKeys = SharedPreference.prefs!.getStringList(SharedPreference.attendingProfileKeys) ?? [];
          provider.eventDetail.nonAttendingProfileKeys = SharedPreference.prefs!.getStringList(SharedPreference.nonAttendingProfileKeys) ?? [];
          provider.eventDetail.invitedProfileKeys = SharedPreference.prefs!.getStringList(SharedPreference.invitedProfileKeys) ?? [];
          provider.getContactsFromProfile(context);
          await provider.getEventParam(context, provider.eventId.toString(), "AttendanceVisibility");

        },
        builder: (context, provider, _){
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  commonAppBar(context,
                      userName: SharedPreference.prefs!.getString(SharedPreference.displayName)),
                  SizedBox(height: DimensionConstants.d20.h),
                  Container(
                    height: MediaQuery.of(context).size.height/1.2,
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget commonAppBar(BuildContext context, {String? userName}){
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
                MediaQuery.of(context).size.width > 500 ? Container(width: DimensionConstants.d80.w,
                    alignment: Alignment.centerLeft,
                    child: ImageView(path: ImageConstants.webLogo, width: DimensionConstants.d80.w,)) :
                GestureDetector(
                    onTap: () async {},
                    child: ImageView(path: ImageConstants.mobileLogo, width: DimensionConstants.d80.w,)),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child:  Text(userName == null ? "Welcome" : "Welcome $userName")
                        .semiBoldText(ColorConstants.colorBlack,
                        DimensionConstants.d16.sp, TextAlign.left),
                  ),
                ),
                MediaQuery.of(context).size.width > 500 ? Container(width: DimensionConstants.d80.w) :
                Container(width: DimensionConstants.d80.w),
              ],
            ))
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
      child:CommonWidgets.userContactCard(context,
           cList[index].email, cList[index].displayName,
          profileImg: cList[index].photoURL,
          search: true,
          // searchStatus: provider.eventDetail.eventBtnStatus == "edit"
          //     ? "Event Edit"
          //     : cList[index].status == "Confirmed contact"
          //     ? ""
          //     : cList[index].email == provider.auth.currentUser?.email
          //     ? ""
          //     : cList[index].status,
          currentUser: currentUser, isFavouriteContact: cList[index].other['Favourite']),
    );
  }


}
