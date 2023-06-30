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
        Image.asset(
          adsShow.ImagePrinciple,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 300,
        ),
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
      ],
    );
  }
}
