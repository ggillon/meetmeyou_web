import 'package:flutter/material.dart';
import 'package:meetmeyou_web/dialog_helper.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/helper/shared_pref.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/main.dart';
import 'package:meetmeyou_web/models/photo.dart';
import 'package:meetmeyou_web/models/user_detail.dart';
import 'package:meetmeyou_web/provider/base_provider.dart';
import 'package:meetmeyou_web/services/mmy/mmy.dart';

class EventGalleryPageProvider extends BaseProvider{
  MMYEngine? mmyEngine;
  //File? image;
  List<MMYPhoto> mmyPhotoList = [];
  List<dynamic> galleryImagesUrl = [];
  LoginInfo loginInfo = LoginInfo();
  final eventId = SharedPreference.prefs!.getString(SharedPreference.eventId);

  /// Get photo Album
  bool getAlbum = false;

  updateGetAlbum(bool val){
    getAlbum = val;
    notifyListeners();
  }

  Future getPhotoAlbum(BuildContext context, String aid, {bool postPhoto = false, Widget? postBtn}) async{
    postPhoto ? setState(ViewState.Busy) :  updateGetAlbum(true);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.getPhotoAlbum(aid).catchError((e) {
      postPhoto ? setState(ViewState.Idle) : updateGetAlbum(false);
      DialogHelper.showMessage(context, e.message);
    });

    if(value != null){
      //image = null;
     // eventDetail.albumAdminId = value.adminId;
      eventDetail.eventTitle = value.title;
      mmyPhotoList = value.photos;
      galleryImagesUrl = [];
      for(int i = 0; i < mmyPhotoList.length; i++){
        galleryImagesUrl.add(mmyPhotoList[i].photoURL);
      }
      //galleryImagesUrl.insert(galleryImagesUrl.length, postBtn);

      postPhoto ? setState(ViewState.Busy) : updateGetAlbum(false);
    } else{
      galleryImagesUrl = [];
      postPhoto ? setState(ViewState.Busy) : updateGetAlbum(false);
    }

  }
}