import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Deals/CreateDealsModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Deals/DealsFilterModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Deals/DealsModel.dart';
import  'package:http/http.dart' as http;
import 'dart:convert';

class DealsService{


  Future<Map<String, dynamic>> createDeal(CreateDealsModel adModel) async {
    var headers = {'Content-Type': 'application/json'};
    var url = Uri.parse("${ApiPaths().CreateDealsUrl}");
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
      var url = Uri.parse("${ApiPaths().UpdateDealsUrl}$dealsId");
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
  }

  Future<bool> deleteData(int id) async {
    final String apiUrl = "${ApiPaths().DeleteDealUrl}${id}";

    try {
      final response = await http.delete(Uri.parse(apiUrl),);

      if (response.statusCode == 200) {
        print("deals fetures deleted succesfulty");
        return true;
      } else {
        print("Failed to delete Deals. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error deleting item: $e");
      return false;
    }
  }

  Future<DealsModel> getDealById(int id) async {
    final String apiurl = "${ApiPaths().DeleteDealUrl}$id";
    final response = await http.get(Uri.parse(apiurl));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      DealsModel deal = DealsModel.fromJson(jsonResponse);
      return deal;
    } else {
      print('Failed to fetch Deal: ${response.body}');
      throw Exception('Failed to fetch Deal');
    }
  }





  ////// filtred deals with like and wishlist
  //fileter data with pagination
  Future<Map<String, dynamic>> getFilteredViewDeals(DealsFilterModel filter,int idUser) async {
    print(filter.toJson());
    try {

      final response = await http.post(
        Uri.parse("${ApiPaths().GetFiltredDealsUrl}$idUser"),
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
  }

  Future<Map<String, dynamic>> GetDealsByUser(int idUser,int page, int pagesize) async {
    try {

      final response = await http.get(
        Uri.parse("${ApiPaths().GetDealsByUserIdUrl}${idUser}?page=${page}&pageSize=$pagesize"),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        //print(responseData);
        return responseData;
      } else {
        throw Exception('Failed to fetch Deals ');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

}