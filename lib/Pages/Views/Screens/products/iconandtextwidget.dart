import 'package:flutter/material.dart';

class IconAndTextWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final Color TextColor;




  const IconAndTextWidget({Key? key,
    required this.icon,
    required this.text,
    required this.iconColor,
    required this.TextColor

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,color: iconColor,),
        SizedBox(width: 5,),
        Text(text,style: TextStyle(color: TextColor),),

      ],
    );
  }
}
