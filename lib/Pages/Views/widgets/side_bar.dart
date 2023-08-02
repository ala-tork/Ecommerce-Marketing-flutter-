import 'package:ecommerceversiontwo/Pages/Views/Screens/DealsCrudViews/MyDealsList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Ala Torkhani",
            style: TextStyle(
          fontSize: 18.0
      ),
            ),
            accountEmail: Text(""),
            currentAccountPicture: CircleAvatar(
              radius: 50,
              child: ClipOval(
                child: Image.asset(
                  "assets/Torkhani_Ala.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.indigo[900],
              image:  DecorationImage(
                image: NetworkImage(''),
                  fit: BoxFit.cover
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0, 5.0),
            child: ListTile(
              leading: Icon(Icons.account_circle_outlined),
              title: Text("Profile",
                style: TextStyle(
                    fontSize: 18.0
                ),
              ),
              onTap: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0, 5.0),
            child: ListTile(
              leading: Icon(Icons.shopping_bag_outlined),
              title: Text("Commande Vente",
                style: TextStyle(
                    fontSize: 18.0
                ),),
              onTap: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0, 5.0),
            child: ListTile(
              leading: Icon(Icons.shopping_cart_outlined),
              title: Text("Commande d'achat",
                style: TextStyle(
                    fontSize: 18.0
                ),),
              onTap: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0, 5.0),
            child: ListTile(
              leading: Icon(Icons.list_alt),
              title: Text("My Announces",
                style: TextStyle(
                    fontSize: 18.0
                ),),
              onTap: (){
                Navigator.of(context).pushNamed("MyDeals");
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0, 5.0),
            child: ListTile(
              leading: Icon(Icons.list_alt),
              title: Text("My Deals",
                style: TextStyle(
                    fontSize: 18.0
                ),),
              onTap: (){
                Navigator.of(context).pushNamed("MyDeals");
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0, 5.0),
            child: ListTile(
              leading: Icon(CupertinoIcons.star),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("My Favorits",
                    style: TextStyle(
                        fontSize: 18.0
                    ),
                  ),
                  SizedBox(width: 30.0,),
                  Container(
                    child:Text("12",
                      style: TextStyle(
                        color: Colors.red,
                          fontSize: 16.0
                      ),
                    ),
                  ),
                ],
              ),
              onTap: (){
                Navigator.of(context).pushNamed("WishList");
              },
            ),
          ),
          SizedBox(
            height: 100.0,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text("parametre",
                style: TextStyle(
                    fontSize: 18.0
                ),),
              onTap: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              leading: Icon(Icons.exit_to_app_outlined),
              title: Text("Déconnexion",
                style: TextStyle(
                    fontSize: 18.0
                ),),
              onTap: null,
            ),
          ),
        ],
      ),
    );
  }
}
