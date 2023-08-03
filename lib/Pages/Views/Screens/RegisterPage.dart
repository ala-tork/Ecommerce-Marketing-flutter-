import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/LoginPage.dart';
import 'package:ecommerceversiontwo/Pages/app_color.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  final smtpServer = SmtpServer(
    'smtp.gmail.com',
    username: 'scongresses@gmail.com',
    password: 'rmnhfzorebtozejl',
    port: 465,
    ssl: true,
  );
  bool isValidEmail(String email) {
    // Use a regular expression to validate email format
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    return email.isNotEmpty && emailRegex.hasMatch(email);
  }

  void sendOTP() async {
    print("from sendotp");
    final email = emailController.text;
    final message = Message()
      ..from = Address('scongresses@gmail.com')
      ..recipients.add(email)
      ..subject = 'OTP Verification'
      ..text = 'Your OTP is: 1234';

    try {
      final sendReport = await send(message, smtpServer);
      print('OTP sent: ${sendReport.toString()}');
    } catch (e) {
      print('Error while sending OTP: $e');
    }
  }

  void showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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

  void showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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

  late bool isSignUpClicked = false;
  String emailErrorMessage = '';
  String passwordErrorMessage = '';
  String firstnameErrorMessage = '';

  void register() async {

    print("register ********************************************");

    String email = emailController.text;
    String password = passController.text;
    String firstname = usernameController.text;


    if (firstname.isEmpty || (firstname.length < 3)) {
      setState(() {
        firstnameErrorMessage = 'Please enter a valid username with at least 3 letters.';
      });
      return;
    } else {
      setState(() {
        firstnameErrorMessage = '';
      });
    }
    if (email.isEmpty || !isValidEmail(email)) {
      setState(() {
        emailErrorMessage = 'Please enter a valid email.';
      });
      return;
    } else {
      setState(() {
        emailErrorMessage = '';
      });
    }


    if (password.isEmpty || (password.length < 3)) {
      setState(() {
        passwordErrorMessage = 'Please enter a valid password with at least 4 letters.';
      });
      return;
    } else {
      setState(() {
        passwordErrorMessage = '';
      });
    }


    var url = Uri.parse("https://10.0.2.2:7058/User/register");

    var response = await http.post(
      url,
      headers: <String, String>{"Content-Type": "application/json"},
      body: jsonEncode(<String, String>{
        "email": email,
        "password": password,
        "firstname": firstname
      }),
    );

    if (response.statusCode == 200) {
      sendOTP();
      showSuccessDialog(
          'Success', 'User added successfully. Verify your email box');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } else {
      showErrorDialog('Error', 'Failed to register user. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        title: Text('Sign up', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
        leading: IconButton(

          onPressed: () {

            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 48,
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => LoginPage()));
          },
          style: TextButton.styleFrom(
            foregroundColor: AppColor.secondary.withOpacity(0.1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                ' Sign in',
                style: TextStyle(
                  color: AppColor.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 24),
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - Header
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 12),
            child: Text(
              'Welcome to MarketKy  👋',
              style: TextStyle(
                color: AppColor.secondary,
                fontWeight: FontWeight.w700,
                fontFamily: 'poppins',
                fontSize: 20,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 32),
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing \nelit, sed do eiusmod ',
              style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.7),
                  fontSize: 12,
                  height: 150 / 100),
            ),
          ),
          // Section 2  - Form
          // Full Name
          Column(
            children: [
              TextField(
                style: TextStyle(color: AppColor.primary),
                controller: usernameController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'First Name',
                  prefixIcon: Container(
                    padding: EdgeInsets.all(12),
                    child: SvgPicture.asset('assets/icons/Profile.svg',
                        color: AppColor.primary),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.border, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: Color(0xFFF0F8FF),
                  filled: true,
                ),
              ),
              SizedBox(height: 8),
              if (firstnameErrorMessage.isNotEmpty)
                Text(
                  firstnameErrorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 8),


            ],
          ),
          SizedBox(height: 16),

          Column(
            children: [
              TextField(
                style: TextStyle(color: AppColor.primary),
                controller: emailController,
                autofocus: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'youremail@example.com',
                  prefixIcon: Container(
                    padding: EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/icons/Message.svg',
                      color: AppColor.primary,

                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.border, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: Color(0xFFF0F8FF),
                  filled: true,
                ),
              ),
              SizedBox(height: 8),
              if (emailErrorMessage.isNotEmpty)
                Text(
                  emailErrorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 8),
            ],
          ),
          SizedBox(height: 16),
          // Password
          Column(
            children: [
              TextField(
                style: TextStyle(color: AppColor.primary),
                controller: passController,
                autofocus: false,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Container(
                    padding: EdgeInsets.all(12),
                    child: SvgPicture.asset('assets/icons/Lock.svg',
                      color: AppColor.primary,

                    ),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.border, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: Color(0xFFF0F8FF),
                  filled: true,
                  //
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset('assets/icons/Hide.svg',
                      color: AppColor.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              if (passwordErrorMessage.isNotEmpty)
                Text(
                  passwordErrorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 8),

            ],
          ),
          // Repeat Password
          SizedBox(height: 24),
          // Sign Up Button
          ElevatedButton(
            onPressed: () {
              if (!emailController.text.isEmpty ||
                  !usernameController.text.isEmpty ||
                  !passController.text.isEmpty) {
                if (isRegistered()) {
                  register();
                }}
              setState(() {
                isSignUpClicked = true;
              });
            },
            child: Text(
              'Sign up',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  fontFamily: 'poppins'),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 36, vertical: 18),
              backgroundColor:  AppColor.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'or continue with',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          // SIgn in With Google
          ElevatedButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/Google.svg',
                ),
                Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Text(
                    'Continue with Google',
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColor.primary,
              padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
              backgroundColor: Color(0xFFF0F8FF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  void showRegisterAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Not Registered'),
          content: Text('Please register to continue.'),
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

  bool isRegistered() {
    bool isUserRegistered = true;
    return isUserRegistered;
  }
}
