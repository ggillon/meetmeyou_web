class SetQuestionnaireResponse{
  String? displayName;
  String? uid;
  String? attend;
  String? email;
  String? eid;

  SetQuestionnaireResponse.fromJson(Map<String, dynamic> json){
    displayName = json['displayName'];
    uid = json['uid'];
    attend = json['attend'];
    email = json['email'];
    eid = json['eid'];
  }
}
