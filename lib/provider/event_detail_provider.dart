import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
  UserDetail userDetail = locator<UserDetail>();

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
}
