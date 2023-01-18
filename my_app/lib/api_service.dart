import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:my_app/constants.dart';
import 'package:my_app/json.dart';

class ApiService {
  Future<Fact?> getFact() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.testEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        print('200 status code');
        print(response.body);
        Welcome fact = welcomeFromJson(response.body);
        print('factory');
        print(fact.fact?.fragment);
        return fact.fact;
      }
      print('not 200 status code');
    } catch (e) {
      log(e.toString());
    }

    return null;
  }
}