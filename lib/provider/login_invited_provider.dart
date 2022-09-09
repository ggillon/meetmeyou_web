import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meetmeyou_web/constants/route_constants.dart';
import 'package:meetmeyou_web/helper/dialog_helper.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/helper/common_widgets.dart';
import 'package:meetmeyou_web/helper/shared_pref.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/api_models/get_event_response.dart';
import 'package:meetmeyou_web/main.dart';
import 'package:meetmeyou_web/models/event.dart';
import 'package:meetmeyou_web/models/user_detail.dart';
import 'package:meetmeyou_web/provider/base_provider.dart';
import 'package:meetmeyou_web/services/api.dart';
import 'package:meetmeyou_web/services/mmy/mmy.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../services/fetch_data_exception.dart';
import 'dart:io';

class LoginInvitedProvider extends BaseProvider{
  MMYEngine? mmyEngine;
GetEventResponse? eventResponse;

 LoginInfo loginInfo = LoginInfo();

Future<bool> getEvent(BuildContext context, String eid) async{
  setState(ViewState.Busy);
  try{
    var model = await api.getEvent(eid);
    if(model.eid != null){
      eventResponse = model;
      SharedPreference.prefs!.setString(SharedPreference.eventId, model.eid.toString());
    } else{
      eventResponse = null;
    }
    setState(ViewState.Idle);
    return true;
  } on FetchDataException catch (c) {
    setState(ViewState.Idle);
    eventResponse = null;
    DialogHelper.showMessage(context, "error".tr());
    return false;
  } on SocketException catch (c) {
    setState(ViewState.Idle);
    eventResponse = null;
    DialogHelper.showMessage(context, 'internet_connection'.tr());
    return false;
  }
}

bool startData = false;

updateStartData(bool val){
  startData = val;
  notifyListeners();
}


Future<void> signInWithGoogle(BuildContext context) async {
  updateStartData(true);
  var user = await auth.signInWithGoogle().catchError((e) {
    updateData(false);
    DialogHelper.showDialogWithOneButton(context, "error".tr(), e.message,
        barrierDismissible: false);
  });
  if (user != null) {
    updateData(true);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var value = await mmyEngine!.isNew();
    if (value) {
      var userProfile = await mmyEngine!.createUserProfile();
      userDetail.email = userProfile.email;
      userDetail.displayName = userProfile.displayName;
      userDetail.firstName = userProfile.firstName;
      userDetail.lastName = userProfile.lastName;
      userDetail.profileUrl = userProfile.photoURL;
      SharedPreference.prefs!.setString(SharedPreference.userId, userProfile.uid.toString());
      loginInfo = Provider.of<LoginInfo>(context, listen: false);
      loginInfo.setLoginState(true);
      loginInfo.setLogoutState(false);
      updateData(false);
    //  userDetail.appleSignUpType = false;
      context.go(RouteConstants.eventDetailScreen);
    } else {
      updateData(false);
      userDetail.displayName = user.displayName;
      SharedPreference.prefs!.setString(SharedPreference.userId, user.uid.toString());
      loginInfo = Provider.of<LoginInfo>(context, listen: false);
      loginInfo.setLoginState(true);
      loginInfo.setLogoutState(false);
      context.go(RouteConstants.eventDetailScreen);
    //  userDetail.appleSignUpType = false;
    //  SharedPref.prefs?.setBool(SharedPref.IS_USER_LOGIN, true);

    }
  }
}

Future<void> signInWithFb(BuildContext context) async {
  updateStartData(true);
  var user = await auth.signInWithFacebook().catchError((e) {
    updateData(false);
    DialogHelper.showDialogWithOneButton(context, "error".tr(), e.message);
  });
  if (user != null) {
    updateData(true);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var value = await mmyEngine!.isNew();
    if (value) {
      var userProfile = await mmyEngine!.createUserProfile();
      userDetail.email = userProfile.email;
      userDetail.displayName = userProfile.displayName;
      userDetail.firstName = userProfile.firstName;
      userDetail.lastName = userProfile.lastName;
      userDetail.profileUrl = userProfile.photoURL;
      updateData(false);
      SharedPreference.prefs!.setString(SharedPreference.userId, userProfile.uid.toString());
      loginInfo = Provider.of<LoginInfo>(context, listen: false);
      loginInfo.setLoginState(true);
      loginInfo.setLogoutState(false);
      context.go(RouteConstants.eventDetailScreen);
    } else {
      updateData(false);
      userDetail.displayName = user.displayName;
      SharedPreference.prefs!.setString(SharedPreference.userId, user.uid.toString());
      loginInfo = Provider.of<LoginInfo>(context, listen: false);
      loginInfo.setLoginState(true);
      loginInfo.setLogoutState(false);
    }
  }
}


Future<void> signInWithApple(BuildContext context) async {
  updateStartData(true);
  var user = await auth.signInWithApple().catchError((e) {
    updateData(false);
    DialogHelper.showDialogWithOneButton(context, "error".tr(), e.message);
  });
  if (user != null) {
    updateData(true);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var value = await mmyEngine!.isNew();
    if (value) {
      var userProfile = await mmyEngine!.createUserProfile();
     // await mmyEngine!.appleFirstSignIn();
      print(userProfile);
      updateData(false);
      SharedPreference.prefs!.setString(SharedPreference.userId, userProfile.uid.toString());
      loginInfo = Provider.of<LoginInfo>(context, listen: false);
      loginInfo.setLoginState(true);
      loginInfo.setLogoutState(false);
    } else {
      updateData(false);
      SharedPreference.prefs!.setString(SharedPreference.userId, user.uid.toString());
      loginInfo = Provider.of<LoginInfo>(context, listen: false);
      loginInfo.setLoginState(true);
      loginInfo.setLogoutState(false);
    }
  }
}

Future<void> login(
    BuildContext context) async {
  var user = await auth.signInEmailUser("d2@gmail.com", "Qwerty@123")
      .catchError((e) {
    setState(ViewState.Idle);
    DialogHelper.showMessage(context, e.message);
  });

  SharedPreference.prefs!.setString(SharedPreference.userId, user!.uid.toString());
  //SharedPreference.prefs!.setString(SharedPreference.currentUser, jsonEncode(user.));

}

}