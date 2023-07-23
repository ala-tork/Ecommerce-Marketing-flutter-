import 'dart:io';

import  'package:http/http.dart' as http;
import 'dart:convert';

class AdsFeature {
  int? idAds;
  int? idDeals;
  int? idFeature;
  int? idFeaturesValues;
  String? myValues;
  int? active;

  AdsFeature(
      {this.idAds,
        this.idDeals,
        this.idFeature,
        this.idFeaturesValues,
        this.myValues,
        this.active});

  AdsFeature.fromJson(Map<String, dynamic> json) {
    idAds = json['idAds'];
    idDeals = json['idDeals'];
    idFeature = json['idFeature'];
    idFeaturesValues = json['idFeaturesValues'];
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


  Future<void> Createadsfeature (CreateAdsFeature adModel) async {

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
        // Success, you can handle the response here if needed.
        print('AdsFeature created successfully!');
      } else {
        // Error, handle the error response here if needed.
        print('Failed to create AdsFeature: ${response.statusCode}');
      }
    } catch (e) {
      // Exception occurred during the request.
      print('Error creating AdsFeature: $e');
    }
  }
}