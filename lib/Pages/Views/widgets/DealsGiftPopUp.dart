import 'package:ecommerceversiontwo/Pages/app_color.dart';
import 'package:flutter/material.dart';

class DealsGiftPopUp {
  void showDialogFunc(BuildContext context, String EndDate) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    spreadRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(20),
              height: 600,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  Text(
                    "The Big Price PC GAMER SKY 360 V1",
                    style: TextStyle(
                      fontSize: 30,
                      color: AppColor.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      "https://i0.wp.com/skymedia.tn/wp-content/uploads/2022/06/5849.png?fit=1410%2C1182&ssl=1",
                      width: 300,
                      height: 250,
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    //width: 220,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Buy now and enter a draw for a gaming computer with a value of 5889 DT. The offer is available until : \n $EndDate",
                        //maxLines: 3,
                        style: TextStyle(fontSize: 20, color: AppColor.primary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
