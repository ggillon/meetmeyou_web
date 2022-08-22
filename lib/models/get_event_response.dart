class GetEventResponse {
  int? timeStamp;
  String? eventType;
  String? location;
  String? eid;
  String? status;
  String? photoURL;
  String? organiserName;
  String? description;
  String? organiserID;
  String? title;
  dynamic start;
  dynamic end;

  GetEventResponse(
      {this.timeStamp,
        this.eventType,
        this.location,
        this.eid,
        this.status,
        this.photoURL,
        this.organiserName,
        this.description,
        this.organiserID,
        this.title,
        this.start, this.end});

  GetEventResponse.fromJson(Map<String, dynamic> json) {
    timeStamp = json['timeStamp'];
    eventType = json['eventType'];
    location = json['location'];
    eid = json['eid'];
    status = json['status'];
    photoURL = json['photoURL'];
    organiserName = json['organiserName'];
    description = json['description'];
    organiserID = json['organiserID'];
    title = json['title'];
    start = json['start'];
    end = json['end'];
  }
}
