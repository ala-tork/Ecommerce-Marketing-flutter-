import 'package:flutter/material.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/profile/Body.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/profile/custombar.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/profile/enums.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/side_bar.dart';


class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: MyAppBar(
        title: "My Profile",
      ),

      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}