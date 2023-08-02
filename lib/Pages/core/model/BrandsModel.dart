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
  /*
//get all Brands
  Future<List<BrandsModel>> GetAllBrands() async {
    http.Response response;
    response = await http
        .get(Uri.parse("https://10.0.2.2:7058/api/Brands"));

    if (response.statusCode == 200) {
      var responseBody = response.body;
      List<BrandsModel> brandlist=(jsonDecode(responseBody) as List)
          .map((json) => BrandsModel.fromJson(json))
          .toList();

      return brandlist;
    } else {
      print(response.body);
      throw Exception('Failed to fetch Brands');
    }
  }

  //get Brand
  Future<BrandsModel> GetCategoryById( int id) async {
    http.Response response;
    response = await http.get(Uri.parse("https://10.0.2.2:7058/api/Brands/$id"));
    print(response.body);
    if (response.statusCode == 200) {
      BrandsModel brand = (jsonDecode(response.body));

      return brand;
    } else {
      print(response.body);
      throw Exception('Failed to fetch brand by ID');
    }
  }*/
}