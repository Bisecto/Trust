import 'dart:convert';

import 'package:http/http.dart' as http;

class AppRepository {
  Future<http.Response> appPostRequest(Map<String, dynamic> data, String apiUrl,
      {String accessToken = '',
      String accessPIN = '',
      String refreshToken = ''}) async {
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
  Future<http.Response> appPutRequest(Map<String, dynamic> data, String apiUrl,
      {String accessToken = '',
        String accessPIN = '',
        String refreshToken = ''}) async {
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
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );
    print(apiUrl);
    print(response);
    return response;
  }
  Future<http.Response> appGetRequest(String apiUrl,
      {String accessToken = '',
      String accessPIN = '',
      String refreshToken = ''}) async {
    //print(98765456789);
    var headers = {
      'x-access-token': accessToken,
      'x-access-pin': accessPIN,
      'x-refresh-token': refreshToken,
      'Content-Type': 'application/json'
    };
    print(headers);
    print(apiUrl);
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    print(apiUrl);
    print(response);
    return response;
  }
  Future<http.Response> appDeleteRequest(String apiUrl,
      {String accessToken = '',
      String accessPIN = '',
      String refreshToken = ''}) async {
    //print(98765456789);
    var headers = {
      'x-access-token': accessToken,
      'x-access-pin': accessPIN,
      'x-refresh-token': refreshToken,
      'Content-Type': 'application/json'
    };
    print(headers);
    print(apiUrl);
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: headers,
    );
    print(apiUrl);
    print(response);
    return response;
  }
}
