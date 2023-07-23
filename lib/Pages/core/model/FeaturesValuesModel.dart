import 'package:ecommerceversiontwo/Pages/core/model/FeaturesModel.dart';
import  'package:http/http.dart' as http;
import 'dart:convert';

class FeaturesValuesModel {
  int? idFv;
  String? title;
  int? active;
  int? idF;
  bool? selected=false;
  //FeaturesModel? features;

  FeaturesValuesModel(
      {this.idFv, this.title, this.active, this.idF,this.selected /*this.features*/});

  FeaturesValuesModel.fromJson(Map<String, dynamic> json) {
    idFv = json['idFv'];
    title = json['title'];
    active = json['active'];
    idF = json['idF'];
   /* features = json['features'] != null
        ? new FeaturesModel.fromJson(json['features'])
        : null;*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idFv'] = this.idFv;
    data['title'] = this.title;
    data['active'] = this.active;
    data['idF'] = this.idF;
   /* if (this.features != null) {
      data['features'] = this.features!.toJson();
    }*/
    return data;
  }

  // get FeatureValues data by Feature
  Future<List<FeaturesValuesModel>> GetData(int FeatureId) async {
    http.Response response;
    response = await http.get(Uri.parse("https://10.0.2.2:7058/api/FeatureValuesControler/GetFeatureValuesByFeature?idf=$FeatureId"));
    if (response.statusCode == 200) {
      List<FeaturesValuesModel> featuresvaluesList = (jsonDecode(response.body) as List)
          .map((json) => FeaturesValuesModel.fromJson(json))
          .toList();
      //print(response.body);
      return featuresvaluesList;
    } else {
      print(response.body);
      throw Exception('Failed to fetch Features Values');
    }
  }

}