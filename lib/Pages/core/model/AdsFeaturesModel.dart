import 'package:ecommerceversiontwo/Pages/core/model/FeaturesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/FeaturesValuesModel.dart';

class AdsFeature {
  int? idAF;
  int? idAds;
  int? idDeals;
  int? idProduct;
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
        this.idProduct,
      this.idFeature,
      this.idFeaturesValues,
      this.featuresValues,
      this.myValues,
      this.active});

  AdsFeature.fromJson(Map<String, dynamic> json) {
    idAF = json['idAF'];
    idAds = json['idAds'];
    idDeals = json['idDeals'];
    idProduct = json['idProduct'];
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
    data['idProduct'] = this.idProduct;
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
  int? idProduct;
  int? idFeature;
  int? idFeaturesValues;
  String? myValues;
  int? active;

  CreateAdsFeature(
      {this.idAds,
      this.idDeals,
        this.idProduct,
      this.idFeature,
      this.idFeaturesValues,
      this.myValues,
      this.active});

  CreateAdsFeature.fromJson(Map<String, dynamic> json) {
    idAds = json['idAds'];
    idDeals = json['idDeals'];
    idFeature = json['idFeature'];
    idProduct = json['idProduct'];
    idFeaturesValues = json['idFeaturesValues'];
    myValues = json['myValues'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    return {
      'IdAds': idAds,
      'IdDeals': idDeals,
      'IdFeature': idFeature,
    'idProduct' : idProduct,

    'IdFeaturesValues': idFeaturesValues,
      'MyValues': myValues,
      'Active': active,
    };
  }
}
