import 'package:flutter/material.dart';
import 'package:meetmeyou_web/dialog_helper.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/models/user_detail.dart';
import 'package:meetmeyou_web/provider/base_provider.dart';
import 'package:meetmeyou_web/services/mmy/mmy.dart';

class EditProfileProvider extends BaseProvider{
  MMYEngine? mmyEngine;
  UserDetail userDetail = locator<UserDetail>();
  String? countryCode;

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