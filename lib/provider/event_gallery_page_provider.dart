import 'package:flutter/material.dart';
import 'package:meetmeyou_web/helper/dialog_helper.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/helper/shared_pref.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/main.dart';
import 'package:meetmeyou_web/models/photo.dart';
import 'package:meetmeyou_web/models/user_detail.dart';
import 'package:meetmeyou_web/provider/base_provider.dart';
import 'package:meetmeyou_web/services/mmy/mmy.dart';
import 'package:video_player/video_player.dart';

class EventGalleryPageProvider extends BaseProvider{
  MMYEngine? mmyEngine;
  //File? image;
  List<MMYPhoto> mmyPhotoList = [];
 // List<dynamic> galleryImagesUrl = [];
  LoginInfo loginInfo = LoginInfo();
  final eventId = SharedPreference.prefs!.getString(SharedPreference.eventId);

  List<PhotoGallery> photoGalleryData = [];

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
    //  galleryImagesUrl = [];
      photoGalleryData = [];
      for(int i = 0; i < mmyPhotoList.length; i++){
        if(mmyPhotoList[i].type == PHOTO_TYPE_VIDEO){
          mmyPhotoList[i].videoPlayerController = await VideoPlayerController.network(mmyPhotoList[i].photoURL)
            ..initialize().then((_) {
              notifyListeners();
            });
          photoGalleryData.add(PhotoGallery(aid: mmyPhotoList[i].aid, pid : mmyPhotoList[i].pid, ownerId: mmyPhotoList[i].ownerId,
              photoUrl: mmyPhotoList[i].photoURL, type: mmyPhotoList[i].type, videoPlayerController: mmyPhotoList[i].videoPlayerController));
        } else{
          photoGalleryData.add(PhotoGallery(aid: mmyPhotoList[i].aid, pid : mmyPhotoList[i].pid, ownerId: mmyPhotoList[i].ownerId,
              photoUrl: mmyPhotoList[i].photoURL, type: mmyPhotoList[i].type, videoPlayerController: mmyPhotoList[i].videoPlayerController));
        }

      }
     // photoGalleryData.insert(photoGalleryData.length, PhotoGallery(btn: postBtn));
      //galleryImagesUrl.insert(galleryImagesUrl.length, postBtn);

      postPhoto ? setState(ViewState.Busy) : updateGetAlbum(false);
    } else{
      photoGalleryData = [];
      postPhoto ? setState(ViewState.Busy) : updateGetAlbum(false);
    }

  }
}

class PhotoGallery{
  String? pid;
  String? aid;
  String? ownerId;
  String? photoUrl;
  String? type;
  VideoPlayerController? videoPlayerController;
  Widget? btn;

  PhotoGallery({this.aid, this.pid, this.ownerId, this.photoUrl, this.type, this.videoPlayerController, this.btn});
}