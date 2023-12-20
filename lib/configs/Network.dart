import 'dart:convert' as convert;
import 'dart:convert';
import 'package:free_indeed/Managers/TokenManager.dart';
import 'package:http/http.dart' as http;

class Network {
  TokenManager tokenManager = TokenManager();

  Future<Map<String, dynamic>?> getDataPostMethod(String url, Object body,
      {String? token}) async {
    try {
      String accessToken = "";
      if (token != null) {
        accessToken = await tokenManager.getCurrentToken();
      }
      // print(url);
      // print(body);

      var bodyFinal = json.encode(body);
      final response = await http.post(
        Uri.parse(url),
        body: bodyFinal,
        headers: token != null
            ? {
                "Authorization": accessToken.toString(),
                "Content-Type": "application/json"
              }
            : {"Content-Type": "application/json"},
        encoding: convert.Encoding.getByName("utf-8"),
      );
      print(response.body);
      if (response.statusCode == 200) {
        print(response.body);
        return json.decode(response.body);
      } else {
        throw Exception('');
      }
    } catch (e) {
      print(e);
      print("Failed to load Data");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getDataGetMethod(String url,
      {String? token}) async {
    print(url);
    try {
      String accessToken = "";
      if (token != null) {
        accessToken = await tokenManager.getCurrentToken();
      }
      // print(url);
      // print(token);
      final response = await http.get(
        Uri.parse(url),
        headers: token != null
            ? {
                "Authorization": accessToken.toString(),
                "Content-Type": "application/json"
              }
            : {"Content-Type": "application/json"},
      );
      print(response.body);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('');
      }
    } catch (e) {
      print("Failed to load Data");
      return null;
    }
  }

  Future<Map<String, dynamic>?> editDataPutMethod(String url, Object body,
      {String? token}) async {
    try {
      String accessToken = "";
      if (token != null) {
        accessToken = await tokenManager.getCurrentToken();
      }
      // print(url);
      // print(body);
      var bodyFinal = json.encode(body);
      final response = await http.put(
        Uri.parse(url),
        body: bodyFinal,
        headers: token != null
            ? {
                "Authorization": accessToken.toString(),
                "Content-Type": "application/json"
              }
            : {"Content-Type": "application/json"},
        encoding: convert.Encoding.getByName("utf-8"),
      );
      print(response.body);
      if (response.statusCode == 200) {
        // print(response.body);
        return json.decode(response.body);
      } else {
        throw Exception('');
      }
    } catch (e) {
      print(e);
      print("Failed to load Data");
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteDataDeleteMethod(String url, Object body,
      {String? token}) async {
    try {
      String accessToken = "";
      if (token != null) {
        accessToken = await tokenManager.getCurrentToken();
      }
      // print(url);
      // print(body);
      var bodyFinal = json.encode(body);
      final response = await http.delete(
        Uri.parse(url),
        body: bodyFinal,
        headers: token != null
            ? {
                "Authorization": accessToken.toString(),
                "Content-Type": "application/json"
              }
            : {"Content-Type": "application/json"},
        encoding: convert.Encoding.getByName("utf-8"),
      );
      print(response.body);
      if (response.statusCode == 200) {
        // print(response.body);
        return json.decode(response.body);
      } else {
        throw Exception('');
      }
    } catch (e) {
      print(e);
      print("Failed to load Data");
      return null;
    }
  }
}
