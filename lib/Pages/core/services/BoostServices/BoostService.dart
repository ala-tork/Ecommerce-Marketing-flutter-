import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ecommerceversiontwo/Pages/core/model/BoostModules/Boost.dart';

class BoostService{

  Future<List<Boost>> GetAllBoosts() async {
    final String apiUrl = "https://10.0.2.2:7058/api/Boost";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        if (response.body != null) {
          List<dynamic> jsonResponse = json.decode(response.body);
          List<Boost> Boosts = jsonResponse.map((item) => Boost.fromJson(item)).toList();
          return Boosts;
        } else {
          return [];
        }
      } else {
        throw Exception("Failed to fetch Boosts. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error Fetching Boosts: $e");
      throw Exception("Error fetching Boosts: $e");
    }
  }
}