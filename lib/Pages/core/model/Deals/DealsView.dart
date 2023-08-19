import 'package:ecommerceversiontwo/Pages/core/model/BrandsModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CategoriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CitiesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CountriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Deals/DealsFilterModel.dart';
import  'package:http/http.dart' as http;
import 'dart:convert';

class DealsView {
  int? idDeal;
  String? title;
  String? description;
  String? details;
  int? price;
  int? discount;
  int? quantity;
  Null? idPricesDelevery;
  String? datePublication;
  String? dateEND;
  String? imagePrinciple;
  Null? videoName;
  int? idCateg;
  CategoriesModel? categories;
  int? idUser;
  Null? user;
  int? idCountrys;
  CountriesModel? countries;
  int? idCity;
  CitiesModel? cities;
  int? idBrand;
  BrandsModel? brands;
  int? idPrize;
  Null? prizes;
  String? locations;
  int? idBoost;
  int? active;
  int? idWishList;
  int? nbLike;
  int? idLike;

  DealsView(
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
        this.user,
        this.idCountrys,
        this.countries,
        this.idCity,
        this.cities,
        this.idBrand,
        this.brands,
        this.idPrize,
        this.prizes,
        this.locations,
        this.idBoost,
        this.active,
        this.idWishList,
        this.nbLike,
        this.idLike});

  DealsView.fromJson(Map<String, dynamic> json) {
    idDeal = json['idDeal'];
    title = json['title'];
    description = json['description'];
    details = json['details'];
    price = json['price'];
    discount = json['discount'];
    quantity = json['quantity'];
    idPricesDelevery = json['idPricesDelevery'];
    datePublication = json['datePublication'];
    dateEND = json['dateEND'];
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
    idBrand = json['idBrand'];
    brands =
    json['brands'] != null ? new BrandsModel.fromJson(json['brands']) : null;
    idPrize = json['idPrize'];
    prizes = json['prizes'];
    locations = json['locations'];
    idBoost = json['idBoost'];
    active = json['active'];
    idWishList = json['idWishList'];
    nbLike = json['nbLike'];
    idLike = json['idLike'];
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
   /* if (this.user != null) {
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
    data['idBrand'] = this.idBrand;
    if (this.brands != null) {
      data['brands'] = this.brands!.toJson();
    }
    data['idPrize'] = this.idPrize;
    data['prizes'] = this.prizes;
    data['locations'] = this.locations;
    data['idBoost'] = this.idBoost;
    data['active'] = this.active;
    data['idWishList'] = this.idWishList;
    data['nbLike'] = this.nbLike;
    data['idLike'] = this.idLike;
    return data;
  }



}