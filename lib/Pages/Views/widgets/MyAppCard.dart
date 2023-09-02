import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyAppCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final void Function(int)? onTap;

  MyAppCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(data["id"]);
        }
      },
      child: Container(
        width: 100,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Column(
          children: [
           /* Container(
              margin: EdgeInsets.only(bottom: 6),
              child: SvgPicture.network(
                '${ApiPaths().ImagePath}${data["image"]}',
                color: Colors.white,
              ),
            ),*/
            Flexible(
              child: Text(
                '${data["title"]}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
