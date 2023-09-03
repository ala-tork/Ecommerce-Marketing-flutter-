import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommerceversiontwo/Pages/core/model/UserModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/UsersServices/UserService.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'custom_icon_button_widget.dart';
import '../Screens/messagePage.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final title;

  const MyAppBar({super.key, this.title});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  /** User  */
  User? user;
  int? idUser;

  Future<int> getuserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var decodedToken = JwtDecoder.decode(token!);
    idUser = int.parse(decodedToken['id']);
    print("id user is $idUser");
    return idUser!;
  }

  Future<User> GetUser() async {
    int id = await getuserId();
    user = await UserService().GetUserByID(id);
    if (user != null) {
      return user!;
    } else {
      throw Exception("user Not Found !");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.indigo,
      title: Text(
        "${widget.title}",
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5.0, 0.0, 0),
          child: CustomIconButtonWidget(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MessagePage()));
            },
            value: 2,
            icon: Icon(
              Icons.mark_unread_chat_alt_outlined,
              color: Colors.white,
            ),
          ),
        ),
        FutureBuilder<User>(
            future: GetUser(),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Failed to fetch data');
              } else {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5.0, 5.0, 0),
                  child: CustomIconButtonWidget(
                    onTap: () {
                      AwesomeDialog(
                              context: context,
                              dialogBackgroundColor: Colors.teal[100],
                              dialogType: DialogType.info,
                              animType: AnimType.topSlide,
                              title: "Diamond",
                              descTextStyle: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              desc:
                                  "Hello, welcome to ADS & Deals.\n \n What are diamonds?!\n Diamonds are the currency within our application.\n With diamonds, you can add your products to the application and enhance their visibility. If you would like to refill your wallet and purchase diamonds, please click OK",
                              btnCancelColor: Colors.grey,
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {})
                          .show();
                    },
                    value: user!.nbDiamon!,
                    icon: Icon(
                      Icons.diamond_outlined,
                      color: Colors.white,
                    ),
                  ),
                );
              }
            }),
      ],
    );
  }
}
