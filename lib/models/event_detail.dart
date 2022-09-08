import 'package:meetmeyou_web/models/event.dart';

class EventDetail{

  String? eventTitle;
  String? organiserId;
  Event? event;
  String? eventGalleryPhotoUrl;

  // used in event attending screen
  List<String> attendingProfileKeys = [];
  List<String> nonAttendingProfileKeys = [];
  List<String> invitedProfileKeys = [];
}