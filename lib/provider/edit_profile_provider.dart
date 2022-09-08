import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_web/api_models/get_set_profile_response.dart';
import 'package:meetmeyou_web/helper/dialog_helper.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/helper/shared_pref.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/main.dart';
import 'package:meetmeyou_web/models/user_detail.dart';
import 'package:meetmeyou_web/provider/base_provider.dart';
import 'package:meetmeyou_web/services/fetch_data_exception.dart';
import 'package:meetmeyou_web/services/mmy/mmy.dart';

class EditProfileProvider extends BaseProvider{
  final eventId = SharedPreference.prefs!.getString(SharedPreference.eventId);
  final userUid = SharedPreference.prefs!.getString(SharedPreference.userId);
  MMYEngine? mmyEngine;
  String? countryCode;
  LoginInfo loginInfo = LoginInfo();

  // GetSetProfileResponse? profileResponse;
  //
  // Future<bool> setUserProfile(BuildContext context, String firstName, String lastName,
  //     String photoURL, String email, String phoneNumber, String homeAddress, String countryCode) async{
  //   setState(ViewState.Busy);
  //   try{
  //     var model = await api.setUserProfile(userUid.toString(), firstName, lastName, photoURL, email, phoneNumber, homeAddress, countryCode);
  //     if(model != null){
  //       profileResponse = model;
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

  Future<void> updateProfile(BuildContext context, String firstName, String lastName, String countryCode, String phoneNo, String email, String address) async {
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var userProfile = await mmyEngine!.updateProfile(firstName: firstName, lastName: lastName, countryCode: countryCode, phoneNumber: phoneNo, email: email, homeAddress: address).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    if(userProfile != null){
      userDetail.firstName = userProfile.firstName;
      userDetail.lastName = userProfile.lastName;
      userDetail.displayName = userProfile.displayName;
      userDetail.email = userProfile.email;
      userDetail.phone = userProfile.phoneNumber;
      userDetail.countryCode = userProfile.countryCode;
      userDetail.address = userProfile.addresses['Home'];
      userDetail.profileUrl = userProfile.photoURL;
    }
    setState(ViewState.Idle);
  }
}