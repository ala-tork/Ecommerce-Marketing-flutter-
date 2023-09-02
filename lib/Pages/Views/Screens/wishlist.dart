import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/GridWishList.dart';
import 'package:ecommerceversiontwo/Pages/core/model/WishListModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/WishListServices/WishListService.dart';

class WishList extends StatefulWidget {
  WishList({Key? key}) : super(key: key);

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  int? idUser;
  List<WishListModel> gridMap = [];
  int MaxPage = 0;
  int page = 0;
  int pageSize = 4;

  Future<int> getuserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var decodedToken = JwtDecoder.decode(token!);
    idUser = int.parse(decodedToken['id']);
    print("id user is $idUser");
    return idUser!;
  }

  Future<List<WishListModel>> getWishList() async {
    await getuserId();
    try {
      Map<String, dynamic> response = await WishListService().GetWishListByUser(idUser!, page, pageSize);

      if (response["res"] != null) {
        List<dynamic> adsJsonList = response["res"];
        if (page == 0) {
          gridMap.clear();
        }
        gridMap.addAll(
            adsJsonList.map((json) => WishListModel.fromJson(json)).toList());

        // Calculate number of pages
        int totalItems = response["nbitems"];
        MaxPage = (totalItems + pageSize - 1) ~/ pageSize;

        print(gridMap);
        return gridMap;
      } else {
        print(response["res"]);
        throw Exception('Failed to fetch Wish List');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('An error occurred: $e');
    }
  }


  Future<void> loadMoreData() async {
    if (page < MaxPage - 1) {
      setState(() {
        page = page + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Wish List"),
      body: FutureBuilder<List<WishListModel>>(
        future: getWishList(),
        builder: (BuildContext context,
            AsyncSnapshot<List<WishListModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to fetch data'));
          } else {
            return Padding(
              padding: const EdgeInsets.fromLTRB(4, 20, 4, 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (gridMap.isNotEmpty)
                      GridWishList(data: gridMap)
                    else
                      SizedBox.shrink(),
                    if (page < MaxPage - 1)
                      ElevatedButton(
                        onPressed: () {
                          if (page < MaxPage - 1) {
                            setState(() {
                              page = page + 1;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                        ),
                        child: Text("Show More"),
                      )
                    else
                      SizedBox.shrink(),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
