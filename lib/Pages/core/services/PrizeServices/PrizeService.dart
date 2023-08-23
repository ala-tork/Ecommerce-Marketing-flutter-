import 'package:ecommerceversiontwo/Pages/core/model/PrizesModels/Prize.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrizeService{

  Future<PrizeModel> GetPrizeById(int idPrize) async {
    final String apiUrl = "https://10.0.2.2:7058/api/Prize/$idPrize";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        dynamic jsonResponse = json.decode(response.body);
        PrizeModel prize = PrizeModel.fromJson(jsonResponse);
        return prize;
      } else {
        throw Exception("Failed to fetch Prize. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error Fetching Prize By Deals: $e");
      throw Exception("Error fetching Prize: $e");
    }
  }

  Future<PrizeModel> AddPrize(PrizeModel p) async {

    final apiUrl = 'https://10.0.2.2:7058/api/Prize';
    try {
      final encodedData = p.toJson();
      print(encodedData);
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
        return PrizeModel.fromJson(responseData);
      } else {
        throw Exception('Failed to add to Prize');
      }
    } catch (e) {
      print('Error adding to Prize: $e');
      rethrow;
    }
  }

  Future<bool> deleteDealsPrize(int id) async {
    print(id);
    final String apiUrl = "https://10.0.2.2:7058/api/Prize/$id";
    try {
      final response = await http.delete(Uri.parse(apiUrl),);
      print("//////////////// ${response.body}");
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to delete Prize. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error deleting Prize  $e");
      return false;
    }
  }
  Future<PrizeModel> UpdatePrize(PrizeModel prize,int idPrize) async{
    final apiUrl = 'https://10.0.2.2:7058/api/Prize?idprize=$idPrize';
    try{
      final encodedData = prize.toJson();
      print(encodedData);
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(encodedData),
      );
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return PrizeModel.fromJson(responseData);
      } else {
        throw Exception('Failed to add to Prize');
      }
    }catch(e){
      throw Exception("failed to update prize : $e");
    }
  }
}