import 'package:ecommerceversiontwo/Pages/core/model/BostSlideShowModels/BoostSlideShowModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BoostedSlideShowService {
  Future<List<BoostSlideShowModel>> getBoostSlideShow() async {
    try {
      final response = await http.get(
        Uri.parse("https://10.0.2.2:7058/api/BoostSlideShow"),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List<dynamic>;
        List<BoostSlideShowModel> boostSlideShowList = responseData
            .map((json) => BoostSlideShowModel.fromJson(json))
            .toList();
        return boostSlideShowList;
      } else {
        throw Exception('Failed to fetch Boost Slide Show');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<List<BoostSlideShowModel>> getrandomSlideShow() async {
    try {
      final response = await http.get(
        Uri.parse("https://10.0.2.2:7058/api/BoostSlideShow/randomNotBosted"),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List<dynamic>;
        List<BoostSlideShowModel> boostSlideShowList = responseData
            .map((json) => BoostSlideShowModel.fromJson(json))
            .toList();
        return boostSlideShowList;
      } else {
        throw Exception('Failed to fetch Boost Slide Show');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
