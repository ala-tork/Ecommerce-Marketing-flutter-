import 'package:ecommerceversiontwo/Pages/Views/widgets/rating_tag.dart';
import 'package:flutter/material.dart';
import '../../core/model/adsModel.dart';

class AdsSlideShow extends StatelessWidget {

  final AdsModel adsShow;
  AdsSlideShow({required this.adsShow});

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: <Widget>[
        Card(
          elevation: 0,
          color: Colors.white,
          borderOnForeground: true,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.black.withOpacity(0.20),
              ),
              borderRadius: BorderRadius.circular(15.0)
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 160,
                  //width: 200,// Set the desired height for the container
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(adsShow.ImagePrinciple), // Replace with your image path
                      fit: BoxFit.cover,

                    ),
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
                            '${adsShow.title}',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      /*
                              Align(
                                alignment: Alignment.centerRight,
                                child:Text(
                                  '${annonces[index]["datepub"]}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )*/
                    ],
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
                            '${adsShow.shortDescription}',
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
                  padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                  child: Row(
                    children: [
                      Text("${adsShow.price} DT",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo
                        ),
                      )
                    ],

                  ),
                ),
                SizedBox(height: 20,),

              ],
            ),
          ),
        ),
       /* Image.asset(
          adsShow.ImagePrinciple,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 300,
        ),
*/
      ],
    );
  }
}
/*
        Positioned(
          bottom: 39,
          right: 16,
          child: Text(
            adsShow.title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              backgroundColor: Colors.grey[300],
            ),
          ),
        ),
        Positioned(
            top: 5,
            right: 3,
            child: RatingTag(value: 4,width: 70.0, height: 30.0,textsize: 20,)
        ),
        Positioned(
          bottom: 14,
          right: 16,
          child: Text(
            adsShow.price.toString()+" "+"DT",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              backgroundColor: Colors.grey[300],
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: ElevatedButton(
            onPressed: (){},
            child: Text("Details"),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(Colors.blue[900]),
            ),
          ),
        ),
* */