import 'package:http/http.dart' as http;
import 'dart:convert';


class LikeModel {
  int? idLP;
  int? idUser;
  int? idProd;
  int? idAd;
  int? idDeal;
  String? myDate;

  LikeModel(
      {this.idLP,
        this.idUser,
        this.idProd,
        this.idAd,
        this.idDeal,
        this.myDate});

  LikeModel.fromJson(Map<String, dynamic> json) {
    idLP = json['idLP'];
    idUser = json['idUser'];
    if(json['idProd']!=null)
    idProd = json['idProd'];
    if(json['idAd']!=null)
      idAd = json['idAd'];
    if(json['idDeal']!=null)
      idDeal = json['idDeal'];
    if(json['myDate']!=null)
      myDate = json['myDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.idLP!=null)
    data['idLP'] = this.idLP;
    data['idUser'] = this.idUser;
    if(this.idProd!=null)
    data['idProd'] = this.idProd;
    if(this.idAd!=null)
      data['idAd'] = this.idAd;
    if(this.idDeal!=null)
      data['idDeal'] = this.idDeal;
    if(this.myDate!=null)
      data['myDate'] = this.myDate;
    return data;
  }

  Future<LikeModel> addLike(LikeModel like) async {
    final apiUrl = 'https://10.0.2.2:7058/api/Like';

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

  Future<bool> deleteLike(int id) async {
    final String apiUrl = "https://10.0.2.2:7058/api/Like/$id";
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
}