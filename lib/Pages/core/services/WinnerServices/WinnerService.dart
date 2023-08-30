import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/core/model/WinnerModel/WinnerModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WinnerService{

  Future<List<WinnerModel>> GetRandomWinners () async{
    try{
      final response = await http.get(
        Uri.parse("${ApiPaths().GetRandomWinnerUrl}"),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);
        List<WinnerModel> winnersList = responseData.map((e) => WinnerModel.fromJson(e)).toList();
        return winnersList;
      } else {
        throw Exception('Failed to fetch Winners ');
      }

    }catch (e){
      throw Exception("error GetRandomWinners : $e");
    }
  }
}