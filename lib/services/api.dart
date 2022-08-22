import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meetmeyou_web/constants/api_constants.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/models/get_event_response.dart';
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
}
