import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/BottomBar/AnnouceBottomBar/AnnounceDetails.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/BottomBar/DealsBotomBar/DealsDetails.dart';
import 'package:ecommerceversiontwo/Pages/core/model/BostSlideShowModels/BoostSlideShowModel.dart';
import 'package:flutter/material.dart';

class BoostedSlide {
  void showDialogFunc(BuildContext context, List<BoostSlideShowModel> deals) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 360,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.indigo, width: 5),
                ),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height - 0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    pauseAutoPlayOnTouch: true,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1.0,
                  ),
                  items: deals.map((adsShow) {
                    return Stack(

                      children: <Widget>[
                        GestureDetector(
                          onTap:(){
                            if(adsShow.itemType=="Deal"){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DealsDetails(id: adsShow.deals!.idDeal!,),
                                ),
                              );
                            }
                              if(adsShow.itemType=="Ad"){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AnounceDetails(idAd: adsShow.ads!.idAds!,),
                                ),
                              );
                            }

                          },
                          child: Card(
                            elevation: 0,
                            color: Colors.transparent,
                            borderOnForeground: true,
                            child: SingleChildScrollView(
                              child: Column(
                                //mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    height: MediaQuery.of(context).size.height - 500,
                                    padding: EdgeInsets.all(10),
                                    alignment: Alignment.topLeft,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            ApiPaths().ImagePath + adsShow.imageUrl!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: /** Discount band */
                                    adsShow.discount!=null && adsShow.discount! > 0
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
                                          '${adsShow.discount}% OFF',
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
                                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${adsShow.title}',
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        adsShow.itemType=="Ad"?
                                        Container(
                                            margin: EdgeInsets.only(top: 2, bottom: 8),
                                            child: Text(
                                              '${adsShow.datePublication}',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15,
                                              ),
                                            )
                                        ):SizedBox(height: 0,),
                                      ],
                                    ),
                                  ),
                                  adsShow.itemType=="Ad"?
                                 Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${adsShow.ads!.details!}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ):SizedBox(height: 0,),
                                  Container(
                                    margin: EdgeInsets.only(top: 2, bottom: 8, left: 8),
                                    child: Row(
                                      children: [
                                        Text(
                                          '${adsShow.price} DT',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Poppins',
                                            color: Colors.indigo,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        if (adsShow.discount!=null && adsShow.discount! > 0)
                                          Text(
                                            '${ adsShow.price! + ((adsShow.discount! * adsShow.price!) / 100)} DT',
                                            style: TextStyle(
                                              fontSize: 16,
                                              decoration: TextDecoration.lineThrough,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        if (adsShow.discount!=null &&  adsShow.discount! > 0)
                                          Text(
                                            '(${adsShow.discount}% off)',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.green,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  adsShow.itemType=="Deal"?
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'available until: ${adsShow.dateEND}',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.green,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ):SizedBox(height: 0,),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
