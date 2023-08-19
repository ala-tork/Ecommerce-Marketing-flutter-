import 'package:http/http.dart' as http;
import 'dart:convert';

class Boost {
  int? idBoost;
  String? titleBoost;
  int? price;
  String? discount;
  int? maxDurationPerDay;
  int? inSliders;
  int? inSideBar;
  int? inFooter;
  int? inRelatedPost;
  int? inFirstLogin;
  int? hasLinks;
  int? orders;

  Boost(
      {this.idBoost,
        this.titleBoost,
        this.price,
        this.discount,
        this.maxDurationPerDay,
        this.inSliders,
        this.inSideBar,
        this.inFooter,
        this.inRelatedPost,
        this.inFirstLogin,
        this.hasLinks,
        this.orders});

  Boost.fromJson(Map<String, dynamic> json) {
    idBoost = json['idBoost'];
    titleBoost = json['titleBoost'];
    price = json['price'];
    discount = json['discount'];
    maxDurationPerDay = json['maxDurationPerDay'];
    inSliders = json['inSliders'];
    inSideBar = json['inSideBar'];
    inFooter = json['inFooter'];
    inRelatedPost = json['inRelatedPost'];
    inFirstLogin = json['inFirstLogin'];
    hasLinks = json['hasLinks'];
    orders = json['orders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idBoost'] = this.idBoost;
    data['titleBoost'] = this.titleBoost;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['maxDurationPerDay'] = this.maxDurationPerDay;
    data['inSliders'] = this.inSliders;
    data['inSideBar'] = this.inSideBar;
    data['inFooter'] = this.inFooter;
    data['inRelatedPost'] = this.inRelatedPost;
    data['inFirstLogin'] = this.inFirstLogin;
    data['hasLinks'] = this.hasLinks;
    data['orders'] = this.orders;
    return data;
  }

  Future<List<Boost>> GetAllBoosts() async {
    final String apiUrl = "https://10.0.2.2:7058/api/Boost";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        if (response.body != null) {
          List<dynamic> jsonResponse = json.decode(response.body);
          List<Boost> Boosts = jsonResponse.map((item) => Boost.fromJson(item)).toList();
          return Boosts;
        } else {
          return [];
        }
      } else {
        throw Exception("Failed to fetch Boosts. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error Fetching Boosts: $e");
      throw Exception("Error fetching Boosts: $e");
    }
  }
}