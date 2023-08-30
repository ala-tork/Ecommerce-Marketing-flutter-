import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/core/model/WinnerModel/WinnerModel.dart';
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
  final WinnerModel winner;

  WinnerSlideShow({required this.winner});

  @override
  State<WinnerSlideShow> createState() => _WinnerSlideShowState();
}

class _WinnerSlideShowState extends State<WinnerSlideShow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.green, width: 4),
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
                  if(widget.winner.user!.imageUrl!=null)
                  Image.network(
                    "${ApiPaths().UserImagePath}${widget.winner.user!.imageUrl!}",
                    width: 60,
                    height: 60,
                  ),
                  if(widget.winner.user!.imageUrl==null)
                  Image.asset(
                    "assets/user.png",
                    width: 60,
                    height: 60,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "${widget.winner.user!.firstname} ${widget.winner.user!.lastname}",
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    widget.winner.prizes!.description!,
                    textAlign: TextAlign.center,
                    maxLines:2,
                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            widget.winner.dateWin!,
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

