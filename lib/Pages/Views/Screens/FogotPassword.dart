import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerceversiontwo/Pages/Views/Screens/LoginPage.dart';
import 'package:ecommerceversiontwo/Pages/app_color.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        title: Text('Forgot Password', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
        ), systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!isValidEmail(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 18), backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),

                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _sendPasswordResetEmail(_emailController.text);
                  }
                },
                child: Text('Send Reset Email',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600,
                      fontSize: 18, fontFamily: 'poppins'),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendPasswordResetEmail(String email) async {
    final apiUrl = 'http://10.0.2.2:5055/User/ForgotPassword?email=$email';
    try {
      final response = await http.post(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print('Password reset email sent successfully.');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );

      } else {
        print('Failed to send password reset email. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending password reset email: $e');
    }
  }
  // Email validation function
  bool isValidEmail(String email) {
    final pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }
}

