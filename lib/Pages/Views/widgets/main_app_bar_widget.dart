
import 'package:ecommerceversiontwo/Pages/Views/Screens/CartPage.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/messagePage.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/searchPage.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/custom_icon_button_widget.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/dummy_search_widget2.dart';
import 'package:ecommerceversiontwo/Pages/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  final int cartValue;
  final int chatValue;

  MainAppBar({
    required this.cartValue,
    required this.chatValue,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  _MainAppBarState createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      backgroundColor: AppColor.primary,
      elevation: 0,
      title: Row(
        children: [
          DummySearchWidget2(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SearchPage(),
                ),
              );
            },
          ),
          CustomIconButtonWidget(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartPage()));
            },
            value: widget.cartValue,
            icon: SvgPicture.asset(
              'assets/icons/Bag.svg',
              color: Colors.white,
            ),
          ),
          CustomIconButtonWidget(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => MessagePage()));
            },
            value: widget.chatValue,
            icon: SvgPicture.asset(
              'assets/icons/Chat.svg',
              color: Colors.white,
            ),
          ),
        ],
      ), systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }
}