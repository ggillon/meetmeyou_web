import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meetmeyou_web/api_models/attend_unattend_event_response.dart';
import 'package:meetmeyou_web/api_models/get_set_profile_response.dart';
import 'package:meetmeyou_web/api_models/set_questionaire_response.dart';
import 'package:meetmeyou_web/constants/api_constants.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/api_models/get_event_response.dart';
import 'package:meetmeyou_web/services/fetch_data_exception.dart';

class Api {
  Dio dio = locator<Dio>();

  Future<GetEventResponse> getEvent(String eid) async {
    try {
      var map = {"eid": eid};

      var response = await dio.get(ApiConstants.baseUrl + ApiConstants.getEvent,
          queryParameters: map);

      return GetEventResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        throw FetchDataException("error".tr());
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<GetSetProfileResponse> getUserProfile(String uid) async {
    try {
      var map = {"uid": uid};

      var response = await dio.get(ApiConstants.baseUrl + ApiConstants.getProfile,
          queryParameters: map);

      return GetSetProfileResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        throw FetchDataException("error".tr());
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<GetSetProfileResponse> setUserProfile(String uid, String firstName, String lastName,
      String photoURL, String email, String phoneNumber, String homeAddress, String countryCode) async {
    try {
      var map = {"uid": uid, "firstName" : firstName, "lastName" : lastName, "photoURL" : photoURL,
        "email" : email, "phoneNumber" : phoneNumber, "homeAddress" : homeAddress, "countryCode" : countryCode};

      var response = await dio.get(ApiConstants.baseUrl + ApiConstants.editProfile, queryParameters: map);

      return GetSetProfileResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        throw FetchDataException("error".tr());
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<AttendUnAttendEventResponse> replyToEvent(String uid, String eid, String apiType) async {
    try {
      var map = {"uid": uid, "eid" : eid};

      var response = await dio.get(ApiConstants.baseUrl + apiType,
          queryParameters: map);

      return AttendUnAttendEventResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        throw FetchDataException("error".tr());
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<SetQuestionnaireResponse> answerToQuestionnaireForm(String uid, String eid, String answer1, String answer2, String answer3,
      String answer4, String answer5) async {
    try {

      var map = {"uid": uid, "eid" : eid, 'answers[]': [answer1, answer2, answer3, answer4, answer5]};
        //"answers" : answer1, "answers" : answer2, "answers" : answer3, "answers" : answer4, "answers" : answer5};

      var response = await dio.get(ApiConstants.baseUrl + ApiConstants.setEventAnswer, queryParameters: map);

      return SetQuestionnaireResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        throw FetchDataException("error".tr());
      } else {
        throw const SocketException("");
      }
    }
  }
}
