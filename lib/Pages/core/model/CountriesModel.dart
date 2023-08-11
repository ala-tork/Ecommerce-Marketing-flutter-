import  'package:http/http.dart' as http;
import 'dart:convert';

class CountriesModel {
  int? idCountrys;
  String? title;
  String? flag;
  String? code;
  String? phoneCode;
  int? active;

  CountriesModel(
      {this.idCountrys,
        this.title,
        this.flag,
        this.code,
        this.phoneCode,
        this.active});

  CountriesModel.fromJson(Map<String, dynamic> json) {
    idCountrys = json['idCountrys'];
    title = json['title'];
    flag = json['flag'];
    code = json['code'];
    phoneCode = json['phoneCode'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idCountrys'] = this.idCountrys;
    data['title'] = this.title;
    data['flag'] = this.flag;
    data['code'] = this.code;
    data['phoneCode'] = this.phoneCode;
    data['active'] = this.active;
    return data;
  }

// get data from api
/*
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
  }*/
}