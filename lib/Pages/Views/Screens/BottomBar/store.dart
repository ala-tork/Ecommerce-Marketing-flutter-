import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AdsFilterModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AnnounceModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/LikesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/AnnouncesServices/AnnounceService.dart';
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
          Map<String, dynamic> response = await LikeModel().getLikeAds(id!, a.idAds!);
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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  MyAppBar(Daimons: 122,title: "Store",),
      body: Center(
        child:
        FutureBuilder<void>(
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
            }),
      ),
    );
  }
}
