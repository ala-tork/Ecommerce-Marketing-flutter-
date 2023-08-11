import 'package:ecommerceversiontwo/Pages/Views/Screens/AnnouncesCRUD/EditeAnnounce.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsFeaturesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AnnounceModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/ImageModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/AdsFeaturesServices/AdsFeaturesService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/AnnouncesServices/AnnounceService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/ImageServices/ImageService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MyAnnounces extends StatefulWidget {
  const MyAnnounces({super.key});

  @override
  State<MyAnnounces> createState() => _MyAnnouncesState();
}

class _MyAnnouncesState extends State<MyAnnounces> {
  List<AnnounceModel> announces = [];
  int MaxPage = 0;
  int page = 0;

  int? idUser;

  Future<int> getuserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var decodedToken = JwtDecoder.decode(token!);
    idUser = int.parse(decodedToken['id']);
    print("id user is $idUser");
    return idUser!;
  }

//get all announces by user
  Future<List<AnnounceModel>> apicall(int iduser) async {
    print(page);
    http.Response response, nbads;
    response = await http.get(Uri.parse(
        "https://10.0.2.2:7058/api/Ads/ShowMoreByUser?iduser=${iduser}&page=${page}"));
    nbads = await http.get(Uri.parse(
        "https://10.0.2.2:7058/api/Ads/NbrAdsByUser?iduser=${iduser}"));
    if (response.statusCode == 200) {
      var responseBody = response.body;
      announces.addAll((jsonDecode(responseBody) as List)
          .map((json) => AnnounceModel.fromJson(json))
          .toList());
      //nbr Page
      int x = int.parse(nbads.body);
      MaxPage = x ~/ 4;
      if (x % 4 > 0) {
        MaxPage += 1;
      }

      return announces;
    } else {
      print(response.body);
      throw Exception('Failed to fetch data');
    }
  }

  //delete announce
  void deleteItem(int id) async {
    bool imgdel = await ImageService().deleteData(id);
    bool Af = await AdsFeaturesService().deleteData(id);
    if (imgdel && Af) {
      bool isDeleted = await AnnounceService().deleteData(id);
      if (isDeleted) {
        print("Item with ID $id deleted successfully.");
        announces.removeWhere((element) => element.idAds == id);
        setState(() {
          announces;
        });
      } else {
        print("Failed to delete item with ID $id.");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getuserId().then((value) {
      apicall(value).then((data) {
        setState(() {
          announces = data;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          Navigator.of(context).pushNamed("AddAnnounce");
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      appBar: MyAppBar(
        title: "My Announces",
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 70.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: announces.length + 1,
                    itemBuilder: (context, index) {
                      if (index < announces.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Card(
                            color: Colors.white,
                            borderOnForeground: true,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.black.withOpacity(0.20),
                                ),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    height: 200,
                                    // Set the desired height for the container
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.black.withOpacity(0)),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            'https://10.0.2.2:7058${announces[index].imagePrinciple}'),
                                        // Replace with your image path
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 10, 0, 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${announces[index].title}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 10, 0, 0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "${announces[index].description}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[500],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 2, bottom: 8),
                                          child: Text(
                                            '${announces[index].price} DT',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Poppins',
                                              color: Colors.indigo,
                                            ),
                                          ),
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(
                                                top: 2, bottom: 8,right: 10),
                                            child: Text(
                                              '${announces[index].DatePublication}',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton.icon(
                                        style: ButtonStyle(),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditeAnnounce(
                                                      announce:
                                                          announces[index]),
                                            ),
                                          )
                                              .then((value) {
                                            if (value != null && value is Map) {
                                              AnnounceModel res =
                                                  value['updatedAnnounce'];
                                              if (res != null) {
                                                setState(() {
                                                  announces.removeWhere((a) =>
                                                      res.idAds == a.idAds);
                                                  announces.add(res);
                                                });
                                              }
                                            }
                                          });
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.greenAccent,
                                        ),
                                        label: Text(
                                          'Edit',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      TextButton.icon(
                                        style: ButtonStyle(),
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.flash_on,
                                          color: Colors.yellowAccent,
                                        ),
                                        label: Text(
                                          'Boost',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      TextButton.icon(
                                        style: ButtonStyle(),
                                        onPressed: () {
                                          deleteItem(int.parse(announces[index]
                                              .idAds
                                              .toString()));
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        // Replace with your desired icon
                                        label: Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      // Add more icons as needed
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        if (announces.length != 0 && page < MaxPage - 1)
                          return ElevatedButton(
                            onPressed: () async {
                              if (page < MaxPage) {
                                setState(() {
                                  page = page + 1;
                                  getuserId().then((value) {
                                    apicall(value).then((data) {
                                      setState(() {
                                        announces = data;
                                      });
                                    });
                                  });
                                });
                              }
                            },
                            child: Text("Show More"),
                          );
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
