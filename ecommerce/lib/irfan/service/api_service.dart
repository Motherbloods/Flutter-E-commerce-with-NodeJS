import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecommerce/irfan/config.dart';
import 'package:ecommerce/irfan/models/login_request_model.dart';
import 'package:ecommerce/irfan/models/login_response_model.dart';
import 'package:ecommerce/irfan/models/register_request_model.dart';
import 'package:ecommerce/irfan/models/register_response_model.dart';
import 'package:ecommerce/irfan/service/shared_service.dart';

class ApiService {
  static var client = http.Client();

  static Future<bool> login(LoginRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiURL, Config.loginAPI);

    try {
      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200) {
        //SHARED
        await SharedService.setLoginDetails(loginResponseJson(response.body));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<RegisterResponseModel> register(
    RegisterRequestModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiURL, Config.registerAPI);

    try {
      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return registerResponseModel(response.body);
      } else {
        throw Exception("Failed to register");
      }
    } catch (e) {
      print(e.toString());
      throw Exception("Failed to register");
    }
  }

  static Future<String?> getUserProfile() async {
    var loginDetails = await SharedService.loginDetails();

    if (loginDetails == null || loginDetails.data == null) {
      return null;
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.data.token}',
    };

    var url = Uri.http(Config.apiURL, Config.userProfileAPI);

    try {
      var response = await client.get(
        url,
        headers: requestHeaders,
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
