class GetSetProfileResponse {
  String? firstName;
  String? email;
  String? phoneNumber;
  String? countryCode;
  String? photoURL;
  String? uid;
  String? displayName;
  Addresses? addresses;
  String? lastName;
  String? about;

  GetSetProfileResponse(
      {this.firstName,
        this.email,
        this.phoneNumber,
        this.countryCode,
        this.photoURL,
        this.uid,
        this.displayName,
        this.addresses,
        this.lastName,
        this.about});

  GetSetProfileResponse.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    countryCode = json['countryCode'];
    photoURL = json['photoURL'];
    uid = json['uid'];
    displayName = json['displayName'];
    addresses = json['addresses'] != null
        ? Addresses.fromJson(json['addresses'])
        : null;
    lastName = json['lastName'];
    about = json['about'];
  }
}

class Addresses {
  String? home;

  Addresses({this.home});

  Addresses.fromJson(Map<String, dynamic> json) {
    home = json['Home'];
  }
}
