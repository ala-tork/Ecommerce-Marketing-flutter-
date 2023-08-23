import  'package:http/http.dart' as http;
import 'dart:convert';

class BrandsModel {
  int? idBrand;
  String? title;
  String? description;
  String? image;
  int? active;

  BrandsModel(
      {this.idBrand, this.title, this.description, this.image, this.active});

  BrandsModel.fromJson(Map<String, dynamic> json) {
    idBrand = json['idBrand'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idBrand'] = this.idBrand;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['active'] = this.active;
    return data;
  }
}