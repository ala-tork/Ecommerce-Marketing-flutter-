import 'package:ecommerceversiontwo/Pages/core/model/BrandsModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CategoriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CitiesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CountriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Deals/DealsModel.dart';
import  'package:http/http.dart' as http;
import 'dart:convert';

class CreateDealsModel {
  String? title;
  String? description;
  String? details;
  int? price;
  int? discount;
  int? quantity;
  String? idPricesDelevery;
  String? datePublication;
  String? dateEND;
  String? imagePrinciple;
  String? videoName;
  int? idCateg;
  int? idUser;
  int? idCountrys;
  int? idCity;
  int? idBrand;
  int? idPrize;
  String? locations;
  int? idBoost;
  int? active;

  CreateDealsModel(
      {
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
        this.idUser,
        this.idCountrys,
        this.idCity,
        this.idBrand,
        this.idPrize,
        this.locations,
        this.idBoost,
        this.active});

  CreateDealsModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    details = json['details'];
    price = json['price'];
    discount = json['discount'];
    quantity = json['quantity'];
    if(json['idPricesDelevery']!=null)
    idPricesDelevery = json['idPricesDelevery'];

    if(json['datePublication']!=null)
    datePublication = json['datePublication'];

    if(json['dateEND']!=null)
    dateEND = json['dateEND'];

    imagePrinciple = json['imagePrinciple'];
    if(json['videoName']!=null)
    videoName = json['videoName'];

    idCateg = json['idCateg'];
    idUser = json['idUser'];
    idCountrys = json['idCountrys'];
    idCity = json['idCity'];
    idBrand = json['idBrand'];

    if(json['idPrize']!=null)
    idPrize = json['idPrize'];

    locations = json['locations'];
    idBoost = json['idBoost'];
    active = json['active'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['title'] = this.title!;
    data['description'] = this.description!;
    data['details'] = this.details!;
    data['price'] = this.price.toString();
    data['discount'] = this.discount.toString();
    data['quantity'] = this.quantity.toString();
    if (idPricesDelevery != null) data['idPricesDelevery'] = this.idPricesDelevery.toString();
    if (datePublication != null) data['datePublication'] = this.datePublication!;
    if (dateEND != null) data['dateEND'] = this.dateEND!;
    data['imagePrinciple'] = this.imagePrinciple!;
    if (videoName != null) data['videoName'] = this.videoName!;
    data['idCateg'] = this.idCateg.toString();
    data['idUser'] = this.idUser.toString();
    data['idCountrys'] = this.idCountrys.toString();
    data['idCity'] = this.idCity.toString();
    data['idBrand'] = this.idBrand.toString();
    if (idPrize != null) data['idPrize'] = this.idPrize.toString();
    data['locations'] = this.locations!;
    if (idBoost != null) data['idBoost'] = this.idBoost.toString();
    data['active'] = this.active.toString();
    return data;
  }

  Map<String, dynamic> toJsonUpdate() {
    return {
      "title": title,
      "description": description,
      "details": details,
      "price": price,
      "discount":discount,
      "quantity" : quantity,
      "idPricesDelevery" : idPricesDelevery,
      "datePublication" : datePublication,
      "dateEND" : dateEND,

      "idUser": idUser,
      "imagePrinciple": imagePrinciple,
      "videoName": videoName,
      "idCateg": idCateg,
      "idCountrys": idCountrys,
      "idCity": idCity,
      "idBrand" : idBrand,
      "idPrize" : idPrize,
      "locations": locations,
      "idBoost": idBoost,
      "active": active,
    };
  }


  Future<Map<String, dynamic>> createDeal(CreateDealsModel adModel) async {
    var headers = {'Content-Type': 'application/json'};
    var url = Uri.parse("https://10.0.2.2:7058/api/Deals");
    var adData = json.encode(adModel.toJson());

    var response = await http.post(url, headers: headers, body: adData);

    if (response.statusCode == 200 || response.statusCode==201) {
      Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } else {
      Map<String, dynamic> responseData = json.decode(response.body);
      print("Request failed with status: ${response.statusCode}");
      return responseData;
    }
  }




// Update announce
  Future<DealsModel?> updateDeals(int dealsId, CreateDealsModel updatedData) async {
    try {
      var url = Uri.parse("https://10.0.2.2:7058/api/Deals/$dealsId");
      var headers = {'Content-Type': 'application/json'};

      var jsonBody = json.encode(updatedData.toJson());
      print(jsonBody);
      var response = await http.put(url, headers: headers, body: jsonBody);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return DealsModel.fromJson(responseData);
      } else {
        print('Failed to update announcement. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error updating Deals: $e');
      return null;
    }
  }
}



class ListDealsFeaturesFeatureValues {
  int featureId;
  int featureValueId;

  ListDealsFeaturesFeatureValues({required this.featureId, required this.featureValueId});


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['featureId'] = this.featureId;
    data['featureValueId'] = this.featureValueId;
    return data;
  }
}