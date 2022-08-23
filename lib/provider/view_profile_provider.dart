import 'package:flutter/material.dart';
import 'package:meetmeyou_web/dialog_helper.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/models/user_detail.dart';
import 'package:meetmeyou_web/provider/base_provider.dart';
import 'package:meetmeyou_web/services/mmy/mmy.dart';

class ViewProfileProvider extends BaseProvider{
  MMYEngine? mmyEngine;
  UserDetail userDetail = locator<UserDetail>();

  Future<void> getUserDetail(BuildContext context) async {
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var userProfile = await mmyEngine!.getUserProfile().catchError((e) {
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

  // Future<void> login(
  //     BuildContext context, String? email, String? password) async {
  //   await auth.signInEmailUser(email!, password!)
  //       .catchError((e) {
  //     setState(ViewState.Idle);
  //     DialogHelper.showMessage(context, e.message);
  //   });
  // }
}