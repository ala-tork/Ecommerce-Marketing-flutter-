import 'package:ecommerceversiontwo/Pages/Views/Screens/LandingPage.dart';
import 'package:ecommerceversiontwo/Pages/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/adminscreen.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/pageSwitcher.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class OTPVerificationPage extends StatefulWidget {
  final String token;

  OTPVerificationPage({required this.token});

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  String? id;
  String? email;
  String? role;

  TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    decodeToken();
  }

  void decodeToken() {
    // Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
    //currentUserId = int.parse(decodedToken['id']);
    var decodedToken = JwtDecoder.decode(widget.token);
    id = decodedToken['id'] ?? '';

    email = decodedToken['email'];
    role=decodedToken['role'];
    print("email $email");
  }

  void verifyOTP() async {
    print("///////////////////////////// $id");
    String enteredOTP = otpController.text;
    String expectedOTP = '1234';
    print("enteredOTP $enteredOTP");

    print("currentUserId $id");

    if (enteredOTP == expectedOTP) {

      var url = Uri.parse("https://10.0.2.2:7058/User/VerifyOTP?id=$id");
      print('urm $url');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}",
      };

      print("TOKEN: ${widget.token}");

      var response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        print("role: $role");
        if (role == "User") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Builder(
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: Text('Success'),
                    content: Text('OTP verification successful. User activated.'),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              //builder: (context) => PageSwitcher(token: widget.token),
                              builder: (context)=> LandingPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Builder(
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: Text('Success'),
                    content: Text('OTP verification successful. User activated.'),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Builder(
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('Failed to activate user. Please try again.'),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Builder(
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Invalid OTP. Please try again.'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(Daimons: 122, title: "Verification"),

      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 24),
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 8),
            child: Text(
              'Email verification',
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
            child: Row(
              children: [
                Text(
                  'OTP Code sent to your email',
                  style: TextStyle(
                      color: AppColor.secondary.withOpacity(0.7), fontSize: 14),
                ),
                SizedBox(width: 8),
                Text(
                  '$email',
                  style: TextStyle(
                      color: Color(0xFF0070BB),
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          TextField(
            style: TextStyle(color: AppColor.primary),
            controller: otpController,
            keyboardType: TextInputType.number,
            maxLength: 4,

            onChanged: (value) {},
            obscureText: false,
            decoration: InputDecoration(
              hintText: 'Enter OTP',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Color(0xFF0070BB),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Color(0xFF0070BB),
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColor.border,
                  width: 1.5,
                ),
              ),
              filled: true,
              fillColor: Color(0xFFF0F8FF),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 32, bottom: 16),
            child: ElevatedButton(
              onPressed: verifyOTP,
              child: Text(
                'Verify',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    fontFamily: 'poppins'),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                backgroundColor: AppColor.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              'Resend OTP Code',
              style: TextStyle(
                color: AppColor.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColor.primary,
              padding: EdgeInsets.symmetric(horizontal: 36, vertical: 18),
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
}
