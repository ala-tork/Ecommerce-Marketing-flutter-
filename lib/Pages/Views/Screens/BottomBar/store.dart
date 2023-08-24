import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AdsFilterModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AnnounceModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CategoriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/LikesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/AnnouncesServices/AnnounceService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/CategoriesServices/CategoryService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/LikeServices/LikeService.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  int page = 1;
  List<AnnounceModel> gridMap=[];
  Future<List<AnnounceModel>> apicall() async {
    AdsFilterModel adsFilter = AdsFilterModel(pageNumber: page, idFeaturesValues: []);

    try {
      Map<String, dynamic> response = await AnnounceService().getFilteredAds(adsFilter);

      if (response["ads"] != null) {
        List<dynamic> adsJsonList = response["ads"];
        if (page == 1) {
          gridMap.clear();
          gridMap.addAll(adsJsonList.map((json) => AnnounceModel.fromJson(json)).toList());
        } else {
          gridMap.addAll(adsJsonList.map((json) => AnnounceModel.fromJson(json)).toList());
        }
        return gridMap;
      } else {
       // print(response["ads"]);
        throw Exception('Failed to fetch Ads');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('An error occurred: $e');
    }
  }
  int? id ;
  Future<void> getuserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var decodedToken = JwtDecoder.decode(token!);
    id = int.parse(decodedToken['id']);
    //print("id user is $id");
  }
  Future<void> getLikeByIdUserIdAd() async {
    try {
      await getuserId();
      List<AnnounceModel>listannounce=await apicall();
      if (listannounce.length != 0) {
        for (var a in listannounce) {
          Map<String, dynamic> response = await LikeService().getLikeAds(id!, a.idAds!);
          a.nbLike=response["nbLike"];
          if(response["like"]!=null)
            a.likeId= await LikeModel.fromJson(response["like"]).idLP;
        }
        print(listannounce[0]);
      }

    } catch (e) {
      print('error fetching Likes: $e');
    }
  }

  // category variabales
  List<CategoriesModel> _categorys = [];
  CategoriesModel? _category;
  int CategoryId = 0;
  CategoriesModel? selectedCategory;

  Future<List<CategoriesModel>> fetchData() async {
    try {
      List<CategoriesModel> categories = await CategoryService().GetData();
      _categorys = categories;
      return categories;
    } catch (e) {
      print('Error fetching categories: $e');
      throw Exception('failed to fetch');
    }
  }

 /* List<DropdownMenuItem<CategoriesModel>> buildDropdownItems(List<CategoriesModel> categories) {
    List<DropdownMenuItem<CategoriesModel>> items = [];

    for (var category in categories) {
      items.add(DropdownMenuItem<CategoriesModel>(
        child: Text(category.title.toString()),
        value: category,
      ));

      if (category.children != null && category.children!.isNotEmpty) {
        items.addAll(buildDropdownItems(category.children!));
      }
    }

    return items;
  }*/
  List<DropdownMenuItem<CategoriesModel>> buildDropdownItems(List<CategoriesModel> categories, {String? parentTitle}) {
    List<DropdownMenuItem<CategoriesModel>> items = [];

    for (var category in categories) {
      String label = parentTitle != null ? "$parentTitle / ${category.title}" : category.title!;
      items.add(DropdownMenuItem<CategoriesModel>(
        child: Text(label),
        value: category,
      ));

      if (category.children != null && category.children!.isNotEmpty) {
        items.addAll(buildDropdownItems(category.children!, parentTitle: category.title));
      }
    }

    return items;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: MyAppBar(
          Daimons: 122,
          title: "Add Deals",
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<List<CategoriesModel>>(
              future: fetchData(),
              builder: (BuildContext context, AsyncSnapshot<List<CategoriesModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Failed to fetch data');
                } else {
                  return DropdownButton<CategoriesModel>(
                    value: _category ?? _categorys[0],
                    items: buildDropdownItems(_categorys),
                    onChanged: (CategoriesModel? x) {
                      setState(() {
                        _category = x;
                        CategoryId = int.parse(x!.idCateg.toString());
                        //fetchFeatures(CategoryId);
                      });
                    },
                    icon: Icon(Icons.category_outlined),
                    iconEnabledColor: Colors.indigo,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),
                    borderRadius: BorderRadius.circular(10),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}


/* FutureBuilder<void>(
            future: getLikeByIdUserIdAd(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error fetching categories: ${snapshot.error}'),
                );
              } else {
                return ListView.builder(
                  itemCount: gridMap.length,
                  itemBuilder: (context, index) {
                    final e = gridMap[index];
                    return Text(
                      "${e.likeId}        ${e.nbLike} ",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                );
              }
            }),*/