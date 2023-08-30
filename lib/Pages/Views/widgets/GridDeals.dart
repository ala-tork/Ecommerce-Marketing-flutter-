import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/BottomBar/DealsBotomBar/DealsDetails.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/DealsGiftPopUp.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Deals/DealsView.dart';
import 'package:ecommerceversiontwo/Pages/core/model/LikesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/WishListModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/LikeServices/LikeService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/WishListServices/WishListService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class GridDeals extends StatefulWidget {
  final data;
  final int IdUser;

  const GridDeals({
    super.key,
    required this.data,
    required this.IdUser,
  });

  @override
  State<GridDeals> createState() => _GridDealsState();
}

class _GridDealsState extends State<GridDeals> {
  List gridMap = [];

  @override
  void initState() {
    gridMap = widget.data;
    super.initState();
  }

  /** Add And Delete Like*/
  Future<void> deleteLike(int idLike, int idDeal) async {
    bool isDeleted = await LikeService().deleteLike(idLike);

    if (isDeleted) {
      print("Item with ID $idLike deleted successfully.");

      for (DealsView ad in gridMap) {
        if (ad.idDeal == idDeal) {
          setState(() {
            ad.idLike = null;
            ad.nbLike = ad.nbLike! - 1;
          });

          break;
        }
      }
    } else {
      print("Failed to delete item with ID $idLike.");
    }
  }

  Future<void> addLike(int idUser, int idDeal) async {
    LikeModel like = LikeModel(idUser: idUser, idDeal: idDeal);

    try {
      LikeModel newLike = await LikeService().addLike(like);

      if (newLike != null) {
        print("Like added successfully.");

        for (DealsView ad in gridMap) {
          if (ad.idDeal == idDeal) {
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

  /** Add And Delete From WishList */

  Future<void> DeleteFromWishList(int idWish, int idDeal) async {
    bool isDeleted = await WishListService().deleteFromWishList(idWish);

    if (isDeleted) {
      print("Item with ID $idWish deleted successfully.");

      for (DealsView ad in gridMap) {
        if (ad.idDeal == idDeal) {
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

  Future<void> AddToWishList(int idUser, int idDeal) async {
    WishListModel NewWish = WishListModel(idUser: idUser,idDeal: idDeal);

    try {

      WishListModel wish = await WishListService().AddAnnouceToWishList(NewWish);

      if (wish != null) {
        print("Deals added successfully.");

        for (DealsView ad in gridMap) {
          if (ad.idDeal == idDeal) {
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
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        mainAxisExtent: 450,
      ),
      itemCount: gridMap.length,
      itemBuilder: (_, index) {
        var pricewithdiscount = gridMap[index].price -
            ((gridMap[index].discount * gridMap[index].price) / 100);
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DealsDetails(
                  //idDeals: gridMap[index].idDeal,
                  id: gridMap[index].idDeal,
                ),
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
                  height: MediaQuery.of(context).size.width / 2 - 0 - 6,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                        image: NetworkImage(ApiPaths().ImagePath +
                            gridMap[index].imagePrinciple),
                        fit: BoxFit.cover),
                  ),
                  child: /** Discount band */
                      gridMap[index].discount > 0
                          ? Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          topRight: Radius.circular(17)),
                                    ),
                                    child: Text(
                                      '${gridMap[index].discount}% OFF',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(
                              height: 0,
                            ),
                ),

                // item details
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
                          if(gridMap[index]!.idPrize!=null)
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return DealsGiftPopUp(IdPrize: gridMap[index]!.idPrize,);
                                },
                              );
                            },
                            child: Image.asset(
                              "assets/prize.webp",
                              height: 40,
                              width: 40,
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 2, bottom: 8),
                        child: Row(
                          children: [
                            if (gridMap[index].discount! > 0)
                              Text(
                                "$pricewithdiscount DT",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
                                  color: Colors.indigo,
                                ),
                              ),
                            SizedBox(width: 8),
                            if (gridMap[index].discount! > 0)
                              Text(
                                '${gridMap[index].price} DT',
                                style: TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                            if (gridMap[index].discount! > 0)
                              Text(
                                '(${gridMap[index].discount}% off)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                ),
                              ),
                            if (gridMap[index].discount! == 0)
                              Text(
                                "${gridMap[index].price} DT",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
                                  color: Colors.indigo,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${AppLocalizations.of(context)!.available_until}: ${gridMap[index].dateEND}',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.green,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            maxLines: 1,
                            '${AppLocalizations.of(context)!.quantity} : ${gridMap[index].quantity}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${gridMap[index].locations}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (gridMap[index].idLike == null) {
                                    addLike(
                                        widget.IdUser, gridMap[index].idDeal);
                                  } else {
                                    deleteLike(gridMap[index].idLike,
                                        gridMap[index].idDeal);
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
                                        widget.IdUser, gridMap[index].idDeal);
                                  } else {
                                    DeleteFromWishList(gridMap[index].idWishList,
                                        gridMap[index].idDeal);
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${AppLocalizations.of(context)!.sold_out_of} ${gridMap[index].quantity} ",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500
                          ),)
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width - 50,
                            animation: true,
                            lineHeight: 10.0,
                            animationDuration: 700,
                            percent: 0.8,
                            barRadius: Radius.circular(10),
                            progressColor: Colors.indigo,
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
