import 'dart:convert';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerceversiontwo/ApiService.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/products/CategoryPage.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/products/iconandtextwidget.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/products/product.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/products/productDetailsScreen.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/products/productListScreen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';



class FoodPageBody extends StatefulWidget {
  const FoodPageBody({super.key});

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  PageController pageController = PageController(viewportFraction: 0.85);
  var _currentPageValue = 0.0;
  double _scaleFactor = 0.8;
  double height = 22;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchRecentsProducts();
    pageController.addListener(() {
      setState(() {
        _currentPageValue = pageController.page!;
      });
    });
    _refreshToken();

  }

  @override
  void dispose() {
    pageController.dispose();
  }
  List<Product> products = [];
  List<Product> recentproducts = [];
  bool refreshingToken = false;

  Future<void> _refreshToken() async {
    if (refreshingToken) return;

    refreshingToken = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');
    print("refreshToken frol food $refreshToken");
    if (refreshToken != null) {

      bool success = await ApiService.refreshToken(refreshToken);

      if (success) {
        String? updatedToken = prefs.getString('token');
        if (updatedToken != null) {
          await prefs.setString('token', updatedToken);
        }

        print("Token refreshed successfully");
      } else {
        print("Failed to refresh token");
      }
    }

    refreshingToken = false;
  }

  Future<void> fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

      final response = await http.get(
        Uri.parse('http://10.0.2.2:5055/api/Product/GetProductAll'),
        headers: headers,
      );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final productList = List.from(jsonData);
      final newProducts = productList.map((item) => Product.fromJson(item)).toList();

      setState(() {
        products.addAll(newProducts);
      });
    } else {
      print('Failed to fetch products. Error: ${response.statusCode}');
    }
  }

  Future<void> fetchRecentsProducts({int page = 1, int pageSize = 5}) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5055/api/Product/GetRecentProducts?page=$page&pageSize=$pageSize'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final productList = List.from(jsonData);
      final newProducts = productList.map((item) => Product.fromJson(item)).toList();

      setState(() {
        recentproducts.addAll(newProducts);
      });
    } else {
      print('Failed to fetch products. Error: ${response.statusCode}');
    }
  }


  Color _getColorFromName(String colorName) {
    switch (colorName) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      case 'pink':
        return Colors.pink;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Container(
              color: Colors.white,
              height: 320,
              child: PageView.builder(
                controller: pageController,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _builderPageItem(index);
                },
              ),
            ),
            DotsIndicator(
              dotsCount: 5,
              position: _currentPageValue.toInt(),
              decorator: DotsDecorator(
                activeColor: Colors.cyanAccent,
                size: const Size.square(9.0),
                activeSize: const Size(18.0, 9.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            //Category
            Padding(
              padding: EdgeInsets.only(right: 266),
              child: Text(
                "Cateogry",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                  fontSize: 20,

                ),
              ),
            ),
            CategoryPage(),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  Text(
                    "Newest",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                      fontSize: 20,

                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.only(bottom: 3),
                    child: Text("",style: TextStyle( color: Colors.black26)),
                  ),
                ],
              ),
            ),
            products.isNotEmpty?
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: recentproducts.length,
              itemBuilder: (context, index) {
                final product = recentproducts[index];
                final date = DateTime.parse(product.datePublication.toString());
                final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(date);

                return Container(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Row(
                    children: [
                      // image section
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white38,
                          image: product.imageBase64 != null
                              ? DecorationImage(
                            fit: BoxFit.cover,
                            image: MemoryImage(base64Decode(product.imageBase64!)),
                          )
                              : DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(""),
                          ),
                        ),
                      ),
                      // text container
                      Expanded(
                        child: Container(
                          //  height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              children: [
                                Text(product.price.toString(),style: TextStyle(color: Colors.brown),),
                                Text(
                                  formattedDate,
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.favorite),
                                      color: Colors.indigo,
                                      iconSize: 20,
                                      onPressed: () {
                                        // Handle favorite button action
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add_shopping_cart),
                                      color: Colors.indigo,
                                      iconSize: 20,
                                      onPressed: () {
                                        // Handle add to cart button action
                                      },
                                    ),
                                  ],
                                ),

                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.indigo,
                                    onPrimary: Colors.white,
                                  ),

                                  child: Text('Show Details'),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailsScreen(product: product),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
                : Center(
              child: CircularProgressIndicator(), // Display a spinner
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
                onPrimary: Colors.white,
              ),

              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(

                    builder: (context) =>
                        ProductListScreen(),
                  ),
                );
              },              child: Text('Show More'),
            )
          ],
        ),
      ],
    );
  }

  Widget _builderPageItem(int index) {
    if (index >= products.length) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    final product = products[index];

    Matrix4 matrix = new Matrix4.identity();

    if (index == _currentPageValue.floor()) {
      var currScale = 1 - (_currentPageValue - index) * (1 - _scaleFactor);
      var currTrans = height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currentPageValue.floor() + 1) {
      var currScale =
          _scaleFactor + (_currentPageValue - index + 1) * (1 - _scaleFactor);
      var currTrans = height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currentPageValue.floor() - 1) {
      var currScale = 1 - (_currentPageValue - index) * (1 - _scaleFactor);
      var currTrans = height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, height * (1 - _scaleFactor) / 2, 1);
    }
    return Transform(
        transform: matrix,
        child: Stack(
          children: [
            Container(
              height: 220,
              margin: EdgeInsets.only(left: 10, right: 10),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: index.isEven ? Color(0xFF69c5df) : Color(0xFF9294cc),
                image: product.imageBase64 != null
                    ? DecorationImage(
                  fit: BoxFit.cover,
                  image: MemoryImage(base64Decode(product.imageBase64!)),
                )
                    : DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/avatar1.jpg"),
                ),
              ),


            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 120,
                margin: EdgeInsets.only(left: 30, right: 30, bottom: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0XFFe8e8e8),
                        blurRadius: 5.0,
                        offset: Offset(0, 5),
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-5, 0),
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(5, 0),
                      ),
                    ]),
                child: Container(
                  padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: Column(
                    children: [
                      Text("${product.title}",style: TextStyle(color: Colors.indigo),),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Wrap(
                            children: List.generate(
                              4,
                                  (index) => Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 10,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Price:${product.price}TN",
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Quantity : ${product.qty}",
                            style: TextStyle(color: Colors.grey),
                          ),

                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconAndTextWidget(
                            icon: Icons.circle_sharp,
                            text: "${product.color}",
                            TextColor: Colors.grey,
                            iconColor: _getColorFromName(product.color.toString()),
                          ),

                          IconAndTextWidget(
                            icon: Icons.access_time_rounded,
                            text: "${DateFormat('yyyy-MM-dd HH:mm').format(product.datePublication)}",
                            TextColor: Colors.grey,
                            iconColor: Colors.indigo,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
