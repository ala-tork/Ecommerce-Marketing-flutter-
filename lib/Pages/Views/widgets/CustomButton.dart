import 'package:flutter/material.dart';

Widget CostumButton({required String title, required IconData iconName, required VoidCallback onClick}){
  return Container(
    width: 280,
    child: ElevatedButton(
      onPressed: onClick,
      child: Container(

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconName),
            SizedBox(width: 20,),
            Text(title),
          ],
        ),
      ),
    ),
  );
}