import 'package:ecommerceversiontwo/Pages/core/model/CountriesModel.dart';

class Cities {
  int? idCity;
  String? title;
  int? idCountry;
  Countries? countries;

  Cities({this.idCity, this.title, this.idCountry, this.countries});

  Cities.fromJson(Map<String, dynamic> json) {
    idCity = json['idCity'];
    title = json['title'];
    idCountry = json['idCountry'];
    countries = json['countries'] != null
        ? new Countries.fromJson(json['countries'])
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