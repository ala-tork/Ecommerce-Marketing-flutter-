import 'package:ecommerceversiontwo/Pages/core/model/CountriesModel.dart';
import  'package:http/http.dart' as http;
import 'dart:convert';

class CountrySerice{

  Future<List<CountriesModel>> GetData() async {
    http.Response response;
    response = await http.get(Uri.parse("https://10.0.2.2:7058/api/CountryControler/Countrys"));
    if (response.statusCode == 200) {
      var responseBody = response.body;
      List<CountriesModel> countries=(jsonDecode(responseBody) as List)
          .map((json) => CountriesModel.fromJson(json))
          .toList();
      return countries;
    } else {
      print(response.body);
      throw Exception('Failed to fetch data');
    }
  }
}