import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference{
  static const String userId = "userId";
  static const String eventId= "eventId";
  static const String firstName = "firstName";
  static const String lastName = "lastName";
  static const String displayName = "displayName";
  static const String email = "email";
  static const String phone = "phone";
  static const String countryCode = "countryCode";
  static const String address = "address";
  static const String profileUrl = "profileUrl";

  static SharedPreferences? prefs;
}