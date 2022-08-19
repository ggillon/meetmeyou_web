import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_web/dialog_helper.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/provider/base_provider.dart';
import 'package:meetmeyou_web/services/mmy/mmy.dart';

class LoginInvitedProvider extends BaseProvider{
MMYEngine? mmyEngine;

Future<void> login(
    BuildContext context, String? email, String? password) async {
  setState(ViewState.Busy);
  var user = await auth.signInEmailUser(email!, password!)
      .catchError((e) {
    setState(ViewState.Idle);
    DialogHelper.showMessage(context, e.message);
  });
  if (user != null) {
    setState(ViewState.Idle);
    getEvent(context, "rWzf-GYAY");
  }
}


Future<void> createUser(
    BuildContext context, String? email, String? password) async {
  setState(ViewState.Busy);
  var user = await auth.createEmailUser(email!, password!)
      .catchError((e) {
    setState(ViewState.Idle);
    DialogHelper.showMessage(context, e.message);
  });
  if (user != null) {
    setState(ViewState.Idle);
  }
}

Future<void> getUserDetail(BuildContext context) async {
  setState(ViewState.Busy);

  mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
  var userProfile = await mmyEngine!.getUserProfile().catchError((e) {
    setState(ViewState.Idle);
    DialogHelper.showMessage(context, e.message);
  });

  if(userProfile != null){
   print("~~~~~~~~~~~~$userProfile");
  }
  setState(ViewState.Idle);
}


Future getEvent(BuildContext context, String eid) async {
   setState(ViewState.Busy);

   mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

  var value = await mmyEngine!.getEvent(eid).catchError((e) {
    setState(ViewState.Idle);
    DialogHelper.showMessage(context, "error_message".tr());
  });

  if (value != null) {

  }
}
}