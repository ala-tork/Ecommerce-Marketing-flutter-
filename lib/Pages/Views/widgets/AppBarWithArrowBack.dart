import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/messagePage.dart';
import 'package:flutter/material.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/custom_icon_button_widget.dart';
import 'package:ecommerceversiontwo/Pages/core/model/UserModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/UsersServices/UserService.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AppBarWithArrowBack extends StatefulWidget implements PreferredSizeWidget {
  final Daimons;
  final title;

  const AppBarWithArrowBack({super.key, this.Daimons = 122, this.title});

  @override
  State<AppBarWithArrowBack> createState() => _AppBarWithArrowBackState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AppBarWithArrowBackState extends State<AppBarWithArrowBack> {
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
        "${widget.title}",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 0),
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
        FutureBuilder<User>(
            future: GetUser(),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Failed to fetch data');
              } else {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 0),
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
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CustomIconButtonWidget(
            onTap: () {
            },
            value: 0,
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

/*
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
}*/
