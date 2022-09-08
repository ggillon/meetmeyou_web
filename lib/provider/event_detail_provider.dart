import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_web/api_models/get_multi_dates_response.dart';
import 'package:meetmeyou_web/api_models/set_questionaire_response.dart';
import 'package:meetmeyou_web/constants/api_constants.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:meetmeyou_web/helper/dialog_helper.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/helper/shared_pref.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/main.dart';
import 'package:meetmeyou_web/models/date_option.dart';
import 'package:meetmeyou_web/models/event.dart';
import 'package:meetmeyou_web/api_models/get_event_response.dart';
import 'package:meetmeyou_web/models/user_detail.dart';
import 'package:meetmeyou_web/provider/base_provider.dart';
import 'package:meetmeyou_web/services/mmy/mmy.dart';
import '../services/fetch_data_exception.dart';
import 'dart:io';

class EventDetailProvider extends BaseProvider {
  final userUid = SharedPreference.prefs!.getString(SharedPreference.userId);
  final eventId = SharedPreference.prefs!.getString(SharedPreference.eventId);
  MMYEngine? mmyEngine;
  Event? event;
 // GetEventResponse? eventResponse;
  InvitedContacts? invitedContacts;
  //QuestionForm? questionForm;
  List<String> questionnaireKeysList = [];
  //List<String> questionnaireValuesList = [];
  Map? eventAnswer;
  //List<String> questionsList = [];
  //Answers? answers;
  bool multipleDates = false;

  String respondBtnStatus = '';
  Color respondBtnColor = ColorConstants.primaryColor;
  Color respondBtnTextColor = ColorConstants.colorWhite;

  LoginInfo loginInfo = LoginInfo();

