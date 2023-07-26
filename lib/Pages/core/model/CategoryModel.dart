import  'package:http/http.dart' as http;
import 'dart:convert';

class CategoriesModel {
  int? idCateg;
  String? title;
  String? description;
  String? image;
  int? idparent;
  List<CategoriesModel>? children;
  int? Active;

  CategoriesModel({
     this.idCateg,
     this.title,
     this.description,
     this.image,
    this.idparent,
    this.children = const [],
    this.Active
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      idCateg: json['idCateg'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      idparent: json['idparent'],
      children: (json['children'] as List<dynamic>?)
          ?.map((childJson) => CategoriesModel.fromJson(childJson))
          .toList(),
      Active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idCateg'] = this.idCateg;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['idparent'] = this.idparent;
    data['children'] = this.children;
    data['active'] = this.Active;
    return data;
  }

  Future<List<CategoriesModel>> GetData() async {
    http.Response response;
    response = await http.get(Uri.parse("https://10.0.2.2:7058/api/CategoriesControler/GetAllCategories"));
    if (response.statusCode == 200) {
      List<CategoriesModel> categoryList = (jsonDecode(response.body) as List)
          .map((json) => CategoriesModel.fromJson(json))
          .toList();
      return categoryList;
    } else {
      print(response.body);
      throw Exception('Failed to fetch Categories');
    }
  }
  Future<CategoriesModel> GetCategoryById( int id) async {
    http.Response response;
    response = await http.get(Uri.parse("https://10.0.2.2:7058/api/CategoriesControler/$id"));
    print(response.body);
    if (response.statusCode == 200) {
      CategoriesModel categ = (jsonDecode(response.body));

      return categ;
    } else {
      print(response.body);
      throw Exception('Failed to fetch Categorie by ID');
    }
  }
}