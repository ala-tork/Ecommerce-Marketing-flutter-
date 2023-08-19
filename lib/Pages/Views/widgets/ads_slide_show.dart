import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/BottomBar/AnnouceBottomBar/AnnounceDetails.dart';
import 'package:flutter/material.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/BottomBar/DealsBotomBar/DealsDetails.dart';
import 'package:ecommerceversiontwo/Pages/core/model/BostSlideShowModels/BoostSlideShowModel.dart';

class AdsSlideShow extends StatelessWidget {
  final BoostSlideShowModel ads_deals;

  AdsSlideShow({required this.ads_deals});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (ads_deals.itemType == "Deal") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DealsDetails(id: ads_deals.deals!.idDeal!),
            ),
          );
        } else if (ads_deals.itemType == "Ad") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnounceDetails(idAd: ads_deals.ads!.idAds!),
            ),
          );
        }
      },
      child: Card(
        elevation: 0,
        color: Colors.white,
        borderOnForeground: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 160,
                padding: EdgeInsets.all(10),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        ApiPaths().ImagePath + ads_deals.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ads_deals.discount != null && ads_deals.discount! > 0
                    ? Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        topRight: Radius.circular(17),
                      ),
                    ),
                    child: Text(
                      '${ads_deals.discount}% OFF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                    : SizedBox(
                  height: 0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${ads_deals.title}',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2, bottom: 8, right: 10),
                      child: Text(
                        '${ads_deals.datePublication}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 2, bottom: 8, left: 18),
                child: Row(
                  children: [
                    Text(
                      '${ads_deals.price} DT',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                        color: Colors.indigo,
                      ),
                    ),
                    SizedBox(width: 8),
                    if (ads_deals.discount != null && ads_deals.discount! > 0)
                      Text(
                        '${ads_deals.price! + ((ads_deals.discount! * ads_deals.price!) / 100)} DT',
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                    if (ads_deals.discount != null && ads_deals.discount! > 0)
                      Text(
                        '(${ads_deals.discount}% off)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
