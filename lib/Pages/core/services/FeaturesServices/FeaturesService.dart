import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/core/model/FeaturesModel.dart';
import  'package:http/http.dart' as http;
import 'dart:convert';

class FeaturesService {
  // get Feature data by Category id
  Future<List<FeaturesModel>> GetData(int CategoryId) async {
    http.Response response,Adsfeatures;
    //response = await http.get(Uri.parse("https://10.0.2.2:7058/api/FeaturesControler/GetFeatureByCategory?idcateg=$CategoryId"));
    response = await http.get(Uri.parse("${ApiPaths().GetFeaturesByCategoryIdUrl}$CategoryId"));
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