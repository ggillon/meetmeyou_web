class AttendUnAttendEventResponse{
  String? eid;
  String? uid;
  String? status;

  AttendUnAttendEventResponse.fromJson(Map<String, dynamic> json){
    eid = json['eid'];
    uid = json['uid'];
    status = json['status'];
}
}