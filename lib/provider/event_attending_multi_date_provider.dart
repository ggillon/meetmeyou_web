import 'package:flutter/material.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/helper/dialog_helper.dart';
import 'package:meetmeyou_web/main.dart';
import 'package:meetmeyou_web/models/date_option.dart';
import 'package:meetmeyou_web/models/event_detail.dart';
import 'package:meetmeyou_web/provider/base_provider.dart';
import 'package:meetmeyou_web/services/mmy/mmy.dart';

import '../locator.dart';

class EventAttendingMultiDateProvider extends BaseProvider{
  MMYEngine? mmyEngine;
  List<DateOption> multipleDate = [];
  LoginInfo loginInfo = LoginInfo();

  List<Map> invitedContacts = [];
  List<List<String>> eventAttendingKeysList = [];
  List<List<String>> eventAttendingPhotoUrlLists = [];
  List<String> eventAttendingPhotoUrlList = [];

  Future getMultipleDateOptionsFromEvent(BuildContext context) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.getDateOptionsFromEvent(eventDetail.event!.eid.toString()).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      multipleDate = value;
      addMultiDateTimeValue(context, multipleDate);
      setState(ViewState.Idle);
    }
  }

  addMultiDateTimeValue(
      BuildContext context, List<DateOption> multipleDate) async {
    for (int i = 0; i < multipleDate.length; i++) {
      invitedContacts.add(multipleDate[i].invitedContacts);
    }
  }

  bool imageAndKeys = false;

  updateImageAndKeys(bool val) {
    imageAndKeys = val;
    notifyListeners();
  }


  imageUrlAndAttendingKeysList(BuildContext context) async {
    updateImageAndKeys(true);
    eventAttendingPhotoUrlList.clear();
    eventAttendingKeysList.clear();
    for (int i = 0; i < invitedContacts.length; i++) {
      List<String> eventAttendingKeysList = [];
      List<String> attendingImages = [];

      List<String> keysList = [];

      for (var key in multipleDate[i].invitedContacts.keys) {
        keysList.add(key);
      }

      List<String> valuesList = [];

      for (var value in multipleDate[i].invitedContacts.values) {
        valuesList.add(value);
      }

      for (int i = 0; i < keysList.length; i++) {
        if (valuesList[i] == "Attending") {
          eventAttendingKeysList.add(keysList[i]);
          await getUsersProfileUrl(context, keysList[i]);
        }
        attendingImages.addAll(eventAttendingPhotoUrlList);
        eventAttendingPhotoUrlList.clear();
      }
      eventAttendingPhotoUrlLists.add(attendingImages);
      this.eventAttendingKeysList.add(eventAttendingKeysList);
    }

    updateImageAndKeys(false);
  }

  Future getUsersProfileUrl(BuildContext context, String key) async {
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var value =
    await mmyEngine!.getUserProfile(user: false, uid: key).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });
    eventAttendingPhotoUrlList.add(value.photoURL);

    setState(ViewState.Idle);
  }
}