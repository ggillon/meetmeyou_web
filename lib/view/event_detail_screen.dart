import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meetmeyou_web/constants/api_constants.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/constants/image_constants.dart';
import 'package:meetmeyou_web/constants/route_constants.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/extensions/all_extensions.dart';
import 'package:meetmeyou_web/helper/common_widgets.dart';
import 'package:meetmeyou_web/helper/date_time_helper.dart';
import 'package:meetmeyou_web/helper/decoration.dart';
import 'package:meetmeyou_web/helper/shared_pref.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/models/event.dart';
import 'package:meetmeyou_web/provider/event_detail_provider.dart';
import 'package:meetmeyou_web/view/base_view.dart';
import 'package:meetmeyou_web/widgets/custom_dialog.dart';
import 'package:meetmeyou_web/widgets/image_view.dart';

class EventDetailScreen extends StatelessWidget {
  EventDetailScreen({Key? key}) : super(key: key);

  OverlayEntry? overlayEntry;
  EventDetailProvider provider = locator<EventDetailProvider>();

  final answer1Controller = TextEditingController();
  final answer2Controller = TextEditingController();
  final answer3Controller = TextEditingController();
  final answer4Controller = TextEditingController();
  final answer5Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
        body: BaseView<EventDetailProvider>(
      onModelReady: (provider) async {
        this.provider = provider;
        await provider.getEvent(context, provider.eventId.toString());

        // for questionnaire answers
       if(provider.respondBtnStatus == "going" && provider.questionnaireKeysList.isNotEmpty){
         await provider.getAnswersQuestionnaireForm(context);
         if(provider.answers != null){
           answer1Controller.text = provider.answers!.s1Text!;
           answer2Controller.text = provider.answers!.s2Text!;
           answer3Controller.text = provider.answers!.s3Text!;
           answer4Controller.text = provider.answers!.s4Text!;
           answer5Controller.text = provider.answers!.s5Text!;
         }
       }

       // for getting multi dates
        if(provider.multipleDates){
          await provider.getMultiDates(context);
        }
      },
      builder: (context, provider, _) {
        return provider.state == ViewState.Busy
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    SizedBox(height: DimensionConstants.d5.h),
                    Text("fetching_event".tr()).regularText(
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
                      CommonWidgets.commonAppBar(context, true,
                          routeName: RouteConstants.viewProfileScreen,
                          userName: SharedPreference.prefs!.getString(SharedPreference.displayName)),
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
                                imageView(context, provider.eventResponse?.photoURL ?? ""),
                                Positioned(
                                  bottom: -DimensionConstants.d75,
                                  child: titleDateLocationCard(context, provider.eventResponse?.title ?? "",  DateTime.fromMillisecondsSinceEpoch(provider.eventResponse?.start ?? "")
                                      , DateTime.fromMillisecondsSinceEpoch(provider.eventResponse?.end ?? ""), provider.eventResponse?.location ?? "",
                                      provider.eventResponse?.organiserName ?? ""),
                                )
                              ],
                            ),
                            SizedBox(height: DimensionConstants.d85.h),
                           provider.multipleDates ? multiAttendDateUi(context, provider)
                               : Align(
                              alignment: Alignment.center,
                              child: CommonWidgets.respondBtn(
                                  context,
                                  provider.respondBtnStatus.tr(),
                                  provider.respondBtnColor,
                                  provider.respondBtnTextColor, onTapFun: () {
                                      respondBtnDialog(context);
                              }, width: MediaQuery.of(context).size.width/1.2),
                            ),
                            SizedBox(height: DimensionConstants.d15.h),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MediaQuery.of(context).size.width > 900
                                    ? ImageView(
                                        path: ImageConstants.appStore,
                                        height: DimensionConstants.d40.h,
                                        width: DimensionConstants.d40.w,
                                        fit: BoxFit.contain,
                                      )
                                    : ImageView(
                                        path: ImageConstants.appStore,
                                        height: DimensionConstants.d60.h,
                                        width: DimensionConstants.d75.w,
                                        fit: BoxFit.contain,
                                      ),
                                SizedBox(width: DimensionConstants.d5.w),
                                MediaQuery.of(context).size.width > 900
                                    ? ImageView(
                                        path: ImageConstants.googleStore,
                                        height: DimensionConstants.d40.h,
                                        width: DimensionConstants.d40.w,
                                        fit: BoxFit.contain,
                                      )
                                    : ImageView(
                                        path: ImageConstants.googleStore,
                                        height: DimensionConstants.d60.h,
                                        width: DimensionConstants.d75.w,
                                        fit: BoxFit.contain)
                              ],
                            ),
                            SizedBox(height: DimensionConstants.d10.h),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
            );
      },
    ));
  }

  Widget imageView(BuildContext context, String photoUrl) {
    return Card(
      margin: EdgeInsets.zero,
      shadowColor: ColorConstants.colorWhite,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(DimensionConstants.d12.r),
              bottomRight: Radius.circular(DimensionConstants.d12.r))),
      color: ColorConstants.colorLightGray,
      child: SizedBox(
        height: MediaQuery.of(context).size.width > 1050
            ? DimensionConstants.d325.h
            : DimensionConstants.d300.h,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(DimensionConstants.d12.r),
              bottomRight: Radius.circular(DimensionConstants.d12.r)),
          child: photoUrl == ""
              ? ImageView(
                  path: DEFAULT_EVENT_PHOTO_URL,
                  fit: BoxFit.cover,
                  height: DimensionConstants.d50.h,
                  width: double.infinity,
                )
              : ImageView(
                  path: photoUrl,
                  fit: BoxFit.cover,
                  height: DimensionConstants.d50.h,
                  width: double.infinity,
                ),
        ),
      ),
    );
  }

  Widget titleDateLocationCard(BuildContext context, String eventTitle, DateTime startDate, DateTime endDate, String location, String organiserName) {
    return Container(
      // width: DimensionConstants.d200.w,
      padding: EdgeInsets.symmetric(horizontal: DimensionConstants.d5.w),
      child: Card(
          shadowColor: ColorConstants.colorWhite,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DimensionConstants.d12.r)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: DimensionConstants.d5.w, vertical: DimensionConstants.d10.h),
            child: Row(
              //  mainAxisSize: MainAxisSize.min,
              children: [
                dateCard(startDate),
                SizedBox(width: DimensionConstants.d5.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width > 1050 ? DimensionConstants.d175.w :  DimensionConstants.d225.w,
                      child: Text(eventTitle)
                          .boldText(ColorConstants.colorBlack,
                          DimensionConstants.d15.sp, TextAlign.left,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    SizedBox(height: DimensionConstants.d6.h),
                    Row(
                      children: [
                        const ImageView(path: ImageConstants.event_clock_icon),
                        SizedBox(width: DimensionConstants.d5.w),
                        SizedBox(
                          width:  MediaQuery.of(context).size.width > 1050 ? DimensionConstants.d150.w : DimensionConstants.d200.w,
                          child: Text(
                              (startDate.toString().substring(0, 11)) ==
                                  (endDate
                                      .toString()
                                      .substring(0, 11))
                                  ? DateTimeHelper.getWeekDay(startDate) +
                                  " - " +
                                  DateTimeHelper.convertEventDateToTimeFormat(
                                      startDate) +
                                  " to " +
                                  DateTimeHelper.convertEventDateToTimeFormat(
                                      endDate)
                                  : DateTimeHelper.getWeekDay(startDate) +
                                  " - " +
                                  DateTimeHelper.convertEventDateToTimeFormat(startDate) +
                                  " to " +
                                  DateTimeHelper.dateConversion(endDate) +
                                  " ( ${DateTimeHelper.convertEventDateToTimeFormat(endDate)})")
                              .regularText(ColorConstants.colorGray, DimensionConstants.d12.sp, TextAlign.left, maxLines: 1, overflow: TextOverflow.ellipsis),
                        )
                      ],
                    ),
                    SizedBox(height: DimensionConstants.d6.h),
                    Row(
                      children: [
                        const ImageView(path: ImageConstants.map),
                        SizedBox(width: DimensionConstants.d5.w),
                        SizedBox(
                          width:  MediaQuery.of(context).size.width > 1050 ? DimensionConstants.d150.w : DimensionConstants.d200.w,
                          child: Text(location)
                              .regularText(ColorConstants.colorGray,
                              DimensionConstants.d12.sp, TextAlign.left,
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    SizedBox(height: DimensionConstants.d5.h),
                    Row(
                      children: [
                        const Icon(Icons.person),
                        SizedBox(width: DimensionConstants.d3.w),
                        Container(
                          width:  MediaQuery.of(context).size.width > 1050 ? DimensionConstants.d150.w : DimensionConstants.d200.w,
                          child: Text("$organiserName (${"organiser".tr()})")
                              .regularText(ColorConstants.colorGray,
                              DimensionConstants.d12.sp, TextAlign.left,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget dateCard(DateTime startDate) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.d12.r)),
      child: Container(
        decoration: BoxDecoration(
            color: ColorConstants.primaryColor.withOpacity(0.2),
            borderRadius:BorderRadius.circular(DimensionConstants.d12.r) // use instead of BorderRadius.all(Radius.circular(20))
        ),
        padding: EdgeInsets.symmetric(horizontal: DimensionConstants.d10.w, vertical: DimensionConstants.d10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateTimeHelper.getMonthByName(startDate))
                .regularText(ColorConstants.primaryColor,
                DimensionConstants.d15.sp, TextAlign.center),
            Text(startDate.day <= 9 ? "0${startDate.day.toString()}" : startDate.day.toString())
                .boldText(ColorConstants.primaryColor, DimensionConstants.d14.sp,
                TextAlign.center)
          ],
        ),
      ),
    );
  }

  respondBtnDialog(BuildContext context){
    // respond dialog for an event
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) =>
            CustomDialog(
              goingClick: () {
                if(provider.questionsList.isNotEmpty){
                  Navigator.of(context).pop();
                  alertForQuestionnaireAnswers(context, provider.questionsList, provider);
                } else{
                  Navigator.of(context).pop();
                  provider.replyToEvent(_scaffoldkey.currentContext!, ApiConstants.attendEvent);
                }
              },
              notGoingClick: () {
                Navigator.of(context).pop();
                provider.replyToEvent(_scaffoldkey.currentContext!, ApiConstants.unAttendEvent);
              },
              cancelClick: () {
                Navigator.of(context).pop();
              },
            ));
  }


  /// multi dates ~~~~~~~
  ///
  Widget multiAttendDateUi(
      BuildContext context, EventDetailProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text("which_days_could_you_attend".tr()).boldText(
              ColorConstants.colorBlack,
              DimensionConstants.d13.sp,
              TextAlign.left),
        ),
        SizedBox(height: DimensionConstants.d15.h),
        // provider.multiDates.length <= 6
        //     ?
        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: DimensionConstants.d1.h),
             width: DimensionConstants.d440,
              height:  DimensionConstants.d300,
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: provider.multiDates.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0),
              itemBuilder: (context, index) {
                //  var value = provider.dateOptionStatus(context, provider.eventDetail.event!.eid,  provider.multipleDate[index].did);
                return multiAttendDateCard(context, provider, index);
              },
            ),
          ),
        ),
        //     :
        // Container(
        //   margin: EdgeInsets.symmetric(horizontal: DimensionConstants.d5.h),
        //   width: DimensionConstants.d440,
        //   height: DimensionConstants.d125,
        //   child: ListView.builder(
        //       scrollDirection: Axis.horizontal,
        //       physics: const AlwaysScrollableScrollPhysics(),
        //       shrinkWrap: true,
        //       itemCount: provider.multiDates.length,
        //       itemBuilder: (context, index) {
        //         return multiAttendDateCard(context, provider, index);
        //       }),
        // ),
        SizedBox(height: DimensionConstants.d5.h),
        submitMultiDateBtn(context, provider)
      ],
    );
  }

  Widget multiAttendDateCard(BuildContext context, EventDetailProvider provider, int index) {
    return Row(
      children: [
        GestureDetector(
          onTap: provider.answerMultiDate == true ? (){} : (){
             provider.selectedMultiDateIndex = index;
            if(provider.didAttendedDate.contains(provider.multiDates[index].did)){
              provider.didAttendedDate.remove(provider.multiDates[index].did);
              provider.didsOfMultiDateSelected.add(provider.multiDates[index].did.toString());
            } else{
              provider.didAttendedDate.add(provider.multiDates[index].did.toString());
              provider.didsOfMultiDateSelected.remove(provider.multiDates[index].did);
            }
            provider.updateLoadingStatus(true);
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: DimensionConstants.d1.h, horizontal: DimensionConstants.d1.w),
            padding: EdgeInsets.symmetric(vertical: DimensionConstants.d1.h, horizontal: DimensionConstants.d2.w),
            width: DimensionConstants.d100,
            height: DimensionConstants.d90,
            decoration: BoxDecoration(
                color: ColorConstants.colorLightGray,
                borderRadius: BorderRadius.circular(DimensionConstants.d8.r),
                boxShadow: [
                  BoxShadow(color:
                  provider.didAttendedDate.contains(provider.multiDates[index].did)
                      ? ColorConstants.primaryColor : ColorConstants.colorWhitishGray,
                      spreadRadius: 1)
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: DimensionConstants.d2.h),
                Text("${DateTimeHelper.getMonthByName(DateTime.fromMillisecondsSinceEpoch(provider.multiDates[index].start!.toInt()))} "
                    " ${DateTime.fromMillisecondsSinceEpoch(provider.multiDates[index].start!.toInt()).year}")
                    .semiBoldText(Colors.deepOrangeAccent, DimensionConstants.d12.sp, TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                SizedBox(height: DimensionConstants.d2.h),
                Text(DateTime.fromMillisecondsSinceEpoch(provider.multiDates[index].start!.toInt()).day.toString())
                    .boldText(ColorConstants.colorBlack, DimensionConstants.d15.sp, TextAlign.center),
                SizedBox(height: DimensionConstants.d2.h),
                Text("${DateTimeHelper.convertEventDateToTimeFormat(DateTime.fromMillisecondsSinceEpoch(provider.multiDates[index].start!.toInt()))}")
                    .regularText(ColorConstants.colorGray, 10.5, TextAlign.center,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                SizedBox(height: DimensionConstants.d2.h),
              ],
            ),
          ),

        ),
        SizedBox(width: DimensionConstants.d5.w)
      ],
    );
  }

  Widget submitMultiDateBtn(BuildContext context, EventDetailProvider provider) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: provider.answerMultiDate == true ? (){} : () async {
        print(provider.didsOfMultiDateSelected);
        if(provider.didsOfMultiDateSelected.isNotEmpty){
         await provider.unAttendMultiDate(context, provider.didsOfMultiDateSelected);
        }
        if(provider.didAttendedDate.isNotEmpty){
          await provider.attendMultiDate(context, provider.didAttendedDate);
        }
      },
      child: Card(
        color: provider.answerMultiDate == true ? ColorConstants.colorNewGray : ColorConstants.primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DimensionConstants.d8.r)),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: DimensionConstants.d10.h, horizontal: DimensionConstants.d5.w),
          alignment: Alignment.center,
          child: Text(provider.answerMultiDate ? "submitted".tr() : "submit".tr())
              .semiBoldText(provider.answerMultiDate == true ? ColorConstants.colorGray : ColorConstants.colorWhite,
              DimensionConstants.d12.sp, TextAlign.left,
              maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }

  alertForQuestionnaireAnswers(BuildContext context,
      List<String> questionsList, EventDetailProvider provider) {
    return showDialog(
        context: context,
        builder: (context) {
          return SizedBox(
            width: double.infinity,
            child: AlertDialog(
                title: Text("event_form_questionnaire".tr())
                    .boldText(ColorConstants.colorBlack, 15.0, TextAlign.left),
                content: SizedBox(
                  width: DimensionConstants.d100.w,
                  child: Form(
                    key: _formKey,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: questionsList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${index + 1}. ${questionsList[index]}")
                                  .mediumText(ColorConstants.colorBlack, 13,
                                  TextAlign.left,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                              SizedBox(height: DimensionConstants.d5.h),
                              TextFormField(
                                textCapitalization:
                                TextCapitalization.sentences,
                                controller: answerController(index),
                                style: ViewDecoration.textFieldStyle(
                                    DimensionConstants.d15.sp,
                                    ColorConstants.colorBlack),
                                decoration:
                                ViewDecoration.inputDecorationWithCurve(
                                    " ${"answer".tr()} ${index + 1}"),
                                onFieldSubmitted: (data) {
                                  // FocusScope.of(context).requestFocus(nodes[1]);
                                },
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return "answer_required".tr();
                                  }
                                  {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(height: DimensionConstants.d5.h),
                            ],
                          );
                        }),
                  ),
                ),
                actions: <Widget>[
                  Column(
                    children: [
                      GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                            //  final Map<String, dynamic> answersMap = {};
                              // for(int i = 0; i < provider.questionnaireKeysList.length; i++){
                              //   if(i == 0){
                              //     answersMap.addAll({
                              //       provider.questionnaireKeysList[i]: answer1Controller.text
                              //     });
                              //   } else if(i == 1){
                              //     answersMap.addAll({
                              //       provider.questionnaireKeysList[i]: answer2Controller.text
                              //     });
                              //   } else if(i == 2){
                              //     answersMap.addAll({
                              //       provider.questionnaireKeysList[i]: answer3Controller.text
                              //     });
                              //   } else if(i == 3){
                              //     answersMap.addAll({
                              //       provider.questionnaireKeysList[i]: answer4Controller.text
                              //     });
                              //   } else if(i == 4){
                              //     answersMap.addAll({
                              //       provider.questionnaireKeysList[i]: answer5Controller.text
                              //     });
                              //   }
                              // }
                              Navigator.of(context).pop();
                             provider.answerToQuestionnaireForm(context, answer1Controller.text, answer2Controller.text, answer3Controller.text, answer4Controller.text, answer5Controller.text);
                            }
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: DimensionConstants.d5.h, horizontal: DimensionConstants.d5.h),
                              decoration: BoxDecoration(
                                  color: ColorConstants.primaryColor,
                                  borderRadius: BorderRadius.circular(DimensionConstants.d8.r)
                              ),
                              child: Text('submit_answers'.tr()).semiBoldText(
                                  ColorConstants.colorWhite,
                                  13,
                                  TextAlign.left))),
                      SizedBox(height: DimensionConstants.d5.h)
                    ],
                  )
                ]),
          );
        });
  }

  answerController(int index) {
    switch (index) {
      case 0:
        return answer1Controller;

      case 1:
        return answer2Controller;

      case 2:
        return answer3Controller;

      case 3:
        return answer4Controller;

      case 4:
        return answer5Controller;
    }
  }
}
