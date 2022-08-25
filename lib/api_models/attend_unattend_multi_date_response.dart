class AttendUnAttendMultiDateResponse{
  String? output;

  AttendUnAttendMultiDateResponse.fromJson(Map<String, dynamic> json){
    output = json['output'];
  }
}