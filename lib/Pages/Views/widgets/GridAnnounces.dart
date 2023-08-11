import 'package:ecommerceversiontwo/Pages/Views/Screens/BottomBar/AnnouceBottomBar/AnnounceDetails.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/modals/add_to_cart.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AnnounceModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/LikesModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GridB extends StatefulWidget {
  final  data;
  final int IdUser;
  //final Function(int index) onRemoveLike;
 // final Function(int index) onCreateLike;
 // const GridB({Key? key, required this.data, required this.onRemoveLike, required this.onCreateLike})
  //    : super(key: key);
  const GridB({Key? key,required this.data, required this.IdUser});

  @override
  State<GridB> createState() => _GridBState();
}

class _GridBState extends State<GridB> {
  List gridMap=[];
  @override
  void initState() {
    // TODO: implement initState
    gridMap = widget.data;
    print(gridMap[0].likeId);
    super.initState();
  }
  Future<void> deleteLike(int idLike, int idAds) async {
    bool isDeleted = await LikeModel().deleteLike(idLike);

    if (isDeleted) {
      print("Item with ID $idLike deleted successfully.");

      AnnounceModel? foundAd;

      for (AnnounceModel ad in gridMap) {
        if (ad.idAds == idAds) {
          setState(() {
            ad.likeId=null;
            ad.nbLike= ad.nbLike!-1;
          });

          break;
        }
      }
    } else {
      print("Failed to delete item with ID $idLike.");
    }
  }

  Future<void> addLike(int idUser, int idAds) async {
    LikeModel like = LikeModel(idUser: idUser, idAd: idAds);

    try {
      LikeModel newLike = await like.addLike(like);
      AnnounceModel? foundAd;

      if (newLike != null) {
        print("Like added successfully.");

        for (AnnounceModel ad in gridMap) {
          if (ad.idAds == idAds) {
            setState(() {
              ad.likeId = newLike.idLP;
              ad.nbLike = (ad.nbLike ?? 0) + 1;
            });
            break;
          }
        }

      } else {
        print("Failed to add Like.");
      }
    } catch (e) {
      print("Error adding Like: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    return
      GridView.builder(

      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2 ,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        mainAxisExtent: 330,
      ),
      itemCount: gridMap.length,
      itemBuilder: (_, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AnounceDetails(Announce: gridMap[index],),
              ),
            );
          },
          child: Container(
            //onTap:(){},
            width: MediaQuery.of(context).size.width / 2 - 16 - 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17.0),
              border: Border.all(
                color: Colors.indigo,
                width: 1.0,

              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // item image
                Container(
                  width: MediaQuery.of(context).size.width / 0 - 0 - 0,
                  height: MediaQuery.of(context).size.width / 2 - 0 - 26,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                        image: NetworkImage("https://10.0.2.2:7058"+gridMap[index].imagePrinciple), fit: BoxFit.cover),
                  ),
                ),
                // item details
                Container(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${gridMap[index].title}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 2, bottom: 8),
                            child: Text(
                              '${gridMap[index].price} DT',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 2, bottom: 8),
                            child: Text(
                              '${gridMap[index].DatePublication}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            )
                          ),
                        ],
                      ),
                      Text(
                        '${gridMap[index].locations}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (gridMap[index].likeId == null) {
                                    addLike(widget.IdUser,gridMap[index].idAds );
                                  } else {
                                    deleteLike(gridMap[index].likeId, gridMap[index].idAds);

                                  }
                                },
                                icon: gridMap[index].likeId == null
                                    ? Icon(CupertinoIcons.heart)
                                    : Icon(
                                  CupertinoIcons.heart_fill,
                                  color: Colors.red,
                                ),
                              ),
                              Text("${gridMap[index].nbLike}")
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                 // AddToCartModal();
                                },
                                icon: Icon(
                                  CupertinoIcons.star,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}



