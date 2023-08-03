import 'package:flutter/material.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/profile/profileScreen.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/side_bar.dart';
import 'package:ecommerceversiontwo/Pages/app_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdatePasswordPage extends StatefulWidget {
  final String token;

  UpdatePasswordPage({required this.token});

  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _retypePasswordController = TextEditingController();

  String _currentPassword = '';
  String _newPassword = '';
  String _retypePassword = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: SideBar(),
      appBar: MyAppBar(Daimons: 122, title: "Update Password"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Current Password'),
              onChanged: (value) {
                setState(() {
                  _currentPassword = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'New Password'),
              onChanged: (value) {
                setState(() {
                  _newPassword = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _retypePasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Retype New Password'),
              onChanged: (value) {
                setState(() {
                  _retypePassword = value;
                });
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                backgroundColor: AppColor.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              onPressed: () {
                _updatePassword();
              },
              child: Text('Update Password'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to update the password using the API
  void _updatePassword() async {
    if (_currentPassword.isNotEmpty && _newPassword.isNotEmpty && _retypePassword.isNotEmpty) {
      if (_newPassword == _retypePassword) {
        try {
          print("ddddddddddddddddddddddddddddddddddddddddddd ${_currentPassword}");

          print("fffffffffffffffffffffffffffffffffffffffffffffffffffffffff ${_newPassword}");
          final response = await http.put(
            Uri.parse('http://10.0.2.2:5055/User/update-password?currentPassword=${_currentPassword}&newPassword=${_newPassword}'),
            headers: {
              'Authorization': 'Bearer ${widget.token}',
              'Content-Type': 'application/json',
            },
          );
          print("status ${response.statusCode}");
          print("Bearer ${widget.token}");

          if (response.statusCode == 200) {
            _currentPasswordController.clear();
            _newPasswordController.clear();
            _retypePasswordController.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Password updated successfully!'),
                duration: Duration(seconds: 2),
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to update password. Please try again.'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating password. Please try again.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('New passwords do not match!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all the fields!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
