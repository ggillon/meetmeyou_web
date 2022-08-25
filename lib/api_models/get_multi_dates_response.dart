class GetMultiDatesResponse {
  List<GetMultiDates> multiDates = [];

  GetMultiDatesResponse.fromJson(List<dynamic> json) {
    if (json != null) {
      for (var element in json) {
        multiDates.add(GetMultiDates.fromJson(element));
      }
    } else{
      multiDates = [];
    }
  }
}

class GetMultiDates {
  int? end;
  String? location;
  String? eid;
  int? start;
  String? did;
  String? description;

  MultiDateInvitedContacts? invitedContacts;

  GetMultiDates(
      {this.end,
      this.location,
      this.eid,
      this.start,
      this.did,
      this.description});

  GetMultiDates.fromJson(Map<String, dynamic> json) {
    end = json['end'];
    location = json['location'];
    eid = json['eid'];
    start = json['start'];
    did = json['did'];
    description = json['description'];
    invitedContacts = json['invitedContacts'] != null
        ? MultiDateInvitedContacts(json['invitedContacts'])
        : null;
  }
}

class MultiDateInvitedContacts {
  List<String> keysList = [];
  List<String> valuesList = [];

  MultiDateInvitedContacts(Map<String, dynamic> json) {
    for (var key in json.keys) {
      keysList.add(key);
    }

    for (var value in json.values) {
      valuesList.add(value);
    }
  }
}
