import 'package:ecommerceversiontwo/Pages/core/model/FeaturesValuesModel.dart';
import  'package:http/http.dart' as http;
import 'dart:convert';

class FeaturesValuesService{
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