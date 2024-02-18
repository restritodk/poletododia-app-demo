import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/request/request.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:http/http.dart' as http;
import 'package:untitled/data/model/response/user_model.dart';

import '../../util/app_constants.dart';
import '../model/response/error_response.dart';
import '../repository/community_repo.dart';
 

class ApiClient extends GetxService {
  final String appBaseUrl;
  final String tokenApi;
  User? user;
  final SharedPreferences sharedPreferences;
  static final String noInternetMessage = 'connection_to_api_server_failed'.tr;
  final int timeoutInSeconds = 120;

  String? token;
  Map<String, String>? _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences, required this.tokenApi, this.user}) {
    token = sharedPreferences.getString(AppConstants.TOKEN);

    if (kDebugMode) {
      print('Token: $token');
    }

    updateHeader(
        token, sharedPreferences.getString(AppConstants.LANGUAGE_CODE), user
    );
  }

  void updateHeader(String? token, String? languageCode, User? user) {
    this.user = user;
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      AppConstants.LOCALIZATION_KEY: languageCode ?? AppConstants.languages[0].languageCode!,
      'token': token ?? '',
      'userId': user == null ? '' : user.id.toString()
    };
  }

  Future<Response?> getData(String uri, {bool isUseWpRoute = false}) async {
    try {
      if (kDebugMode) {
        print('====> API Call: $uri\nurl: ${appBaseUrl+uri}\nHeader: $_mainHeaders');
      }
      http.Response response = await http.get(
        Uri.parse(appBaseUrl+uri),
        headers: _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      if (kDebugMode) {
        print('------------${e.toString()}');
      }
      return null;
    }
  }

  Future<Response?> deleteData(String uri, {bool isUseWpRoute = false}) async {
    try {


      if(foundation.kDebugMode) {
        print('====> API Call: $uri\nHeader: $_mainHeaders');
      }

      var url = '';
      if(isUseWpRoute){
        url = AppConstants.BASE_URL_WP;
      }else{
        url = AppConstants.BASE_URL;
      }
      Map<String, String>? headers = {};
      if(isUseWpRoute){
        headers.addAll(_mainHeaders!);
        headers['Authorization'] = 'Bearer $token';
      }else{
        headers = _mainHeaders;
      }

      http.Response response = await http.delete(
        Uri.parse(url+uri),
        headers: headers,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return null;
    }
  }

  Future<Response?> postData(String uri, dynamic body, {bool isUseWpRoute = false}) async {
    try {
      var url = '';
      if(isUseWpRoute){
        url = AppConstants.BASE_URL_WP;
      }else{
        url = AppConstants.BASE_URL;
      }
      if (kDebugMode) {
        print('====> API Call: $uri\nurl: ${url+uri}\nHeader: $_mainHeaders');
        print('====> API Body: $body');
      }

      Map<String, String>? headers = {};
      if(isUseWpRoute){
        headers.addAll(_mainHeaders!);
        headers['Authorization'] = 'Bearer $token';
      }else{
        headers = _mainHeaders;
      }

      http.Response response = await http.post(
        Uri.parse(url+uri),
        body: jsonEncode(body),
        headers: headers,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return null;
    }
  }

  Future<Response?> postMultipartData(String uri, Map<String, String> body, MultipartBody multipartBody, {bool isUseWpRoute = false}) async {
    try {
      var url = '';
      if(isUseWpRoute){
        url = AppConstants.BASE_URL_WP;
      }else{
        url = AppConstants.BASE_URL;
      }

      Map<String, String>? headers = {};
      if(isUseWpRoute){
        headers.addAll(_mainHeaders!);
        headers['Authorization'] = 'Bearer $token';
        headers['Accept'] = 'application/json';
        headers['Content-Type'] = 'multipart/form-data';
      }else{
        headers = _mainHeaders;
      }
      if (kDebugMode) {
        print('====> API Call: $uri\nHeader: $headers');
        print('====> API Body: $body with ${multipartBody.file.name} picture');
      }
      http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url+uri));
      request.headers.addAll(headers!);
      Uint8List _list = await multipartBody.file.readAsBytes();
      request.files.add(http.MultipartFile(
        multipartBody.key, multipartBody.file.readAsBytes().asStream(), _list.length,
        filename: '${DateTime.now().toString()}.png',
      ));
      request.fields.addAll(body);
      http.Response response = await http.Response.fromStream(await request.send());
      return handleResponse(response, url+uri);
    } catch (e) {
      print(e.toString());
      return null;//Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response?> putData(String uri, dynamic body, {Map<String, String>? headers}) async {
    try {
      if(kDebugMode) {
        print('====> API Call: $uri\nHeader: $_mainHeaders');
        print('====> API Body: $body');
      }
      http.Response response = await http.put(
        Uri.parse(appBaseUrl+uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return null;
    }
  }

  Response? handleResponse(http.Response response, String uri) {
    dynamic _body;
    try {
      _body = jsonDecode(response.body);
    }catch(e) {}
    Response? _response = Response(
      body: _body ?? response.body, bodyString: response.body.toString(),
      request: Request(headers: response.request!.headers, method: response.request!.method, url: response.request!.url),
      headers: response.headers, statusCode: response.statusCode, statusText: response.reasonPhrase,
    );
    if(_response.statusCode != 200 && _response.body != null && _response.body is !String) {
      var data = _response.body;
      if(data['errors'] is String){
        _response = Response(statusCode: _response.statusCode, body: _response.body, statusText: data['errors']);
      }else{
        ErrorResponse _errorResponse = ErrorResponse.fromJson(_response.body);
        if(_response.body['error'] != null && _response.body['error'] is String){
          _response = Response(statusCode: _response.statusCode, body: _response.body, statusText: _response.body['error']);
        }else{
          if(_response.body.toString().startsWith('{errors: [{code:')) {
            _response = Response(statusCode: _response.statusCode, body: _response.body, statusText: _errorResponse.errors![0].message);
          }else if(_response.body.toString().startsWith('{message')) {
            _response = Response(statusCode: _response.statusCode, body: _response.body, statusText: _response.body['message']);
          }
        }
      }

    }else if(_response.statusCode != 200 && _response.body == null) {
      _response = null;
    }
    if(foundation.kDebugMode) {
      print('====> API Response: [${_response!.statusCode}] $uri\n${_response.body}');
    }
    return _response;
  }
}