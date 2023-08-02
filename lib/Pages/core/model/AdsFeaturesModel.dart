import 'dart:io';

import 'package:ecommerceversiontwo/Pages/core/model/FeaturesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/FeaturesValuesModel.dart';
import  'package:http/http.dart' as http;
import 'dart:convert';

class AdsFeature {
  int? idAF;
  int? idAds;
  int? idDeals;
  int? idFeature;
  FeaturesModel? features;
  int? idFeaturesValues;
  FeaturesValuesModel? featuresValues;
  String? myValues;
  int? active;

  AdsFeature(
      {this.idAF,
        this.idAds,
        this.idDeals,
        this.idFeature,
        this.idFeaturesValues,
        this.featuresValues,
        this.myValues,
        this.active});

  AdsFeature.fromJson(Map<String, dynamic> json) {
    idAF = json['idAF'];
    idAds = json['idAds'];
    idDeals = json['idDeals'];
    idFeature = json['idFeature'];
    features = json['features'] != null
        ? new FeaturesModel.fromJson(json['features'])
        : null;
    idFeaturesValues = json['idFeaturesValues'];
    featuresValues = json['featuresValues'] != null
        ? new FeaturesValuesModel.fromJson(json['featuresValues'])
        : null;
    myValues = json['myValues'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idAds'] = this.idAds;
    data['idDeals'] = this.idDeals;
    data['idFeature'] = this.idFeature;
    data['idFeaturesValues'] = this.idFeaturesValues;
    data['myValues'] = this.myValues;
    data['active'] = this.active;
    return data;
  }
  /*
  /** Ads Function */
//get all Ads Features by user
  Future<List<AdsFeature>> GetAdsFeaturesByIdAds(int iduser) async {
    http.Response response;
    response = await http
        .get(Uri.parse("https://10.0.2.2:7058/api/AdsFeatureControler?idAds=$iduser"));

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
    final String apiUrl = "https://10.0.2.2:7058/api/AdsFeatureControler?idAds=$id";

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
        .get(Uri.parse("https://10.0.2.2:7058/api/AdsFeatureControler/GetDealsFeatures?idDeals=$idDeals"));

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
  Future<bool> deleteDeals(int id) async {
    final String apiUrl = "https://10.0.2.2:7058/api/AdsFeatureControler/DeleteDealstFeatures?idDeals=$id";

    try {
      final response = await http.delete(Uri.parse(apiUrl),);

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to delete Deals Featues. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error deleting item: $e");
      return false;
    }
  }*/
}



// Create ads
class CreateAdsFeature {
  int? idAds;
  int? idDeals;
  int? idFeature;
  int? idFeaturesValues;
  String? myValues;
  int? active;

  CreateAdsFeature(
      {this.idAds,
        this.idDeals,
        this.idFeature,
        this.idFeaturesValues,
        this.myValues,
        this.active});

  CreateAdsFeature.fromJson(Map<String, dynamic> json) {
    idAds = json['idAds'];
    idDeals = json['idDeals'];
    idFeature = json['idFeature'];
    idFeaturesValues = json['idFeaturesValues'];
    myValues = json['myValues'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    return {
      'IdAds': idAds,
      'IdDeals': idDeals,
      'IdFeature': idFeature,
      'IdFeaturesValues': idFeaturesValues,
      'MyValues': myValues,
      'Active': active,
    };
  }

/*
  Future<void> Createfeature (CreateAdsFeature adModel) async {

    final apiUrl = 'https://10.0.2.2:7058/api/AdsFeatureControler';

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
  }*/




}