import 'package:ecommerceversiontwo/Pages/core/model/BrandsModel.dart';
import  'package:http/http.dart' as http;
import 'dart:convert';


class BrandsService{

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
  }
}