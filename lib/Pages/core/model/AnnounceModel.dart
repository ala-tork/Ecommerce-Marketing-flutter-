
import 'package:ecommerceversiontwo/Pages/core/model/CategoryModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CitiesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CountriesModel.dart';



class AnnounceModel {
  int? idAds;
  String? title;
  String? description;
  String? details;
  int? price;
  String? imagePrinciple;
  String? videoName;
  int? idCateg;
  CategoriesModel? categories;
  int? idCountrys;
  CountriesModel? countries;
  int? idCity;
  CitiesModel? cities;
  String? locations;
  int? active;
  bool? like;

  AnnounceModel(
      {this.idAds,
        this.title,
        this.description,
        this.details,
        this.price,
        this.imagePrinciple,
        this.videoName,
        this.idCateg,
        this.categories,
        this.idCountrys,
        this.countries,
        this.idCity,
        this.cities,
        this.locations,
        this.active,
        this.like
      });

  AnnounceModel.fromJson(Map<String, dynamic> json) {
    idAds = json['idAds'];
    title = json['title'];
    description = json['description'];
    details = json['details'];
    price = json['price'];
    imagePrinciple = json['imagePrinciple'];
    videoName = json['videoName'];
    idCateg = json['idCateg'];
    categories = json['categories'] != null
        ? new CategoriesModel.fromJson(json['categories'])
        : null;
    idCountrys = json['idCountrys'];
    countries = json['countries'] != null
        ? new CountriesModel.fromJson(json['countries'])
        : null;
    idCity = json['idCity'];
    cities =
    json['cities'] != null ? new CitiesModel.fromJson(json['cities']) : null;
    locations = json['locations'];
    active = json['active'];
    like=false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idAds'] = this.idAds;
    data['title'] = this.title;
    data['description'] = this.description;
    data['details'] = this.details;
    data['price'] = this.price;
    data['imagePrinciple'] = this.imagePrinciple;
    data['videoName'] = this.videoName;
    data['idCateg'] = this.idCateg;
    if (this.categories != null) {
      data['categories'] = this.categories?.toJson();
    }
    data['idCountrys'] = this.idCountrys;
    if (this.countries != null) {
      data['countries'] = this.countries?.toJson();
    }
    data['idCity'] = this.idCity;
    if (this.cities != null) {
      data['cities'] = this.cities?.toJson();
    }
    data['locations'] = this.locations;
    data['active'] = this.active;
    return data;
  }
}



/*class AnnounceModel{
  int? id;
  String? title;
  String? description;
  String? details;
  double? price;
  String? images;
  String? videoName;
  bool? boosted;
  DateTime? datepub;
  int? idCategorei;
  int?  iduser;
  int? idpays;
  int? idcity;
  int? Active;
  String? Location;
  bool? like;

  AnnounceModel({
    this.id,
    this.title,
    this.description,
    this.details,
    this.price,
    this.images,
    this.boosted,
    this.datepub,
    this.idCategorei,
    this.iduser,
    this.idpays,
    this.idcity,
    this.Active,
    this.like,
    this.Location,
  });

  AnnounceModel.fromJson(Map<String, dynamic> json) {
    id = json['idAds'];
    title = json['title'];
    description = json['description'];
    details = json['details'];
    price = json['price'].toDouble();
    images = json['imagePrinciple'];
    videoName = json['videoName'];
    idCategorei = json['idCateg'];
    idpays = json['idCountrys'];
    idcity = json['idCity'];
    Location = json['locations'];
    Active = json['active'];
    like=false;
    boosted=false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idAds'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['details'] = this.details;
    data['price'] = this.price;
    data['imagePrinciple'] = this.images;
    data['videoName'] = this.videoName;
    data['idCateg'] = this.idCategorei;
    data['idCountrys'] = this.idpays;
    data['idCity'] = this.idcity;
    data['locations'] = this.Location;
    data['active'] = this.Active;
    return data;
  }

}*/
