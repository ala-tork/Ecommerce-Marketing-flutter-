import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/products/productList.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/profile/profileScreen.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  String? token; // Declare the token variable
  String firstname='';
  @override
  void initState() {
    super.initState();
    _loadAuthToken();


  }

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
    var decodedToken = JwtDecoder.decode(token!);
    firstname = decodedToken['firstname'] ?? '';

  }

  @override
  Widget build(BuildContext context) {
    if (token != null) {
      var decodedToken = JwtDecoder.decode(token!);
      String id = decodedToken['id'] ?? '';
    }

    Future<String?> _getAuthToken() async {
      final prefs = await SharedPreferences.getInstance();
      print("******************************** ${prefs.getString('token')}");
      return prefs.getString('token');

    }


    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

          UserAccountsDrawerHeader(
            accountName: Text(
              "${firstname}",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            accountEmail: Text(""),
            currentAccountPicture: CircleAvatar(
              radius: 50,
              child: ClipOval(
                child: Image.asset(
                  "assets/images/as.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.indigo[900],
              image: DecorationImage(
                image: NetworkImage(''),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle_outlined),
            title: Text(
              "Profile",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag_outlined),
            title: Text(
              "Commande Vente",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart_outlined),
            title: Text(
              "Commande d'achat",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text(
              "My Announces",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed("MyAnnounces");
            },
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text(
              "My Products",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductList(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.star),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "My Favorits",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(width: 30.0),
                Container(
                  child: Text(
                    "12",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).pushNamed("WishList");
            },
          ),
          SizedBox(height: 100.0),
          SizedBox(height: 150.0),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              "parametre",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app_outlined),
            title: Text(
              "Déconnexion",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
