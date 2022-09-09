import 'package:flutter/material.dart';
import 'package:meetmeyou_web/helper/dialog_helper.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/helper/shared_pref.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/main.dart';
import 'package:meetmeyou_web/models/contact.dart';
import 'package:meetmeyou_web/provider/base_provider.dart';
import 'package:meetmeyou_web/services/mmy/mmy.dart';

class EventAttendingProvider extends BaseProvider{
  MMYEngine? mmyEngine;
  final eventId = SharedPreference.prefs!.getString(SharedPreference.eventId);

  LoginInfo loginInfo = LoginInfo();

  List<Contact> eventAttendingLists = [];
  List<Contact> eventNotAttendingLists = [];
  List<Contact> eventInvitedLists = [];

  Future getContactsFromProfile(BuildContext context) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    for(var element in eventDetail.attendingProfileKeys){
      var value = await mmyEngine!
          .getContactFromProfile(element)
          .catchError((e) async {
        setState(ViewState.Idle);
        DialogHelper.showMessage(context, e.message);
      });
      if (value != null) {
        eventAttendingLists.add(value);
      }
    }
    for(var element in eventDetail.nonAttendingProfileKeys){
      var value = await mmyEngine!
          .getContactFromProfile(element)
          .catchError((e) async {
        setState(ViewState.Idle);
        DialogHelper.showMessage(context, e.message);
      });
      if (value != null) {
        eventNotAttendingLists.add(value);
      }
    }
    for(var element in eventDetail.invitedProfileKeys){
      var value = await mmyEngine!
          .getContactFromProfile(element)
          .catchError((e) async {
        setState(ViewState.Idle);
        DialogHelper.showMessage(context, e.message);
      });
      if (value != null) {
        eventInvitedLists.add(value);
      }
    }
    // var value = await mmyEngine!
    //     .getContactFromProfile(eventDetail.organiserId.toString())
    //     .catchError((e) async {
    //   setState(ViewState.Idle);
    //   DialogHelper.showMessage(context, e.message);
    // });
    // if (value != null) {
    //   eventAttendingLists.add(value);
    // }
    setState(ViewState.Idle);
  }

  bool allowNonAttendingOrInvited = false;
  bool getParam = false;

  updateGetParam(bool val){
    getParam = val;
    notifyListeners();
  }

  Future getEventParam(BuildContext context, String eid, String param) async{
    updateGetParam(true);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value =  await mmyEngine!.getEventParam(eid, param: param).catchError((e) {
      updateGetParam(false);
      DialogHelper.showMessage(context, e.message);
    });

    if(value != null){
      allowNonAttendingOrInvited = value;
      updateGetParam(false);
    }

  }
}