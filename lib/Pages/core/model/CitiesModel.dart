import 'package:ecommerceversiontwo/Pages/core/model/CountriesModel.dart';


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

}