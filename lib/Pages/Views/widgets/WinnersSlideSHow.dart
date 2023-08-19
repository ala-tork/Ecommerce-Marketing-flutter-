import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:flutter/material.dart';

class Winner {
  final String name;
  final String avatar;
  final String prizeDescription;
  final String date;

  Winner({
    required this.name,
    required this.avatar,
    required this.prizeDescription,
    required this.date,
  });
}

class WinnerSlideShow extends StatefulWidget {
  final Winner winner;

  WinnerSlideShow({required this.winner});

  @override
  State<WinnerSlideShow> createState() => _WinnerSlideShowState();
}

class _WinnerSlideShowState extends State<WinnerSlideShow> {
  @override
  Widget build(BuildContext context) {
    return /*ListTile(
      tileColor: Colors.blueGrey,
      leading: Image.asset(
        widget.winner.avatar,
        width: 100,
        height: 100,
      ),
      title: Text(
        widget.winner.name,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.winner.prizeDescription,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Date: ${widget.winner.date}",
            style: TextStyle(
              fontSize: 16,
              color: Colors.green,
            ),
          ),
        ],
      ),
      isThreeLine: true,
    );*/


      Container(
      decoration: BoxDecoration(
        color:Colors.white, //Colors.blue[600],
        border: Border.all(color: Colors.green , width: 4),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Column(
                children: [
                  Image.asset(
                    widget.winner.avatar,
                    width: 60,
                    height: 60,
                  ),
                  SizedBox(height: 12,),
                  Text(
                    widget.winner.name,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Expanded(
                flex: 3,
                child: Text(
                  widget.winner.prizeDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          Text(
            widget.winner.date,
            style: TextStyle(
              fontSize: 16,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
