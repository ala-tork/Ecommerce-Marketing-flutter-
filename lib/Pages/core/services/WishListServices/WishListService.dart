import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/core/model/WishListModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WishListService{


  Future<WishListModel> AddAnnouceToWishList(WishListModel w) async {

    final apiUrl = '${ApiPaths().AddToWishlistUrl}';
    try {
      final encodedData = w.toJson();
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(encodedData),
      );
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return WishListModel.fromJson(responseData);
      } else {
        throw Exception('Failed to add to wishList');
      }
    } catch (e) {
      print('Error adding to wishList: $e');
      rethrow;
    }
  }



  Future<bool> deleteFromWishList(int id) async {
    final String apiUrl = "${ApiPaths().DeleteFromWishListUrl}$id";
    try {
      final response = await http.delete(Uri.parse(apiUrl),);
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to delete Ads from wish List. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error deleting from wishList: $e");
      return false;
    }
  }


/*  Future<List<WishListModel>> GetAllWishListByUser(int idUser) async {
    final String apiUrl = "https://10.0.2.2:7058/api/WishList/GEtWishListByUser/$idUser";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        if (response.body != null) {
          List<dynamic> jsonResponse = json.decode(response.body);
          List<WishListModel> wishList = jsonResponse.map((item) => WishListModel.fromJson(item)).toList();
          return wishList;
        } else {
          return [];
        }
      } else {
        throw Exception("Failed to fetch wishlist. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error Fetching WishList By User: $e");
      throw Exception("Error fetching wishlist: $e");
    }
  }*/

  Future<Map<String, dynamic>> GetWishListByUser(int idUser,int page,int pagesize) async {
    try {

      final response = await http.get(
        Uri.parse("${ApiPaths().GetWishListByUserIdUrl}${idUser}?page=${page}&pageSize=${pagesize}"),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        //print(responseData);
        return responseData;
      } else {
        throw Exception('Failed to fetch WishList ');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }


}