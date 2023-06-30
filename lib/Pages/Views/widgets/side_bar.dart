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
              child: ClipOval(
                child: Image.asset(
                  "assets/Torkhani_Ala.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              image:  DecorationImage(
                image: NetworkImage(''),
                  fit: BoxFit.cover
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 15.0, 0, 7.0),
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
            padding: const EdgeInsets.fromLTRB(18.0, 5.0, 0, 7.0),
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
            padding: const EdgeInsets.fromLTRB(18.0, 5.0, 0, 7.0),
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
            padding: const EdgeInsets.fromLTRB(18.0, 5.0, 0, 7.0),
            child: ListTile(
              leading: Icon(Icons.list_alt),
              title: Text("My Announces",
                style: TextStyle(
                    fontSize: 18.0
                ),),
              onTap: (){
                Navigator.of(context).pushNamed("MyAnnounces");
              },
            ),
          ),
          SizedBox(
            height: 150.0,
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