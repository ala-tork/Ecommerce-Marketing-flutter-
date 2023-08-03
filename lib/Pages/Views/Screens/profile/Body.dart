import 'package:flutter/material.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/profile/ChangePassword.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/profile/profilepic.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'ProfileDetails.dart';
import 'profile_menu.dart';

class Body extends StatelessWidget {

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    print("******************************** ${prefs.getString('token')}");
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            iconData:Icons.supervised_user_circle_outlined,
            press: () async {
            String? token = await _getAuthToken();
            if (token != null) {

            Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => ProfileDetails(token: token),
            ),
            );
            }
            },
          ),
          ProfileMenu(
            text: 'Change Password',
            iconData:Icons.supervised_user_circle_outlined,
            press: () async {
              String? token = await _getAuthToken();
              if (token != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdatePasswordPage(token: token),
                  ),
                );
              }
            },
          ),
          ProfileMenu(
            text: "Settings",
            iconData:Icons.supervised_user_circle_outlined,
            press: () {},
          ),
          ProfileMenu(
            text: "Help Center",
            iconData:Icons.supervised_user_circle_outlined,
            press: () {},
          ),
          ProfileMenu(
            text: 'Logout',
            iconData: Icons.logout,
            press: () {
              // Do something when "Logout" is pressed
            },
          ),  ],
      ),
    );
  }
}