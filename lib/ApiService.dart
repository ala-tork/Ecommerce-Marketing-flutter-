import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerceversiontwo/Pages/Views/Screens/LoginPage.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/OTPVerificationPage.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/pageSwitcher.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://10.0.2.2:7058';

  static Future<bool> login(BuildContext context, String email, String password) async {
    var url = Uri.parse("$baseUrl/User/login");
    var response = await http.post(
      url,
      headers: <String, String>{"Content-Type": "application/json"},
      body: jsonEncode(<String, String>{
        "email": email,
        "password": password,
      }),
    );
  //  print("${response.statusCode}");

    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter both email and password.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    } else {
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Login successful.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );

        // Parse the response body
        var responseBody = jsonDecode(response.body);
        var token = responseBody['token'];
        var decodedToken = JwtDecoder.decode(token);
        var email = decodedToken['email'];
        String active = decodedToken['active'];
        int isActive = int.parse(active);

        var refreshToken = decodedToken['refreshToken'];
        print("$refreshToken");

        var id = decodedToken['id'];
        int userId = int.parse(id);
        print("id $userId");
        print(token);
        if (isActive == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerificationPage(token: token),
            ),
          );
        } else {
          var userRole = decodedToken['role'];

          if (userRole == "User") {
            print(userRole);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PageSwitcher(token: token),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          }
        }
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('refreshToken', refreshToken);

        return true;
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Invalid email or password.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
    return false;
  }

  static Future<bool> refreshToken(String refreshToken) async {
    var url = Uri.parse("$baseUrl/User/refresh-token?refreshToken=$refreshToken");
    print("url $url");
    var response = await http.post(
      url,
      headers: <String, String>{"Content-Type": "application/json"},
    );

    print("refresh token ${response.statusCode}");
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var token = responseBody['token'];

      var refreshToken = responseBody['refreshToken'];
      print("the new refresh token $refreshToken");

      if (token != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('refreshToken', refreshToken);

        return true; // Refresh token successful
      }
    }

    return false; // Refresh token failed
  }

}



