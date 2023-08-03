import 'dart:math';

import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  const ExpandableText({Key? key, required this.text}) : super(key: key);

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  late String firstHalf;
  late String secondHalf;
  late bool isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = false;
    final textHeight = 100.0;


    if (widget.text.length > textHeight) {
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf = widget.text.substring(textHeight.toInt() + 1, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? Text(firstHalf, style: TextStyle(color: Colors.black))
          : Column(
        children: [
          Text(
            isExpanded ? (firstHalf + secondHalf) : (firstHalf + "..."),
            style: TextStyle(color: Colors.grey),
          ),
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              children: [
                Text("read ${isExpanded ? 'less' : 'more'}", style: TextStyle(color: Colors.black)),
                Transform.rotate(
                  angle: isExpanded ? pi : 0,
                  child: Icon(Icons.arrow_drop_down, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
