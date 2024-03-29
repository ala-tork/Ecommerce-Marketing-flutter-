import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsFeaturesModel.dart';
import  'package:http/http.dart' as http;
import 'dart:convert';

class AdsFeaturesService{

  Future<void> Createfeature (CreateAdsFeature adModel) async {
    print(adModel.toJson());
    final apiUrl = '${ApiPaths().CreateAdsFeatureUrl}';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(adModel.toJson()),
      );

      if (response.statusCode == 200) {
        print('Features created successfully!');
      } else {
        print('Failed to create Features: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating Features : $e');
    }
  }



  /** Ads Function */
//get all Ads Features by user
  Future<List<AdsFeature>> GetAdsFeaturesByIdAds(int iduser) async {
    http.Response response;
    response = await http
        .get(Uri.parse("${ApiPaths().GetAdsFeaturesByIdAdsUrl}$iduser"));

    if (response.statusCode == 200) {
      var responseBody = response.body;
      List<AdsFeature> aflist=(jsonDecode(responseBody) as List)
          .map((json) => AdsFeature.fromJson(json))
          .toList();

      return aflist;
    } else {
      print(response.body);
      throw Exception('Failed to fetch AdsFeatures By Id Ads');
    }
  }





  Future<bool> deleteData(int id) async {
    final String apiUrl = "${ApiPaths().DeleteAdsFeatureUrl}$id";

    try {
      final response = await http.delete(Uri.parse(apiUrl),);

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to delete Ads Featues. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error deleting item: $e");
      return false;
    }
  }

  /** deals functions */

  //get all Deals Features by id Deals
  Future<List<AdsFeature>> GetDealsFeaturesByIdDeals(int idDeals) async {
    http.Response response;
    response = await http
        .get(Uri.parse("${ApiPaths().GetDealsFeaturesUrl}$idDeals"));

    if (response.statusCode == 200) {
      var responseBody = response.body;
      List<AdsFeature> aflist=(jsonDecode(responseBody) as List)
          .map((json) => AdsFeature.fromJson(json))
          .toList();

      return aflist;
    } else {
      print(response.body);
      throw Exception('Failed to fetch AdsFeatures By Id Deals');
    }
  }
  Future<bool> deleteDeals(int id) async {
    final String apiUrl = "${ApiPaths().DeleteDealsFeaturesUrl}$id";
    try {
      final response = await http.delete(Uri.parse(apiUrl));

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to delete Deals Features. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error deleting item: $e");
      return false;
    }

  }

  /** Product functions */

  //get all Product Features by id Deals
  Future<List<AdsFeature>> GetProductFeaturesByIdDeals(int idProduct) async {
    http.Response response;
    response = await http
        .get(Uri.parse("${ApiPaths().getProductFeaturesUrl}$idProduct"));

    if (response.statusCode == 200) {
      var responseBody = response.body;
      List<AdsFeature> aflist=(jsonDecode(responseBody) as List)
          .map((json) => AdsFeature.fromJson(json))
          .toList();

      return aflist;
    } else {
      print(response.body);
      throw Exception('Failed to fetch AdsFeatures By Id Product');
    }
  }
  Future<bool> deletePeoductAdsFeatures(int id) async {
    final String apiUrl = "${ApiPaths().DeleteProductAdsFeatureUrl}$id";
    try {
      final response = await http.delete(Uri.parse(apiUrl));

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to delete Product Ads Features. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error deleting item: $e");
      return false;
    }

  }


}