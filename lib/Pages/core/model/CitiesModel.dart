import 'package:ecommerceversiontwo/Pages/core/model/CountriesModel.dart';
import  'package:http/http.dart' as http;
import 'dart:convert';

class CitiesModel {
  int? idCity;
  String? title;
  int? idCountry;
  CountriesModel? countries;

  CitiesModel({this.idCity, this.title, this.idCountry, this.countries});

  CitiesModel.fromJson(Map<String, dynamic> json) {
    idCity = json['idCity'];
    title = json['title'];
    idCountry = json['idCountry'];
    countries = json['countries'] != null
        ? new CountriesModel.fromJson(json['countries'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idCity'] = this.idCity;
    data['title'] = this.title;
    data['idCountry'] = this.idCountry;
    if (this.countries != null) {
      data['countries'] = this.countries?.toJson();
    }
    return data;
  }

// get cities data by country id
  Future<List<CitiesModel>> GetData(int countryId) async {
    http.Response response;
    response = await http.get(Uri.parse("https://10.0.2.2:7058/api/CitiesControler/$countryId"));
    if (response.statusCode == 200) {
      List<CitiesModel> citiesList = (jsonDecode(response.body) as List)
          .map((json) => CitiesModel.fromJson(json))
          .toList();
      //print(response.body);
      return citiesList;
    } else {
      print(response.body);
      throw Exception('Failed to fetch Cities');
    }
  }
}