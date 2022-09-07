class EventDetail{

  String? eventTitle;
  String? organiserId;

  // used in event attending screen
  List<String> attendingProfileKeys = [];
  List<String> nonAttendingProfileKeys = [];
  List<String> invitedProfileKeys = [];
}