import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meetmeyou_web/api_models/get_set_profile_response.dart';
import 'package:meetmeyou_web/constants/route_constants.dart';
import 'package:meetmeyou_web/helper/dialog_helper.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/helper/shared_pref.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/main.dart';
import 'package:meetmeyou_web/models/user_detail.dart';
import 'package:meetmeyou_web/provider/base_provider.dart';
import 'package:meetmeyou_web/services/mmy/mmy.dart';

import '../services/fetch_data_exception.dart';
import 'dart:io';

class ViewProfileProvider extends BaseProvider{
  MMYEngine? mmyEngine;
  final eventId = SharedPreference.prefs!.getString(SharedPreference.eventId);
 // final userUid = SharedPreference.prefs!.getString(SharedPreference.userId);
  LoginInfo loginInfo = LoginInfo();

 // GetSetProfileResponse? profileResponse;

  // Future<bool> getUserProfile(BuildContext context) async{
  //   setState(ViewState.Busy);
  //   try{
  //     var model = await api.getUserProfile(userUid.toString());
  //     if(model != null){
  //       profileResponse = model;
  //       SharedPreference.prefs!.setString(SharedPreference.firstName, profileResponse!.firstName.toString());
  //       SharedPreference.prefs!.setString(SharedPreference.lastName, profileResponse!.lastName.toString());
  //       SharedPreference.prefs!.setString(SharedPreference.displayName, profileResponse!.displayName.toString());
  //       SharedPreference.prefs!.setString(SharedPreference.email, profileResponse!.email.toString());
  //       SharedPreference.prefs!.setString(SharedPreference.phone, profileResponse!.phoneNumber.toString());
  //       SharedPreference.prefs!.setString(SharedPreference.countryCode, profileResponse!.countryCode.toString());
  //       SharedPreference.prefs!.setString(SharedPreference.address, profileResponse!.addresses!.home.toString());
  //       SharedPreference.prefs!.setString(SharedPreference.profileUrl, profileResponse!.photoURL.toString());
  //       userDetail.firstName = profileResponse!.firstName;
  //       userDetail.lastName = profileResponse!.lastName;
  //       userDetail.displayName = profileResponse!.displayName;
  //       userDetail.email = profileResponse!.email;
  //       userDetail.phone = profileResponse!.phoneNumber;
  //       userDetail.countryCode = profileResponse!.countryCode;
  //       userDetail.address = profileResponse!.addresses!.home;
  //       userDetail.profileUrl = profileResponse!.photoURL;
  //     }
  //     setState(ViewState.Idle);
  //     return true;
  //   } on FetchDataException catch (c) {
  //     setState(ViewState.Idle);
  //     DialogHelper.showMessage(context, "error".tr());
  //     return false;
  //   } on SocketException catch (c) {
  //     setState(ViewState.Idle);
  //     DialogHelper.showMessage(context, 'internet_connection'.tr());
  //     return false;
  //   }
  // }


  Future<void> getUserProfile(BuildContext context) async {
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var profileResponse = await mmyEngine!.getUserProfile().catchError((e) {
      setState(ViewState.Idle);
     // DialogHelper.showMessage(context, e.message);
      context.go("${RouteConstants.loginInvitedScreen}?eid=${eventId}");
    });

    if(profileResponse != null){
      SharedPreference.prefs!.setString(SharedPreference.firstName, profileResponse.firstName.toString());
      SharedPreference.prefs!.setString(SharedPreference.lastName, profileResponse.lastName.toString());
      SharedPreference.prefs!.setString(SharedPreference.displayName, profileResponse.displayName.toString());
      SharedPreference.prefs!.setString(SharedPreference.email, profileResponse.email.toString());
      SharedPreference.prefs!.setString(SharedPreference.phone, profileResponse.phoneNumber.toString());
      SharedPreference.prefs!.setString(SharedPreference.countryCode, profileResponse.countryCode.toString());
      SharedPreference.prefs!.setString(SharedPreference.address, profileResponse.addresses['Home'] ?? "");
      SharedPreference.prefs!.setString(SharedPreference.profileUrl, profileResponse.photoURL.toString());
      userDetail.firstName = profileResponse.firstName;
      userDetail.lastName = profileResponse.lastName;
      userDetail.displayName = profileResponse.displayName;
      userDetail.email = profileResponse.email;
      userDetail.phone = profileResponse.phoneNumber;
      userDetail.countryCode = profileResponse.countryCode;
      userDetail.address = profileResponse.addresses['Home'] ?? "";
      userDetail.profileUrl = profileResponse.photoURL;
    }
    setState(ViewState.Idle);
  }

}