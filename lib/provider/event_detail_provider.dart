import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:meetmeyou_web/dialog_helper.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/models/event.dart';
import 'package:meetmeyou_web/models/user_detail.dart';
import 'package:meetmeyou_web/provider/base_provider.dart';
import 'package:meetmeyou_web/services/mmy/mmy.dart';

class EventDetailProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  Event? eventResponse;


  Future getEvent(BuildContext context, String eid) async {
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.getEvent(eid).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, "error".tr());
    });

    if (value != null) {
      eventResponse = value;
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

    setState(ViewState.Idle);
    Navigator.of(context).pop();
  }

   getEventBtnStatus(Event? event, String userCid) {
    if(event != null){
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
          }else if (valuesList[i] == "Attending") {
            return "going";
          } else if (valuesList[i] == "Not Attending") {
            return "not_going";
          } else if (valuesList[i] == "Canceled") {
            return "cancelled";
          }
        }
      }
      return "";
    } else{

    }

  }

   getEventBtnColorStatus(Event? event, String userCid, {bool textColor = true}) {
     if(event != null){
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
           } else if (valuesList[i] == "Attending") {
             return textColor
                 ? ColorConstants.primaryColor
                 : ColorConstants.primaryColor.withOpacity(0.2);
           } else if (valuesList[i] == "Not Attending") {
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
     } else{
       return textColor
           ? ColorConstants.colorWhite
           : ColorConstants.primaryColor;
     }

  }
}
