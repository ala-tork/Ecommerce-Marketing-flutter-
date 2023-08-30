import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/AnnouncesCRUD/EditeAnnounce.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/BoostFormPopUp.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AnnounceModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/CreateAnnounceModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/AdsFeaturesServices/AdsFeaturesService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/AnnouncesServices/AnnounceService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/ImageServices/ImageService.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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
    try {
      SharedPreferences prefs =  await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      int pagesize=4;
      Map<String, dynamic> response = await AnnounceService().GetAdsByUser(iduser, page,pagesize,token!);

      if (response["listAds"] != null) {
        List<dynamic> adsJsonList = response["listAds"];
        if (page == 0) {
          announces.clear();
          announces.addAll(
              adsJsonList.map((json) => AnnounceModel.fromJson(json)).toList());
        } else {
          announces.addAll(
              adsJsonList.map((json) => AnnounceModel.fromJson(json)).toList());
        }
        //nbr Page
        int x = response["nbitems"];
        MaxPage = x ~/ 4;
        if (x % 4 > 0) {
          MaxPage += 1;
        }
        print(announces);
        return announces;
      } else {
        print(response["ListAds"]);
        throw Exception('Failed to fetch Ads');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('An error occurred: $e');
    }
  }

  //delete announce
  void deleteItem(int id) async {
    bool imgdel = await ImageService().deleteAdsImage(id);
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

  Future<AnnounceModel> AddBost(
      AnnounceModel an, int idBoost, int AnnounceIndex) async {
    try {
      CreateAnnounce announce = CreateAnnounce(
        title: an.title,
        description: an.description,
        details: an.details,
        price: an.price,
        imagePrinciple: an.imagePrinciple,
        idCateg: an.idCateg,
        idCountrys: an.idCountrys,
        idCity: an.idCity!,
        locations: an.locations,
        IdUser: an.iduser,
        IdBoost: idBoost,
        active: 1,
      );
      an.IdBoost = idBoost;
      AnnounceModel? response =
          await AnnounceService().updateAnnouncement(an!.idAds!, announce);
      setState(() {
        announces[AnnounceIndex] = response!;
      });
      print(announces[AnnounceIndex].IdBoost);
      return response!;
    } catch (e) {
      throw Exception("faild to update Ad : $e");
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
        backgroundColor: Colors.teal[100],
        onPressed: () {
          Navigator.of(context).pushNamed("AddAnnounce").then((value) async {
            await getuserId().then((userid) async {
              List<AnnounceModel> res = await apicall(userid);
              setState(() {
                announces = res;
              });
            });
          });
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: MyAppBar(
        title: "My Announces",
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
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
                              horizontal: 0, vertical: 12),
                          child: Card(
                            color: Colors.white,
                            borderOnForeground: true,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width:
                                      announces[index].IdBoost != null ? 5 : 0,
                                  color: announces[index].IdBoost != null
                                      ? Colors.blue
                                      : Colors.black.withOpacity(0.20),
                                  //color:Colors.black.withOpacity(0.20),
                                ),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  if (announces[index].IdBoost != null)
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width,
                                      // margin: EdgeInsets.all(8),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'This Announcement is Boosted',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color:
                                                  Colors.black.withOpacity(0)),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                ApiPaths().ImagePath +
                                                    announces[index]
                                                        .imagePrinciple!),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      if (announces[index].IdBoost != null)
                                        Container(
                                          margin: EdgeInsets.all(8),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.yellow,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            'Boosted',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 10, 0, 0),
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${announces[index].title}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(
                                                  top: 2, bottom: 5, right: 10),
                                              child: Text(
                                                '${announces[index].DatePublication}',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 5, 0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${announces[index].description}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 5, 0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 2, bottom: 5),
                                          child: Text(
                                            '${announces[index].price} DT',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Poppins',
                                              color: Colors.indigo,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
                                      announces[index].IdBoost == null
                                          ? TextButton.icon(
                                              style: ButtonStyle(),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return BoostFormPopUp();
                                                  },
                                                ).then((value) {
                                                  AddBost(announces[index],
                                                      value['idBoost'], index);
                                                });
                                              },
                                              icon: Icon(
                                                Icons.flash_on,
                                                color: Colors.yellowAccent,
                                              ),
                                              label: Text(
                                                'Boost',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            )
                                          : SizedBox(
                                              height: 0,
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
                                        label: Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
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
