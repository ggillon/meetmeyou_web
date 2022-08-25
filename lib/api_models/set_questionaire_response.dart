class SetQuestionnaireResponse{
  String? displayName;
  String? uid;
  String? attend;
  String? email;
  String? eid;
  Answers? answers;

  SetQuestionnaireResponse.fromJson(Map<String, dynamic> json){
    displayName = json['displayName'];
    uid = json['uid'];
    attend = json['attend'];
    email = json['email'];
    eid = json['eid'];
    answers =
    json['answers'] != null ? Answers.fromJson(json['answers']) : null;
  }
}

class Answers {
  String? s1Text;
  String? s2Text;
  String? s3Text;
  String? s4Text;
  String? s5Text;

  Answers({this.s1Text, this.s2Text, this.s3Text, this.s4Text, this.s5Text});

  Answers.fromJson(Map<String, dynamic> json) {
    s1Text = json['1. text'];
    s2Text = json['2. text'];
    s3Text = json['3. text'];
    s4Text = json['4. text'];
    s5Text = json['5. text'];
  }
}
