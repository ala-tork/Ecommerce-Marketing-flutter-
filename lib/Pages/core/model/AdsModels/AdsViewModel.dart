import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AdsFilterModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CategoriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CountriesModel.dart';
import '../CitiesModel.dart';
import  'package:http/http.dart' as http;
import 'dart:convert';


class AdsView {
  int? idAds;
  String? title;
  String? description;
  String? details;
  int? price;
  String? datePublication;
  String? imagePrinciple;
  String? videoName;
  int? idCateg;
  CategoriesModel? categories;
  int? idUser;
  Null? user;
  int? idCountrys;
  CountriesModel? countries;
  int? idCity;
  CitiesModel? cities;
  String? locations;
  int? idBoost;
  int? active;
  int? idWishList;
  int? nbLike;
  int? idLike;

  AdsView(
      {this.idAds,
        this.title,
        this.description,
        this.details,
        this.price,
        this.datePublication,
        this.imagePrinciple,
        this.videoName,
        this.idCateg,
        this.categories,
        this.idUser,
        this.user,
        this.idCountrys,
        this.countries,
        this.idCity,
        this.cities,
        this.locations,
        this.idBoost,
        this.active,
        this.idWishList,
        this.nbLike,
        this.idLike});

  AdsView.fromJson(Map<String, dynamic> json) {
    idAds = json['idAds'];
    title = json['title'];
    description = json['description'];
    details = json['details'];
    price = json['price'];
    datePublication = json['datePublication'];
    imagePrinciple = json['imagePrinciple'];
    videoName = json['videoName'];
    idCateg = json['idCateg'];
    categories = json['categories'] != null
        ? new CategoriesModel.fromJson(json['categories'])
        : null;
    idUser = json['idUser'];
    //user = json['user'] != null ? new User.fromJson(json['user']) : null;
    idCountrys = json['idCountrys'];
    countries = json['countries'] != null
        ? new CountriesModel.fromJson(json['countries'])
        : null;
    idCity = json['idCity'];
    cities =
    json['cities'] != null ? new CitiesModel.fromJson(json['cities']) : null;
    locations = json['locations'];
    idBoost = json['idBoost'];
    active = json['active'];
    idWishList = json['idWishList'];
    nbLike = json['nbLike'];
    idLike = json['idLike'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idAds'] = this.idAds;
    data['title'] = this.title;
    data['description'] = this.description;
    data['details'] = this.details;
    data['price'] = this.price;
    data['datePublication'] = this.datePublication;
    data['imagePrinciple'] = this.imagePrinciple;
    data['videoName'] = this.videoName;
    data['idCateg'] = this.idCateg;
    if (this.categories != null) {
      data['categories'] = this.categories!.toJson();
    }
    data['idUser'] = this.idUser;
 /*   if (this.user != null) {
      data['user'] = this.user!.toJson();
    }*/
    data['idCountrys'] = this.idCountrys;
    if (this.countries != null) {
      data['countries'] = this.countries!.toJson();
    }
    data['idCity'] = this.idCity;
    if (this.cities != null) {
      data['cities'] = this.cities!.toJson();
    }
    data['locations'] = this.locations;
    data['idBoost'] = this.idBoost;
    data['active'] = this.active;
    data['idWishList'] = this.idWishList;
    data['nbLike'] = this.nbLike;
    data['idLike'] = this.idLike;
    return data;
  }


}