import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:http/http.dart' as http;


class SettingService{
  Future<int> getNbDiamondAds() async {
    final response = await http.get(Uri.parse('${ApiPaths().GetNbDiamondAds}'));

    if (response.statusCode == 200) {
      //final Map<String, dynamic> data = json.decode(response.body);
      //return data['value'] as int;
      print(response.body);
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load nbDiamondAds');
    }
  }

  Future<int> getNbDiamondDeals() async {
    final response = await http.get(Uri.parse('${ApiPaths().GetNbDiamondDeals}'));

    if (response.statusCode == 200) {
     /* final Map<String, dynamic> data = json.decode(response.body);
      return data['value'] as int;*/
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load nbDiamondDeals');
    }
  }

  Future<int> getNbDiamondProduct() async {
    final response = await http.get(Uri.parse('${ApiPaths().GetNbDiamondProduct}'));

    if (response.statusCode == 200) {
     /*
     final Map<String, dynamic> data = json.decode(response.body);
      return data['value'] as int;
      */
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load nbDiamondProduct');
    }
  }

}