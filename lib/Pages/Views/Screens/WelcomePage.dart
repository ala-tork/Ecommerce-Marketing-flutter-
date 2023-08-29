import 'package:ecommerceversiontwo/ApiService.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/LandingPage.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/LoginPage.dart';
import 'package:ecommerceversiontwo/Pages/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Future<void> checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      var decodedToken = JwtDecoder.decode(token);
      String refresh = decodedToken['refreshToken'];
      var res = await ApiService.refreshToken(refresh!);

      if (res==true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>LandingPage() /*PageSwitcher(token: token)*/),
        );
      } else {
        //return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    }else{
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()));
  }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Section 1 - Illustration
            Container(
              margin: EdgeInsets.only(top: 32),
              width: MediaQuery.of(context).size.width,
              child: SvgPicture.asset('assets/icons/shopping illustration.svg'),
            ),
            // Section 2 - Marketky with Caption
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'ADS',
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                      fontFamily: 'poppins',
                    ),
                  ),
                ),
                Text(
                  'Market in your pocket. Find \nyour best outfit here.',
                  style: TextStyle(color: AppColor.secondary.withOpacity(0.7), fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            // Section 3 - Get Started Button
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 16),
              margin: EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                onPressed: () async {
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
                  await checkLoggedIn();
                },
                child: Text(
                  'Get Started',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18, fontFamily: 'poppins'),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 18), backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
