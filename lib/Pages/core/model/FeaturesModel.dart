import 'package:ecommerceversiontwo/Pages/core/model/AdsFeaturesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/FeaturesValuesModel.dart';
import  'package:http/http.dart' as http;
import 'dart:convert';

class FeaturesModel {
  int? idF;
  String? title;
  String? description;
  String? unit;
  int? active;
  int? idCategory;
  bool? selected=false;
  List<FeaturesValuesModel>?  valuesList=[];
  int? value;

  FeaturesModel(
      {this.idF,
        this.title,
        this.description,
        this.unit,
        this.active,
        this.idCategory,
        this.selected=false,
        this.valuesList,
        this.value,
        });

  FeaturesModel.fromJson(Map<String, dynamic> json) {
    idF = json['idF'];
    title = json['title'];
    description = json['description'];
    unit = json['unit'];
    active = json['active'];
    idCategory = json['idCategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idF'] = this.idF;
    data['title'] = this.title;
    data['description'] = this.description;
    data['unit'] = this.unit;
    data['active'] = this.active;
    data['idCategory'] = this.idCategory;
    return data;
  }


// get Feature data by Category id
  Future<List<FeaturesModel>> GetData(int CategoryId) async {
    http.Response response,Adsfeatures;
    response = await http.get(Uri.parse("https://10.0.2.2:7058/api/FeaturesControler/GetFeatureByCategory?idcateg=$CategoryId"));
    if (response.statusCode == 200) {
      List<FeaturesModel> featuresList = (jsonDecode(response.body) as List)
          .map((json) => FeaturesModel.fromJson(json))
          .toList();
     // print(response.body);
      return featuresList;
    } else {
      print(response.body);
      throw Exception('Failed to fetch Features');
    }
  }
}