import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AdsFilterModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/ProductModels/CreateProduct.dart';
import 'package:ecommerceversiontwo/Pages/core/model/ProductModels/Product.dart';
import 'package:ecommerceversiontwo/Pages/core/model/ProductModels/ProductFilter.dart';
import  'package:http/http.dart' as http;
import 'dart:convert';

class ProductService{
  Future<Map<String, dynamic>> createProduct(CreateProduct prodModel) async {
    var headers = {'Content-Type': 'application/json'};
    var url = Uri.parse("https://10.0.2.2:7058/api/Product/CreateProduct");
    var adData = json.encode(prodModel.toJson());

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
  Future<Product?> updateProduct(int prodId, CreateProduct updatedData) async {
    try {
      var url = Uri.parse("https://10.0.2.2:7058/api/Product/product/$prodId");
      var headers = {'Content-Type': 'application/json'};

      var jsonBody = json.encode(updatedData.toJson());
      print(jsonBody);
      var response = await http.put(url, headers: headers, body: jsonBody);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return Product.fromJson(responseData);
      } else {
        print('Failed to update Product. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error updating product: $e');
      return null;
    }
  }


/*
  //fileter data with pagination
  Future<Map<String, dynamic>> getFilteredDeals(DealsFilterModel filter) async {
    print(filter.toJson());
    try {

      final response = await http.post(
        Uri.parse("${ApiPaths().GetFiltredDealUrl}"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(filter.toJson()),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to fetch Deals ');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }*/

  Future<bool> deleteData(int id) async {
    final String apiUrl = "https://10.0.2.2:7058/api/Product/product/${id}";

    try {
      final response = await http.delete(Uri.parse(apiUrl),);

      if (response.statusCode == 200) {
        print("deals fetures deleted succesfulty");
        return true;
      } else {
        print("Failed to delete product. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error deleting item: $e");
      return false;
    }
  }

  Future<Product> getProductById(int id) async {
    final String apiurl = "https://10.0.2.2:7058/api/Product/product/$id";
    final response = await http.get(Uri.parse(apiurl));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      Product prod = Product.fromJson(jsonResponse);
      return prod;
    } else {
      print('Failed to fetch Product: ${response.body}');
      throw Exception('Failed to fetch Product');
    }
  }





  ////// filtred Product with like and wishlist
  /**          fileter data with pagination                */
  Future<Map<String, dynamic>> getFilteredViewProduct(FilterProduct filter,int idUser) async {
    print(filter.toJson());
    try {
      final response = await http.post(
        Uri.parse("https://10.0.2.2:7058/api/Test/ProdWithLikeAndWishList?iduser=$idUser"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(filter.toJson()),
      );
      print("///////////////${response.body}");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        return responseData;
      } else {
        throw Exception('Failed to fetch Product ');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  ////// filtred Product with like and wishlist
  /**  fileter data by UserId with pagination */
  Future<Map<String, dynamic>> getUserProduc(FilterProduct filter,int idUser) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiPaths().GetUserProductUrl}$idUser"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(filter.toJson()),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        return responseData;
      } else {
        throw Exception('Failed to fetch Product ');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }



  Future<Map<String, dynamic>> GetProductByUser(int idUser,int page, int pagesize) async {
    try {

      final response = await http.get(
        Uri.parse("https://10.0.2.2:7058/api/Product/ShowMoreProductByUserId?iduser=$idUser&page=$page&pagesize=$pagesize"),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        //print(responseData);
        return responseData;
      } else {
        throw Exception('Failed to fetch Products ');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }


}