import 'dart:convert';

import 'package:ecommerceversiontwo/Pages/core/model/BrandsModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CategoriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CitiesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CountriesModel.dart';
import 'package:http/http.dart' as http;

class DealsModel {
  int? idDeal;
  String? title;
  String? description;
  String? details;
  int? price;
  int? discount;
  int? quantity;
  int? idPricesDelevery;
  String? datePublication;
  String? dateEND;
  String? imagePrinciple;
  String? videoName;
  int? idCateg;
  CategoriesModel? categories;
  int? idUser;
  //Null? user;
  int? idCountrys;
  CountriesModel? countries;
  int? idCity;
  CitiesModel? cities;
  int? idBrand;
  BrandsModel? brands;
  int? idPrize;
  String? locations;
  int? idBoost;
  int? active;
  int? likeId;
  int? nbLike;

  DealsModel(
      {this.idDeal,
        this.title,
        this.description,
        this.details,
        this.price,
        this.discount,
        this.quantity,
        this.idPricesDelevery,
        this.datePublication,
        this.dateEND,
        this.imagePrinciple,
        this.videoName,
        this.idCateg,
        this.categories,
        this.idUser,
        //this.user,
        this.idCountrys,
        this.countries,
        this.idCity,
        this.cities,
        this.idBrand,
        this.brands,
        this.idPrize,
        this.locations,
        this.idBoost,
        this.active,
        this.likeId,
        this.nbLike
      });

  DealsModel.fromJson(Map<String, dynamic> json) {
    idDeal = json['idDeal'];
    title = json['title'];
    description = json['description'];
    details = json['details'];
    price = json['price'];
    discount = json['discount'];
    quantity = json['quantity'];
    if(json['idPricesDelevery']!=null)
    idPricesDelevery = json['idPricesDelevery'];

    datePublication = json['datePublication'];
    dateEND = json['dateEND'];
    imagePrinciple = json['imagePrinciple'];
    if(json['videoName']!=null)
    videoName = json['videoName'];
    idCateg = json['idCateg'];
    categories = json['categories'] != null
        ? new CategoriesModel.fromJson(json['categories'])
        : null;
    idUser = json['idUser'];
    //user = json['user'];
    idCountrys = json['idCountrys'];
    countries = json['countries'] != null
        ? new CountriesModel.fromJson(json['countries'])
        : null;
    idCity = json['idCity'];
    cities =
    json['cities'] != null ? new CitiesModel.fromJson(json['cities']) : null;
    idBrand = json['idBrand'];
    brands =
    json['brands'] != null ? new BrandsModel.fromJson(json['brands']) : null;
    idPrize = json['idPrize'];
    locations = json['locations'];
    idBoost = json['idBoost'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idDeal'] = this.idDeal;
    data['title'] = this.title;
    data['description'] = this.description;
    data['details'] = this.details;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['quantity'] = this.quantity;
    data['idPricesDelevery'] = this.idPricesDelevery;
    data['datePublication'] = this.datePublication;
    data['dateEND'] = this.dateEND;
    data['imagePrinciple'] = this.imagePrinciple;
    data['videoName'] = this.videoName;
    data['idCateg'] = this.idCateg;
    if (this.categories != null) {
      data['categories'] = this.categories!.toJson();
    }
    data['idUser'] = this.idUser;
    //data['user'] = this.user;
    data['idCountrys'] = this.idCountrys;
    if (this.countries != null) {
      data['countries'] = this.countries!.toJson();
    }
    data['idCity'] = this.idCity;
    if (this.cities != null) {
      data['cities'] = this.cities!.toJson();
    }
    data['idBrand'] = this.idBrand;
    if (this.brands != null) {
      data['brands'] = this.brands!.toJson();
    }
    data['idPrize'] = this.idPrize;
    data['locations'] = this.locations;
    data['idBoost'] = this.idBoost;
    data['active'] = this.active;
    return data;
  }




}