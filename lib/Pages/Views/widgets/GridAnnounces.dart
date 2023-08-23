import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/BottomBar/AnnouceBottomBar/AnnounceDetails.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AdsViewModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AnnounceModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/LikesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/WishListModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/LikeServices/LikeService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/WishListServices/WishListService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class GridB extends StatefulWidget {
  final  data;
  final int IdUser;

  const GridB({Key? key,required this.data, required this.IdUser});

  @override
  State<GridB> createState() => _GridBState();
}

class _GridBState extends State<GridB> {
  List gridMap=[];
  @override
  void initState() {
    gridMap = widget.data;
    //print(gridMap[0].idLike);
    super.initState();
  }
  /** Add And Delete like */
  Future<void> deleteLike(int idLike, int idAds) async {
    bool isDeleted = await LikeService().deleteLike(idLike);

    if (isDeleted) {
      print("Item with ID $idLike deleted successfully.");

      AnnounceModel? foundAd;

      for (AdsView ad in gridMap) {
        if (ad.idAds == idAds) {
          setState(() {
            ad.idLike=null;
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
      LikeModel newLike = await LikeService().addLike(like);
      if (newLike != null) {
        print("Like added successfully.");

        for (AdsView ad in gridMap) {
          if (ad.idAds == idAds) {
            setState(() {
              ad.idLike = newLike.idLP;
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


  /** add and delete from wishlist */

  Future<void> DeleteFromWishList(int idWish, int idAd) async {
    bool isDeleted = await WishListService().deleteFromWishList(idWish);

    if (isDeleted) {
      print("Item with ID $idWish deleted successfully.");

      for (AdsView ad in gridMap) {
        if (ad.idAds == idAd) {
          setState(() {
            ad.idWishList = null;
          });

          break;
        }
      }
    } else {
      print("Failed to delete item with ID $idWish.");
    }
  }

  Future<void> AddToWishList(int idUser, int idAd) async {
    WishListModel NewWish = WishListModel(idUser: idUser,idAd: idAd);

    try {

      WishListModel wish = await WishListService().AddAnnouceToWishList(NewWish);

      if (wish != null) {
        print("Deals added successfully.");

        for (AdsView ad in gridMap) {
          if (ad.idAds == idAd) {
            setState(() {
              ad.idWishList = wish.idwish;
            });
            break;
          }
        }
      } else {
        print("Failed to add to WishList.");
      }
    } catch (e) {
      print("Error adding WishList: $e");
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
                builder: (context) => AnounceDetails(idAd: gridMap[index].idAds,),
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
                        image: NetworkImage(ApiPaths().ImagePath+gridMap[index].imagePrinciple), fit: BoxFit.cover),
                  ),
                ),
                // item details
                Container(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${gridMap[index].title}',
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
                              margin: EdgeInsets.only(top: 2, bottom: 8),
                              child: Text(
                                '${gridMap[index].datePublication}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              )
                          ),
                        ],
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
                                  if (gridMap[index].idLike == null) {
                                    addLike(widget.IdUser,gridMap[index].idAds );
                                  } else {
                                    deleteLike(gridMap[index].idLike, gridMap[index].idAds);

                                  }
                                },
                                icon: gridMap[index].idLike == null
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
                                  if (gridMap[index].idWishList == null) {
                                    AddToWishList(
                                        widget.IdUser, gridMap[index].idAds);
                                  } else {
                                    DeleteFromWishList(gridMap[index].idWishList,
                                        gridMap[index].idAds);
                                  }
                                },
                                icon: gridMap[index].idWishList == null
                                    ? Icon(CupertinoIcons.star)
                                    : Icon(
                                  CupertinoIcons.star_fill,
                                  color: Colors.amber,
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



