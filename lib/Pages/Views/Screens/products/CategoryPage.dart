import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerceversiontwo/Pages/Views/Screens/products/Category.dart';
class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Categorie> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5055/api/Categorie/GetCategorieAll'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final categorieList = List.from(jsonData);
     // print("${categorieList}");
      final newCategorie = categorieList.map((item) => Categorie.fromJson(item)).toList();
      setState(() {
        categories.addAll(newCategorie);
      });
    } else {
      print('Failed to fetch categories. Error: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Row(
          children: categories.map((categorie) => buildCategoryItem(categorie)).toList(),
        ),
      ),
    );
  }
  Widget buildCategoryItem(Categorie categorie) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            categorie.imageBase64 != null && categorie.imageBase64!.isNotEmpty
                ? Image.memory(
              base64Decode(categorie.imageBase64!),
              width: 50,
              height: 50,
            )
                : Placeholder(
              fallbackHeight: 50,
              fallbackWidth: 50,
            ),
            Text(
              "${categorie.title}",
              style: TextStyle(color: Colors.indigo),
            )
          ],
        ),
      ),
    );
  }

}