  Future getEvent(BuildContext context, String eid) async {
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.getEvent(eid).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, "error".tr());
    });

    if (value != null) {
      event = value;
      eventDetail.event = value;
      respondBtnStatus = getEventBtnStatus(event!, auth.currentUser!.uid);
      respondBtnTextColor = getEventBtnColorStatus(
          event!, auth.currentUser!.uid);
     respondBtnColor = getEventBtnColorStatus(
          event!, auth.currentUser!.uid,
          textColor: false);

     /// getting ques.
      if (event!.form.isNotEmpty) {
        for (var key in event!.form.keys) {
          questionnaireKeysList.add(key);
        }
      }

      multipleDates = value.multipleDates;

      getProfileStatusKeys(event!);

      setState(ViewState.Idle);
    } else{
      event = null;
      setState(ViewState.Idle);
    }
  }

  /// Reply to event

  Future replyToEvent(BuildContext context, String eid, String response) async {
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    await mmyEngine!.replyToEvent(eid, response: response).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, "error".tr());
    });

    await getEvent(context, eventId.toString());
    setState(ViewState.Idle);

  }

  /// Reply to Questionnaire Form

  Future answersToEventQuestionnaire(
      BuildContext context, String eid, Map answers) async {
    setState(ViewState.Busy);

    await mmyEngine!.answerEventForm(eid, answers: answers).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    await replyToEvent(context, eid, EVENT_ATTENDING);
    setState(ViewState.Idle);
  }


  Future getAnswerEventForm(BuildContext context, String eid, String uid) async{
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var value =  await mmyEngine!.getAnswerEventForm(eid, uid).catchError((e){
      setState(ViewState.Idle);
       DialogHelper.showMessage(context, "error".tr());
    });

    if(value != null){
      eventAnswer = value.answers;
      setState(ViewState.Idle);
    }

  }
  /// multi dates

  // Multi date~~~~~~~~~~~~~~~

  List<String> multiDateDidsList = [];
  // this list used for attend = false
  List<String> didsOfMultiDateSelected = [];

  List<DateOption> multipleDate = [];

  bool getMultipleDate = false;

  void updateGetMultipleDate(bool value) {
    getMultipleDate = value;
    notifyListeners();
  }

  Future getMultipleDateOptionsFromEvent(BuildContext context, String eid) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    // onBtnClick ? Navigator.of(context).pop() : Container();
    var value = await mmyEngine!.getDateOptionsFromEvent(eid).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      multipleDate = value;
      await listOfDateSelected(context, eid);
      setState(ViewState.Idle);
    }
  }

  bool statusMultiDate = false;

  updateStatusMultiDate(bool value) {
    statusMultiDate = value;
    notifyListeners();
  }

  Future listOfDateSelected(BuildContext context, String eid, {bool onBtnClick = true}) async {

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.listDateSelected(eid).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      multiDateDidsList = value;
      setState(ViewState.Idle);
    }
  }

  int selectedMultiDateIndex = 0;

  bool answerMultiDate = false;

  updateMultiDate(bool value) {
    answerMultiDate = value;
    notifyListeners();
  }

  Future answerMultiDateOption(
      BuildContext context, List<String> did, bool attend) async {
    updateMultiDate(true);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    await mmyEngine!.answerDatesOption(eventId.toString(), did, attend).catchError((e) {
      updateMultiDate(false);
      DialogHelper.showMessage(context, e.message);
    });

    updateMultiDate(false);
  }

  /// get user profile~~~~~~~~
  Future<void> getUserProfile(BuildContext context) async {
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var profileResponse = await mmyEngine!.getUserProfile().catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    if(profileResponse != null){
      SharedPreference.prefs!.setString(SharedPreference.displayName, profileResponse.displayName.toString());
    }
    setState(ViewState.Idle);
  }

  /// setting response btn status
  ///
   getEventBtnStatus(Event event, String userCid) {
    List<String> keysList = [];
    for (var key in event.invitedContacts.keys) {
      keysList.add(key);
    }
    List<String> valuesList = [];
    for (var value in event.invitedContacts.values) {
      valuesList.add(value);
    }
    for (int i = 0; i < keysList.length; i++) {
      if (keysList[i] == userCid) {
        if (valuesList[i] == "Invited") {
          return "respond";
        } else if (valuesList[i] == "Organiser") {
          return "edit";
        } else if (valuesList[i] == "Attending") {
          return "going";
        } else if (valuesList[i] == "Not Attending") {
          return "not_going";
        } else if (valuesList[i] == "Not Interested") {
          return "hidden";
        } else if (valuesList[i] == "Canceled") {
          return "cancelled";
        }
      }
    }
    return "";
  }

   getEventBtnColorStatus(Event event, String userCid,{bool textColor = true}) {
    List<String> keysList = [];
    for (var key in event.invitedContacts.keys) {
      keysList.add(key);
    }
    List<String> valuesList = [];
    for (var value in event.invitedContacts.values) {
      valuesList.add(value);
    }
    for (int i = 0; i < keysList.length; i++) {
      if (keysList[i] == userCid) {
        if (valuesList[i] == "Invited") {
          return textColor
              ? ColorConstants.colorWhite
              : ColorConstants.primaryColor;
        } else if (valuesList[i] == "Organiser") {
          return textColor
              ? ColorConstants.colorWhite
              : ColorConstants.primaryColor;
        } else if (valuesList[i] == "Attending") {
          return textColor
              ? ColorConstants.primaryColor
              : ColorConstants.primaryColor.withOpacity(0.2);
        } else if (valuesList[i] == "Not Attending") {
          return textColor
              ? ColorConstants.primaryColor
              : ColorConstants.primaryColor.withOpacity(0.2);
        } else if (valuesList[i] == "Not Interested") {
          return textColor
              ? ColorConstants.primaryColor
              : ColorConstants.primaryColor.withOpacity(0.2);
        } else if (valuesList[i] == "Canceled") {
          return textColor
              ? ColorConstants.primaryColor
              : ColorConstants.primaryColor.withOpacity(0.2);
        }
      }
    }
    return textColor
        ? ColorConstants.colorWhite
        : ColorConstants.primaryColor;
  }

  /// getting attending, not-attending, invite keys~~~~~~~
///
  getProfileStatusKeys(Event event) {
    eventDetail.attendingProfileKeys = [];
    eventDetail.nonAttendingProfileKeys = [];
    eventDetail.invitedProfileKeys = [];
    List<String> keysList = [];
    for (var key in event.invitedContacts.keys) {
      keysList.add(key);
    }
    List<String> valuesList = [];
    for (var value in event.invitedContacts.values) {
      valuesList.add(value);
    }
    for (int i = 0; i < keysList.length; i++) {
        if (valuesList[i] == "Invited") {
          eventDetail.invitedProfileKeys.add(keysList[i]);
        } else if (valuesList[i] == "Organiser") {
          eventDetail.attendingProfileKeys.add(keysList[i]);
        } else if (valuesList[i] == "Attending") {
          eventDetail.attendingProfileKeys.add(keysList[i]);
        } else if (valuesList[i] == "Not Attending") {
          eventDetail.nonAttendingProfileKeys.add(keysList[i]);
        }
    }
    SharedPreference.prefs!.setStringList(SharedPreference.attendingProfileKeys, eventDetail.attendingProfileKeys);
    SharedPreference.prefs!.setStringList(SharedPreference.nonAttendingProfileKeys, eventDetail.nonAttendingProfileKeys);
    SharedPreference.prefs!.setStringList(SharedPreference.invitedProfileKeys, eventDetail.invitedProfileKeys);
    return "";
  }
}
