import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
  List<String> questionsList = [];

  String respondBtnStatus = '';
  Color respondBtnColor = ColorConstants.primaryColor;
  Color respondBtnTextColor = ColorConstants.colorWhite;

  Future<bool> getEvent(BuildContext context, String eid) async{
    setState(ViewState.Busy);
    try{
      var model = await api.getEvent(eid);
      if(model != null){
        eventResponse = model;
        if(model.invitedContacts != null){
          invitedContacts = model.invitedContacts;
          respondBtnStatus =  getEventBtnStatus(invitedContacts!.keysList, invitedContacts!.valuesList);
          respondBtnColor = getEventBtnColorStatus(invitedContacts!.keysList, invitedContacts!.valuesList, textColor: false);
          respondBtnTextColor = getEventBtnColorStatus(invitedContacts!.keysList, invitedContacts!.valuesList);
        }
        if(model.form != null){
          questionnaireKeysList = model.form!.keysList;
          questionsList = model.form!.valuesList;
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
