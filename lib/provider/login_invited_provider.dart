import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meetmeyou_web/constants/route_constants.dart';
import 'package:meetmeyou_web/dialog_helper.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/helper/common_widgets.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/models/get_event_response.dart';
import 'package:meetmeyou_web/models/user_detail.dart';
import 'package:meetmeyou_web/provider/base_provider.dart';
import 'package:meetmeyou_web/services/api.dart';
import 'package:meetmeyou_web/services/mmy/mmy.dart';

import '../services/fetch_data_exception.dart';
import 'dart:io';

class LoginInvitedProvider extends BaseProvider{
MMYEngine? mmyEngine;
Api api = locator<Api>();
UserDetail userDetail = locator<UserDetail>();

GetEventResponse? eventResponse;


Future<bool> getEvent(BuildContext context, String eid) async{
  setState(ViewState.Busy);
  try{
    var model = await api.getEvent(eid);
    if(model != null){
      eventResponse = model;
    }
    setState(ViewState.Idle);
    return true;
  } on FetchDataException catch (c) {
    setState(ViewState.Idle);
    DialogHelper.showMessage(context, "error_in_packing_item".tr());
    return false;
  } on SocketException catch (c) {
    setState(ViewState.Idle);
    DialogHelper.showMessage(context, 'internet_connection'.tr());
    return false;
  }
}

Future<void> signInWithGoogle(BuildContext context) async {
  updateData(true);
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
      updateData(false);
    //  userDetail.appleSignUpType = false;
      context.go(RouteConstants.eventDetailScreen);
    } else {
      updateData(false);
      userDetail.displayName = user.displayName;
      context.go(RouteConstants.eventDetailScreen);
    //  userDetail.appleSignUpType = false;
    //  SharedPref.prefs?.setBool(SharedPref.IS_USER_LOGIN, true);

    }
  }
}

Future<void> signInWithFb(BuildContext context) async {
  setState(ViewState.Busy);
  var user = await auth.signInWithFacebook().catchError((e) {
    setState(ViewState.Idle);
    DialogHelper.showDialogWithOneButton(context, "error".tr(), e.message);
  });
  if (user != null) {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var value = await mmyEngine!.isNew();
    if (value) {
      var userProfile = await mmyEngine!.createUserProfile();
      userDetail.email = userProfile.email;
      userDetail.displayName = userProfile.displayName;
      userDetail.firstName = userProfile.firstName;
      userDetail.lastName = userProfile.lastName;
      userDetail.profileUrl = userProfile.photoURL;
      setState(ViewState.Idle);
      context.go(RouteConstants.eventDetailScreen);
    } else {
      setState(ViewState.Idle);
      userDetail.displayName = user.displayName;
      context.go(RouteConstants.eventDetailScreen);
    }
  }
}


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
   // getEvent(context, "rWzf-GYAY");
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

}