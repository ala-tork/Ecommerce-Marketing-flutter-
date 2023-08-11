import 'dart:convert';
import 'package:http/http.dart' as http;

class AdsFilterModel {
  String? adsName;
  int? idCountrys;
  int? idCity;
  List<int?>? idFeaturesValues;
  int? idCategory;
  double? minPrice;
  double? maxPrice;
  int pageNumber;

  AdsFilterModel({
    this.adsName,
    this.idCountrys,
    this.idCity,
    this.idFeaturesValues,
    this.idCategory,
    this.minPrice,
    this.maxPrice,
    required this.pageNumber,
  });

  factory AdsFilterModel.fromJson(Map<String, dynamic> json) {
    return AdsFilterModel(
      adsName :json['adsName'],
      idCountrys: json['IdCountrys'],
      idCity: json['IdCity'],
      idFeaturesValues: List<int?>.from(json['IdFeaturesValues']),
      idCategory: json['IdCategory'],
      minPrice: json['MinPrice'],
      maxPrice: json['MaxPrice'],
      pageNumber: json['PageNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if(this.adsName!=null)
      data['adsName'] = this.adsName;
    if(this.idCountrys!=null)
    data['IdCountrys'] = this.idCountrys;
    if(this.idCity!=null)
    data['IdCity'] = this.idCity;
    data['IdFeaturesValues'] = this.idFeaturesValues;
    if(this.idCategory!=null)
    data['IdCategory'] = this.idCategory;
    if(this.minPrice!=null)
    data['MinPrice'] = this.minPrice;
    if(this.maxPrice!=null)
    data['MaxPrice'] = this.maxPrice;
    if(this.pageNumber!=null)
    data['PageNumber'] = this.pageNumber;
    return data;
  }

/*
  //fileter data with pagination
  Future<Map<String, dynamic>> getFilteredAds(AdsFilterModel filter) async {
    print(filter.toJson());
    try {

      final response = await http.post(
        Uri.parse("https://10.0.2.2:7058/api/Test/filtered"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(filter.toJson()),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }*/
}
