import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/core/model/LikesModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LikeService{
  Future<LikeModel> addLike(LikeModel like) async {
    final apiUrl = '${ApiPaths().AddLikeUrl}';

    try {
      final encodedData = jsonEncode(like.toJson());
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: encodedData,
      );
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return LikeModel.fromJson(responseData);
      } else {
        throw Exception('Failed to add Like');
      }

    } catch (e) {
      print('Error adding Like: $e');
      rethrow;
    }
  }

  Future<bool> deleteLike(int id) async {
    final String apiUrl = "${ApiPaths().DeleteLikeUrl}$id";
    try {
      final response = await http.delete(Uri.parse(apiUrl),);
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to delete Ads Like. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error deleting Like: $e");
      return false;
    }
  }



/*
  //get Like by IdAd and idUser
  Future<Map<String, dynamic>> getLikeAds(int idUser , int idAds) async {
    try {
      print("like ");
      final response = await http.get(
        Uri.parse("https://10.0.2.2:7058/api/Like/ByUserAndAd/$idUser/$idAds"),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to fetch Likes');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  //get Like by IdDeal and idUser
  Future<Map<String, dynamic>> getLikeDeals(int idUser , int idDeal) async {
    try {
      final response = await http.get(
        Uri.parse("https://10.0.2.2:7058/api/Like/ByUserAndDeal/$idUser/$idDeal"),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to fetch Likes');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
*/
}