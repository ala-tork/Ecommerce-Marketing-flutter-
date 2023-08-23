import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/BottomBar/AnnouceBottomBar/AnnounceDetails.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/BottomBar/DealsBotomBar/DealsDetails.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/DealsGiftPopUp.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AnnounceModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Deals/DealsModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/WishListModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/WishListServices/WishListService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';



class GridWishList extends StatefulWidget {
  final List<WishListModel>  data;
  const GridWishList({super.key, required this.data,});

  @override
  State<GridWishList> createState() => _GridWishListState();
}

class _GridWishListState extends State<GridWishList> {




  Future<void> DeleteFromWishList(int idWish) async {
    bool isDeleted = await WishListService().deleteFromWishList(idWish);

    if (isDeleted) {
      print("Item with ID $idWish deleted successfully.");

      setState(() {
        widget.data.removeWhere((e) => e.idwish==idWish);
      });

    } else {
      print("Failed to delete item with ID $idWish.");
    }
  }


  @override
  Widget build(BuildContext context) {

    return  GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        //mainAxisExtent: 410,
      ),
      itemCount: widget.data!.length,
      itemBuilder: (_, index) {
        if(widget.data![index].ads!=null){


           AnnounceModel? adsWishList=widget.data![index].ads;

        return

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnounceDetails(idAd: adsWishList!.idAds!,),
                ),
              );
            },
            child: Container(
              //onTap:(){},
              //width: MediaQuery.of(context).size.width / 2 - 16 - 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17.0),
                border: Border.all(
                  color: Colors.indigo,
                  width: 1.0,

                ),
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // item image
                      Container(
                        //width: MediaQuery.of(context).size.width / 0 - 0 - 0,
                        height:210,
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                              image: NetworkImage(ApiPaths().ImagePath+adsWishList!.imagePrinciple!), fit: BoxFit.cover),
                        ),
                      ),
                      // item details
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${adsWishList.title}',
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
                                    margin: EdgeInsets.only(top: 4, bottom: 8),
                                    child: Text(
                                      '${adsWishList!.DatePublication}',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                      ),
                                    )
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Expanded(
                                    child: Text(
                                      '${adsWishList.description}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 8),
                                  child: Text(
                                    '${adsWishList.price} DT',
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
                            Text(
                              '${adsWishList.locations}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),

                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              DeleteFromWishList(widget.data[index].idwish!);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                            ),
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.delete_forever),
                                SizedBox(width: 4,),
                                Text("Remove From Wishlist",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }else if (widget.data![index].deals!=null){
          DealsModel? adealsWishList=widget.data![index].deals;
          var pricewithdiscount = adealsWishList!.price! -
              ((adealsWishList!.discount! * adealsWishList!.price!) / 100);
          return

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DealsDetails(
                      //idDeals: gridMap[index].idDeal,
                      id: adealsWishList!.idDeal!,
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
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // item image
                        Container(
                          width: MediaQuery.of(context).size.width / 0 - 0 - 0,
                          height: MediaQuery.of(context).size.width / 2 - 0 - 6,
                          padding: EdgeInsets.all(5),
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                                image: NetworkImage(ApiPaths().ImagePath +
                                    adealsWishList!.imagePrinciple!),
                                fit: BoxFit.cover),
                          ),
                          child: /** Discount band */
                          adealsWishList!.discount! > 0
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
                                    '${adealsWishList!.discount}% OFF',
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
                          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${adealsWishList.title}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  if(adealsWishList.idPrize!=null)
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return DealsGiftPopUp(IdPrize: adealsWishList.idPrize,);
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
                                margin: EdgeInsets.only( bottom: 2),
                                child: Row(
                                  children: [
                                    if (adealsWishList!.discount! > 0)
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
                                    if (adealsWishList.discount! > 0)
                                      Text(
                                        '${adealsWishList.price} DT',
                                        style: TextStyle(
                                          fontSize: 16,
                                          decoration: TextDecoration.lineThrough,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    if (adealsWishList.discount! > 0)
                                      Text(
                                        '(${adealsWishList.discount}% off)',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                        ),
                                      ),
                                    if (adealsWishList.discount! == null)
                                      Text(
                                        "${adealsWishList.price} DT",
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
                                    'available until: ${adealsWishList.dateEND}',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.green,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'quantity : ${adealsWishList.quantity}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '${adealsWishList.locations}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text("Quantite vendue ")],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LinearPercentIndicator(
                                    width: MediaQuery.of(context).size.width - 100,
                                    animation: true,
                                    lineHeight: 10.0,
                                    animationDuration: 1500,
                                    percent: 0.8,
                                    barRadius: Radius.circular(10),
                                    progressColor: Colors.indigo,
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                DeleteFromWishList(widget.data[index].idwish!);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                onPrimary: Colors.white,
                              ),
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.delete_forever),
                                  SizedBox(width: 4,),
                                  Text("Remove From Wishlist",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
        }else{
          return Center(
            child: Text("Wish List Is Empty"),
          );
        }
      },
    );

  }
}