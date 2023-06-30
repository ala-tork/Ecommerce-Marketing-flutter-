
import 'package:ecommerceversiontwo/Pages/app_color.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Search.dart';
import 'package:flutter/material.dart';

import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
class SearchHistoryTile extends StatelessWidget {
  SearchHistoryTile({required this.data, required this.onTap});

  final SearchHistory data;
  final void Function()? onTap; // Update the type of onTap parameter

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: AppColor.primarySoft,
              width: 1,
            ),
          ),
        ),
        child: Text('${data.title}'),
      ),
    );
  }
}