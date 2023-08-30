import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/messagePage.dart';
import 'package:flutter/material.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/custom_icon_button_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AppBarWithArrowBack extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppBarWithArrowBack({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.indigo,
      title: Text(
        "$title",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5.0, 5.0, 0),
          child: CustomIconButtonWidget(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MessagePage(),
              ));
            },
            value: 2,
            icon: Icon(
              Icons.mark_unread_chat_alt_outlined,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5.0, 15.0, 0),
          child: CustomIconButtonWidget(
            onTap: () {
              AwesomeDialog(
                context: context,
                dialogBackgroundColor: Colors.indigo,
                dialogType: DialogType.INFO,
                animType: AnimType.TOPSLIDE,
                title: "Diamond",
                descTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                desc: "Hello, welcome to ADS & Deals.\n\nWhat are diamonds?!\nDiamonds are the currency within our application.\nWith diamonds, you can add your products to the application and enhance their visibility. If you would like to refill your wallet and purchase diamonds, please click OK",
                btnCancelColor: Colors.grey,
                btnCancelOnPress: () {},
                btnOkOnPress: () {},
              ).show();
            },
            value: 122,
            icon: Icon(
              Icons.diamond_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
