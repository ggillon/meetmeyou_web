import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_web/api_models/get_multi_dates_response.dart';
import 'package:meetmeyou_web/api_models/set_questionaire_response.dart';
import 'package:meetmeyou_web/constants/api_constants.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:meetmeyou_web/dialog_helper.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/helper/shared_pref.dart';
import 'package:meetmeyou_web/locator.dart';
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
 // MMYEngine? mmyEngine;
//  Event? eventResponse;
  GetEventResponse? eventResponse;
  InvitedContacts? invitedContacts;
  QuestionForm? questionForm;
  List<String> questionnaireKeysList = [];
  List<String> questionnaireValuesList = [];
  List<String> questionsList = [];
  Answers? answers;
  bool multipleDates = false;

  String respondBtnStatus = '';
  Color respondBtnColor = ColorConstants.primaryColor;
  Color respondBtnTextColor = ColorConstants.colorWhite;

  Future<bool> getEvent(BuildContext context, String eid) async{
    setState(ViewState.Busy);
    try{
      var model = await api.getEvent(eid);
      if(model != null){
        eventResponse = model;
        multipleDates = model.multipleDates ?? false;
        if(model.invitedContacts != null){
          invitedContacts = model.invitedContacts;
          respondBtnStatus =  getEventBtnStatus(invitedContacts!.keysList, invitedContacts!.valuesList);
          respondBtnColor = getEventBtnColorStatus(invitedContacts!.keysList, invitedContacts!.valuesList, textColor: false);
          respondBtnTextColor = getEventBtnColorStatus(invitedContacts!.keysList, invitedContacts!.valuesList);
        }
        if(model.form != null){
          questionsList = [];
          questionnaireKeysList = model.form!.keysList;
          questionnaireValuesList = model.form!.valuesList;

          for(int i = 0 ; i < questionnaireKeysList.length ; i++){
            if(questionnaireKeysList[i] == "1. text"){
              questionsList.add(questionnaireValuesList[i]);
            }
          }
          for(int i = 0 ; i < questionnaireKeysList.length ; i++){
            if(questionnaireKeysList[i] == "2. text"){
              questionsList.add(questionnaireValuesList[i]);
            }
          }
          for(int i = 0 ; i < questionnaireKeysList.length ; i++){
            if(questionnaireKeysList[i] == "3. text"){
              questionsList.add(questionnaireValuesList[i]);
            }
          }
          for(int i = 0 ; i < questionnaireKeysList.length ; i++){
            if(questionnaireKeysList[i] == "4. text"){
              questionsList.add(questionnaireValuesList[i]);
            }
          }
          for(int i = 0 ; i < questionnaireKeysList.length ; i++){
            if(questionnaireKeysList[i] == "5. text"){
              questionsList.add(questionnaireValuesList[i]);
            }
          }
        }
      }
      setState(ViewState.Idle);
      return true;
    } on FetchDataException catch (c) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, "error".tr());
      return false;
    } on SocketException catch (c) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
      return false;
    }
  }

  // Future getEvent(BuildContext context, String eid) async {
  //   setState(ViewState.Busy);
  //
  //   mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
  //
  //   var value = await mmyEngine!.getEvent(eid).catchError((e) {
  //     setState(ViewState.Idle);
  //     DialogHelper.showMessage(context, "error".tr());
  //   });
  //
  //   if (value != null) {
  //     eventResponse = value;
  //     setState(ViewState.Idle);
  //   }
  // }

  /// Reply to event

  Future<bool> replyToEvent(BuildContext context, String apiType) async{
    setState(ViewState.Busy);
    try{
      await api.replyToEvent(userUid.toString(), eventId.toString(), apiType);
      await getEvent(context, eventId.toString());
      setState(ViewState.Idle);
      return true;
    } on FetchDataException catch (c) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, "error".tr());
      return false;
    } on SocketException catch (c) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
      return false;
    }
  }

  // Future replyToEvent(BuildContext context, String eid, String response) async {
  //   setState(ViewState.Busy);
  //
  //   mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
  //
  //   await mmyEngine!.replyToEvent(eid, response: response).catchError((e) {
  //     setState(ViewState.Idle);
  //     DialogHelper.showMessage(context, "error".tr());
  //   });
  //
  //   setState(ViewState.Idle);
  //   Navigator.of(context).pop();
  // }

  /// Reply to Questionnaire Form

  Future<bool> answerToQuestionnaireForm(BuildContext context, String answer1, String answer2, String answer3,
      String answer4, String answer5) async{
    setState(ViewState.Busy);
    try{
      await api.answerToQuestionnaireForm(userUid.toString(), eventId.toString(), answer1, answer2, answer3, answer4, answer5);
      await replyToEvent(context, ApiConstants.attendEvent);
      setState(ViewState.Idle);
      return true;
    } on FetchDataException catch (c) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, "error".tr());
      return false;
    } on SocketException catch (c) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
      return false;
    }
  }


  Future<bool> getAnswersQuestionnaireForm(BuildContext context) async{
    setState(ViewState.Busy);
    try{
    var value =  await api.getAnswersQuestionnaireForm(userUid.toString(), eventId.toString());
    if(value != null){
      answers = value.answers;
    }
      setState(ViewState.Idle);
      return true;
    } on FetchDataException catch (c) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, "error".tr());
      return false;
    } on SocketException catch (c) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
      return false;
    }
  }

  /// multi dates

  List<GetMultiDates> multiDates = [];
  List<String> allDateDidList = [];
  List<String> didAttendedDate = [];

  Future<bool> getMultiDates(BuildContext context, {bool multiAns = false}) async{
    multiAns ? updateAnswerMultiDate(true) : setState(ViewState.Busy);
    try{
      var value =  await api.getMultiDates(eventId.toString());
      if(value != null){
        multiDates = value.multiDates;
        multiDates.sort((a,b) {
          return a.start!.compareTo(b.start!);
        });
        for(var element in multiDates){
          allDateDidList.add(element.did.toString());
        }

        for(var element in multiDates){
          var currentDateStatus = getEventBtnStatus(element.invitedContacts!.keysList, element.invitedContacts!.valuesList);
          if(currentDateStatus == "going"){
            didAttendedDate.add(element.did.toString());
          }
        }
      }
      multiAns ? updateAnswerMultiDate(false) :  setState(ViewState.Idle);
      return true;
    } on FetchDataException catch (c) {
      multiAns ? updateAnswerMultiDate(false) :  setState(ViewState.Idle);
      DialogHelper.showMessage(context, "error".tr());
      return false;
    } on SocketException catch (c) {
      multiAns ? updateAnswerMultiDate(false) :  setState(ViewState.Idle);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
      return false;
    }
  }

  bool answerMultiDate = false;

   updateAnswerMultiDate(bool val){
    answerMultiDate = val;
    notifyListeners();
  }

  int selectedMultiDateIndex = -1;

  List<String> didsOfMultiDateSelected = [];

  Future<bool> attendMultiDate(BuildContext context, List<String> dids) async{
    updateAnswerMultiDate(true);
    try{
      await api.attendMultiDate(userUid.toString(), eventId.toString(), dids);
      didsOfMultiDateSelected = [];
      await getMultiDates(context, multiAns: true);
     // updateAnswerMultiDate(false);
      return true;
    } on FetchDataException catch (c) {
      updateAnswerMultiDate(false);
      DialogHelper.showMessage(context, "error".tr());
      return false;
    } on SocketException catch (c) {
      updateAnswerMultiDate(false);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
      return false;
    }
  }

  Future<bool> unAttendMultiDate(BuildContext context, List<String> dids) async{
    updateAnswerMultiDate(true);
    try{
      await api.unAttendMultiDate(userUid.toString(), eventId.toString(), dids);
      await getMultiDates(context, multiAns: true);
      return true;
    } on FetchDataException catch (c) {
      updateAnswerMultiDate(false);
      DialogHelper.showMessage(context, "error".tr());
      return false;
    } on SocketException catch (c) {
      updateAnswerMultiDate(false);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
      return false;
    }
  }


  getEventBtnStatus(List<String> keysList, List<String> valuesList) {
      for (int i = 0; i < keysList.length; i++) {
          if (keysList[i] == userUid) {
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
      return "respond";
  }

   getEventBtnColorStatus(List<String> keysList, List<String> valuesList, {bool textColor = true}) {
       for (int i = 0; i < keysList.length; i++) {
         if (keysList[i] == userUid) {
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
}
