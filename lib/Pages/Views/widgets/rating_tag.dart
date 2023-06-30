import 'package:ecommerceversiontwo/Pages/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RatingTag extends StatelessWidget {
  final double value;
  final double? width;
  final double? height;
  final double? textsize;
  RatingTag({required this.value,this.width=50,this.height=30,this.textsize=12});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.only(top: 4, bottom: 4, left: 5, right: 8),
      decoration: BoxDecoration(
        color: AppColor.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/Star-active.svg',
            width: 14,
            height: 14,
          ),
          SizedBox(width: 4),
          Text(
            '$value',
            style: TextStyle(
              color: Colors.white,
              fontSize: textsize,
            ),
          ),
        ],
      ),
    );
  }
}
