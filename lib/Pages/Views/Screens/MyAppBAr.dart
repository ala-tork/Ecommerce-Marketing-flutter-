import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_icon_button_widget.dart';
import 'messagePage.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Daimons;
  final title;
  const MyAppBar({super.key, this.Daimons=122, this.title});


  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {


  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.indigo,
      title: Text("${widget.title}",
      style: TextStyle(
          color: Colors.white
      ),
      ),
      centerTitle: true,

      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5.0, 0.0, 0),
          child: CustomIconButtonWidget(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MessagePage()));
            },
            value: 2,
            icon: Icon(
              Icons.mark_unread_chat_alt_outlined,
              color:Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5.0, 5.0, 0),
          child: CustomIconButtonWidget(
            onTap: () {
              AwesomeDialog(
                  context: context,
                  dialogBackgroundColor: Colors.teal[100],
                  dialogType: DialogType.info,
                  animType: AnimType.topSlide,
                  title:"Diamond",
                  descTextStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                  desc: "Hello, welcome to ADS & Deals.\n \n What are diamonds?!\n Diamonds are the currency within our application.\n With diamonds, you can add your products to the application and enhance their visibility. If you would like to refill your wallet and purchase diamonds, please click OK",
                  btnCancelColor: Colors.grey,
                  btnCancelOnPress:(){},

                  btnOkOnPress: (){}
              ).show();
            },
            value: widget.Daimons,

            icon: Icon(
              Icons.diamond_outlined,
              color:Colors.white,
            ),

          ),
        ),
      ],
    );
  }
}
