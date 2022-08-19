import 'package:flutter/material.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/services/auth/auth.dart';

class BaseProvider extends ChangeNotifier {
  ViewState _state = ViewState.Idle;
  bool _isDisposed = false;

  AuthBase auth = locator<AuthBase>();

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