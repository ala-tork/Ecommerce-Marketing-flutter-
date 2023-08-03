
import 'package:ecommerceversiontwo/Pages/core/model/CategoriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CitiesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CountriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/CreateAnnounceModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


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
  int? iduser;
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
        this.iduser,
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
    iduser= json['idUser'];
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
/*
  Future<bool> deleteData(int id) async {
    final String apiUrl = "https://10.0.2.2:7058/api/Ads?id=$id";

    try {
      final response = await http.delete(Uri.parse(apiUrl),);

      if (response.statusCode == 200) {

        return true;
      } else {
        print("Failed to delete Ads. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error deleting item: $e");
      return false;
    }
  }*/



}



