import 'dart:convert';
import 'package:http/http.dart' as http;

class DealsFilterModel {
  String? DealsName;
  int? idCountrys;
  int? idCity;
  List<int?>? idFeaturesValues;
  int? idCategory;
  int? IdBrans;
  double? minPrice;
  double? maxPrice;
  int pageNumber;

  DealsFilterModel({
    this.DealsName,
    this.idCountrys,
    this.idCity,
    this.idFeaturesValues,
    this.idCategory,
    this.minPrice,
    this.maxPrice,
    this.IdBrans,
    required this.pageNumber,
  });

  factory DealsFilterModel.fromJson(Map<String, dynamic> json) {
    return DealsFilterModel(
      DealsName : json['DealsName'],
      idCountrys: json['IdCountrys'],
      idCity: json['IdCity'],
      idFeaturesValues: List<int?>.from(json['IdFeaturesValues']),
      idCategory: json['IdCategory'],
      IdBrans : json['IdBrans'],
      minPrice: json['MinPrice'],
      maxPrice: json['MaxPrice'],
      pageNumber: json['PageNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if(this.DealsName!=null)
      data['DealsName'] = this.DealsName;
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
    if(this.IdBrans!=null)
      data['IdBrans'] = this.IdBrans;
    return data;
  }


}
