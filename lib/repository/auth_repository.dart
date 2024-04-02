import 'dart:convert';

import 'package:teller_trust/res/apis.dart';
import 'package:dio/dio.dart';
import '../model/user.dart';
import '../res/app_strings.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  Future<http.Response> authPostRequest(
      Map<dynamic, String> data, String apiUrl,
      {String accessToken = '',String accessPIN = '', String refreshToken = ''}) async {
    print(apiUrl);
    print(apiUrl);

    var headers = {
      'x-access-token': accessToken,
      'x-access-pin': accessPIN,
      'x-refresh-token': refreshToken,
      'Content-Type': 'application/json'
    };
    print(data);
    print(headers);
    var body = jsonEncode(data);
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );
    print(apiUrl);
    print(response);
    return response;
  }

  Future<http.Response> authGetRequest(User user, String apiUrl) async {
    print(98765456789);
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );
    return response;
  }
}
