import 'package:flutter/material.dart';

import '../widgets/custom_icon_button_widget.dart';
import 'messagePage.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Daimons;
  final title;
  const MyAppBar({super.key, this.Daimons, this.title});


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
      title: Text("${widget.title}"),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5.0, 5.0, 0),
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
          padding: const EdgeInsets.fromLTRB(0, 5.0, 15.0, 0),
          child: CustomIconButtonWidget(
            onTap: () {},
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
