import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/helper/shared_pref.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/main.dart';
import 'package:meetmeyou_web/models/event_detail.dart';
import 'package:meetmeyou_web/models/profile.dart';
import 'package:meetmeyou_web/models/user_detail.dart';
import 'package:meetmeyou_web/services/api.dart';
import 'package:meetmeyou_web/services/auth/auth.dart';

class BaseProvider extends ChangeNotifier {
  ViewState _state = ViewState.Idle;
  bool _isDisposed = false;

  set isDisposed(bool value) {
    _isDisposed = value;
  }

  bool get isDisposed => _isDisposed;
  AuthBase auth = locator<AuthBase>();
  UserDetail userDetail = locator<UserDetail>();
  EventDetail eventDetail = locator<EventDetail>();
  Api api = locator<Api>();


  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void customNotify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  bool data = false;

  updateData(bool val){
    data = val;
    notifyListeners();
  }

  bool loading = false;

  updateLoadingStatus(bool val){
    loading = val;
    notifyListeners();
  }
}