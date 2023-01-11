import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'package:meetmeyou_web/main.dart';
import 'package:meetmeyou_web/models/event.dart';
import 'package:meetmeyou_web/provider/event_detail_provider.dart';
import 'package:meetmeyou_web/view/base_view.dart';
import 'package:meetmeyou_web/widgets/custom_dialog.dart';
import 'package:meetmeyou_web/widgets/image_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({Key? key}) : super(key: key);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {

  OverlayEntry? overlayEntry;
  EventDetailProvider provider = locator<EventDetailProvider>();

  final answer1Controller = TextEditingController();
  final answer2Controller = TextEditingController();
  final answer3Controller = TextEditingController();
  final answer4Controller = TextEditingController();
  final answer5Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

 // LoginInfo loginInfo1 = LoginInfo();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
   // provider.loginInfo.dispose();
    provider.loginInfo = Provider.of<LoginInfo>(_scaffoldkey.currentContext!, listen: false);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
        body: BaseView<EventDetailProvider>(
      onModelReady: (provider) async {
        this.provider = provider;
        provider.loginInfo = Provider.of<LoginInfo>(context, listen: false);
      //  print(provider.auth.currentUser);
        //print(provider.eventId.toString());
      //  provider.loginInfo.setLogoutState(true);
        await provider.getEvent(context, provider.eventId.toString()).then((value) async {
          await provider.getUserProfile(context);
        });

        provider.loginInfo.setLoginState(true);
        // for questionnaire answers
       if(provider.respondBtnStatus == "going" && provider.questionnaireKeysList.isNotEmpty){
           provider.getAnswerEventForm(context, provider.eventId.toString(), provider.auth.currentUser!.uid.toString()).then((value) {
             if(provider.eventAnswer != null){
               answer1Controller.text = provider.eventAnswer![provider.questionnaireKeysList[0]];
               answer2Controller.text = provider.eventAnswer!.length >=2 ? provider.eventAnswer![provider.questionnaireKeysList[1]] : "";
               answer3Controller.text = provider.eventAnswer!.length >=3 ? provider.eventAnswer![provider.questionnaireKeysList[2]] : "";
               answer4Controller.text = provider.eventAnswer!.length >=4 ? provider.eventAnswer![provider.questionnaireKeysList[3]] : "";
               answer5Controller.text = provider.eventAnswer!.length >=5 ? provider.eventAnswer![provider.questionnaireKeysList[4]] : "";
             }
           });

       }

       // for getting multi dates
        if(provider.multipleDates){
          await provider.getMultipleDateOptionsFromEvent(context, provider.eventId.toString());
        }

        if(!provider.isUserRespondsToEvent){
          (provider.eventDetail.organiserId == provider.auth.currentUser!.uid.toString() ? Container() :
          await provider.inviteUrl(context, provider.eventId.toString()));
        }

        SharedPreference.prefs!.setBool(SharedPreference.checkAppleLoginFilledProfile, true);
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
              child: provider.event == null ?  Center(
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
              ) : SingleChildScrollView(
                  child: Column(
                    children: [
                      commonAppBar(context, true,
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
                                CommonWidgets.imageView(context, provider.event?.photoURL ?? ""),
                                Positioned(
                                  bottom: -DimensionConstants.d75,
                                  child: CommonWidgets.titleDateLocationCard(context, provider.event?.title ?? "",  provider.event!.start
                                      , provider.event!.end, provider.event?.location ?? "",
                                      provider.event?.organiserName ?? "", provider.event?.description ?? ""),
                                )
                              ],
                            ),
                            SizedBox(height: DimensionConstants.d85.h),
                           provider.multipleDates ? (provider.respondBtnStatus == "edit" ? CommonWidgets.respondBtn(
                               context,
                               "organiser".tr(),
                               ColorConstants.colorNewGray,
                               ColorConstants.colorGray, onTapFun: () {},
                               width: MediaQuery.of(context).size.width/1.2) : multiAttendDateUi(context, provider))
                               : provider.respondBtnStatus == "" ? Container() : (Align(
                              alignment: Alignment.center,
                              child: (provider.respondBtnStatus == "edit") ?  CommonWidgets.respondBtn(
                                  context,
                                  "organiser".tr(),
                                  ColorConstants.colorNewGray,
                                  ColorConstants.colorGray, onTapFun: () {},
                                  width: MediaQuery.of(context).size.width/1.2) : CommonWidgets.respondBtn(
                                  context,
                                  provider.respondBtnStatus.tr(),
                                  provider.respondBtnColor,
                                  provider.respondBtnTextColor, onTapFun: () {
                                  respondBtnDialog(context);
                              }, width: MediaQuery.of(context).size.width/1.2),
                            )),
                            SizedBox(height: DimensionConstants.d15.h),
                            Text("event_description".tr()).boldText(
                                ColorConstants.colorBlack,
                                DimensionConstants.d15.sp,
                                TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            SizedBox(height: DimensionConstants.d10.h),
                            Text(provider.event?.description ?? "")
                                .regularText(ColorConstants.colorGray,
                                    DimensionConstants.d12.sp, TextAlign.left,
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis),
                            SizedBox(height: DimensionConstants.d25.h),
                            provider.event?.params['photoAlbum'] == true ? photoGalleryCard(context) : Container(),
                            provider.event?.params['photoAlbum'] == true ? SizedBox(height: DimensionConstants.d15.h) : Container(),
                            checkAvailabilitiesCard(context),
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
    ));
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
                MediaQuery.of(context).size.width > 500 ? Container(width: DimensionConstants.d80.w,
                    alignment: Alignment.centerLeft,
                    child: ImageView(path: ImageConstants.webLogo, width: DimensionConstants.d80.w,)) :
               GestureDetector(
                 onTap: () async {
                   await provider.getEvent(context, provider.eventId.toString()).then((value) async {
                     await provider.getUserProfile(context);
                   });

                   provider.loginInfo.setLoginState(true);
                   // for questionnaire answers
                   if(provider.respondBtnStatus == "going" && provider.questionnaireKeysList.isNotEmpty){
                     provider.getAnswerEventForm(context, provider.eventId.toString(), provider.auth.currentUser!.uid.toString()).then((value) {
                       if(provider.eventAnswer != null){
                         answer1Controller.text = provider.eventAnswer![provider.questionnaireKeysList[0]];
                         answer2Controller.text = provider.eventAnswer!.length >=2 ? provider.eventAnswer![provider.questionnaireKeysList[1]] : "";
                         answer3Controller.text = provider.eventAnswer!.length >=3 ? provider.eventAnswer![provider.questionnaireKeysList[2]] : "";
                         answer4Controller.text = provider.eventAnswer!.length >=4 ? provider.eventAnswer![provider.questionnaireKeysList[3]] : "";
                         answer5Controller.text = provider.eventAnswer!.length >=5 ? provider.eventAnswer![provider.questionnaireKeysList[4]] : "";
                       }
                     });
                   }

                   // for getting multi dates
                   if(provider.multipleDates){
                     await provider.getMultipleDateOptionsFromEvent(context, provider.eventId.toString());
                   }

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
                    offset: const Offset(0, 50),
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
                        provider.updateLoadingStatus(true);
                        // await FirebaseFirestore.instance.clearPersistence();
                        // await provider.auth.signOut();
                        context.go("${RouteConstants.loginInvitedScreen}?eid=${provider.eventId}");
                        provider.updateLoadingStatus(true);
                      }
                    },
                  ),
                ),
              ],
            ))
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
                List<String> questionsList = [];
                for (var value in provider.eventDetail.event!.form.values) {
                  questionsList.add(value);
                }
                if(questionsList.isNotEmpty){
                  Navigator.of(context).pop();
                  alertForQuestionnaireAnswers(context, questionsList, provider);
                } else{
                  Navigator.of(context).pop();
                  provider.replyToEvent(_scaffoldkey.currentContext!, provider.eventId.toString(), EVENT_ATTENDING);
                }
              },
              notGoingClick: () {
                Navigator.of(context).pop();
                provider.replyToEvent(_scaffoldkey.currentContext!, provider.eventId.toString(), EVENT_NOT_ATTENDING);
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
            //  height:  DimensionConstants.d300,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: provider.multipleDate.length,
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
             if(provider.multiDateDidsList.contains(provider.multipleDate[index].did)){
               provider.multiDateDidsList.remove(provider.multipleDate[index].did);
               provider.didsOfMultiDateSelected.add(provider.multipleDate[index].did);
             } else{
               provider.multiDateDidsList.add(provider.multipleDate[index].did);
               provider.didsOfMultiDateSelected.remove(provider.multipleDate[index].did);
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
                  provider.multiDateDidsList.contains(provider.multipleDate[index].did)
                      ? ColorConstants.primaryColor : ColorConstants.colorWhitishGray,
                      spreadRadius: 1)
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: DimensionConstants.d2.h),
                Text("${DateTimeHelper.getMonthByName(provider.multipleDate[index].start)} "
                    " ${provider.multipleDate[index].start.year}")
                    .semiBoldText(Colors.deepOrangeAccent, DimensionConstants.d12.sp, TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                SizedBox(height: DimensionConstants.d2.h),
                Text(provider.multipleDate[index].start.day.toString())
                    .boldText(ColorConstants.colorBlack, DimensionConstants.d15.sp, TextAlign.center),
                SizedBox(height: DimensionConstants.d2.h),
                Text("${DateTimeHelper.convertEventDateToTimeFormat(provider.multipleDate[index].start)}")
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
      //  print(provider.didsOfMultiDateSelected);
        /// unattend
        if(provider.didsOfMultiDateSelected.isNotEmpty){
         await provider.answerMultiDateOption(context, provider.didsOfMultiDateSelected, false);
        }
        /// attend
        if(provider.multiDateDidsList.isNotEmpty){
          await provider.answerMultiDateOption(context, provider.multiDateDidsList, true);
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

  /// questionairre~~~~~~~~~~
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
                             final Map<String, dynamic> answersMap = <String, dynamic>{};
                              for(int i = 0; i < provider.questionnaireKeysList.length; i++){
                                if(i == 0){
                                  answersMap.addAll({
                                    provider.questionnaireKeysList[i]: answer1Controller.text
                                  });
                                } else if(i == 1){
                                  answersMap.addAll({
                                    provider.questionnaireKeysList[i]: answer2Controller.text
                                  });
                                } else if(i == 2){
                                  answersMap.addAll({
                                    provider.questionnaireKeysList[i]: answer3Controller.text
                                  });
                                } else if(i == 3){
                                  answersMap.addAll({
                                    provider.questionnaireKeysList[i]: answer4Controller.text
                                  });
                                } else if(i == 4){
                                  answersMap.addAll({
                                    provider.questionnaireKeysList[i]: answer5Controller.text
                                  });
                                }
                              }
                              Navigator.of(context).pop();
                             provider.answersToEventQuestionnaire(
                                 _scaffoldkey.currentContext!,
                                 provider.eventId.toString(),
                                 answersMap);
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
  ///~~~~~~~~~~~~~
///

  Widget photoGalleryCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DimensionConstants.d15.w),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          provider.eventDetail.eventTitle = provider.event?.title ?? "";
          provider.loginInfo = Provider.of<LoginInfo>(context, listen: false);
          provider.loginInfo.setLoginState(false);
          provider.loginInfo.setLogoutState(false);
          provider.updateLoadingStatus(true);
          context.go(RouteConstants.eventGalleryPage);
        },
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(DimensionConstants.d8.r))),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: DimensionConstants.d5.w, vertical: DimensionConstants.d8.h),
            child: Row(
              children: [
                MediaQuery.of(context).size.width > 900 ? Container() : SizedBox(width: DimensionConstants.d5.w),
                const Icon(Icons.picture_in_picture_alt_outlined),
                SizedBox(width: DimensionConstants.d5.w),
                Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text("photo_gallery".tr()).mediumText(
                          ColorConstants.colorBlack,
                          DimensionConstants.d14.sp,
                          TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    )),
                SizedBox(width: DimensionConstants.d5.w),
               const Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget checkAvailabilitiesCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DimensionConstants.d15.w),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          provider.loginInfo = Provider.of<LoginInfo>(context, listen: false);
          provider.loginInfo.setLoginState(false);
          provider.loginInfo.setLogoutState(false);
          provider.updateLoadingStatus(true);
          provider.event!.multipleDates == true ?  context.go(RouteConstants.eventAttendingMultiDateScreen)
              : context.go(RouteConstants.eventAttendingScreen);
          provider.updateLoadingStatus(true);
        },
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(DimensionConstants.d8.r))),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: DimensionConstants.d5.w, vertical: DimensionConstants.d8.h),
            child: Row(
              children: [
                MediaQuery.of(context).size.width > 900 ? Container() : SizedBox(width: DimensionConstants.d5.w),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("check_event_responses".tr()).mediumText(
                        ColorConstants.colorBlack,
                        DimensionConstants.d14.sp,
                        TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
                SizedBox(width: DimensionConstants.d5.w),
                const Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
