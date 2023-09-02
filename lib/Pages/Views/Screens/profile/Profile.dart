import 'dart:io';
import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/profile/ChangePassword.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/profile/UpdateProfile.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/AppBarWithArrowBack.dart';
import 'package:ecommerceversiontwo/Pages/app_color.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CountriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/UserModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/CountriesServices/CountryService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/UsersServices/UserService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Profile extends StatefulWidget {
  final int id;

  const Profile({super.key, required this.id});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  String email = "";
  String firstname = "";
  String lastname = "";
  String phone = "";
  String country = "";
  String address = "";
  String selectedCountry = '';
  int? id;
  User? user;
  String? token;

  Future<User> AddImage(source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) {
      throw Exception('faild to get image');
      //return;
    }

    final imageTemporary = File(image.path);
    try {
      User response =
          await UserService().addUserImage(user!.id!, imageTemporary);
      if (response.id != null) {
        setState(() {
          user = response;
        });
      }
      return response;
    } catch (e) {
      throw Exception("faild to Add User Image  : $e");
    }
  }

  Future<User> GetUser() async {
    user = await UserService().GetUserByID(id!);
    if (user != null) {
      email = user?.email ?? "";
      firstname = user?.firstname ?? "";
      lastname = user?.lastname ?? "";
      phone = user?.phone ?? "";
      address = user?.address ?? "";
      country = user?.country ?? "";
      _emailController.text = email;
      _firstnameController.text = firstname;
      _phoneController.text = phone;
      _countryController.text = country;
      _addressController.text = address;
      _lastnameController.text = lastname;
      return user!;
    } else {
      throw Exception("user Not Found !");
    }
  }

  List<CountriesModel>? _countrys;
  CountriesModel? _country;

  /** fetch countrys */
  Future<void> FetchCountries() async {
    try {
      List<CountriesModel> countries = await CountrySerice().GetData();
      _countrys = countries;
      if (_countrys!.isNotEmpty) {
        _country = _countrys!.firstWhere((c) => c.title == country);
      }
    } catch (e) {
      print('Error fetching countrys: $e');
    }
  }
  void GetToken ()async {
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    setState(()  {
      token = prefs.getString('token');
    });
  }
  @override
  void initState() {
    super.initState();
    GetToken();
    id = widget.id;
    GetUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithArrowBack(title: AppLocalizations.of(context)!.profile),
      body: FutureBuilder<User>(
        future: GetUser(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Failed to fetch data');
          } else {
            return Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        height: 250.0,
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Stack(
                                fit: StackFit.loose,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 140.0,
                                        height: 140.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: user?.imageUrl != null
                                                ? NetworkImage(
                                                    "${ApiPaths().UserImagePath}${user?.imageUrl}")
                                                : AssetImage("assets/user.png")
                                                    as ImageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 90.0, right: 100.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundColor: AppColor.primary,
                                          radius: 25.0,
                                          child: GestureDetector(
                                            onTap: () async {
                                              await AddImage(
                                                  ImageSource.gallery);
                                            },
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            if (user!.isverified == 1)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Verified : ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(Icons.verified, color: Colors.blue),
                                ],
                              ),
                            if (user!.isPremium == 1)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Premium : ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(Icons.star, color: Colors.greenAccent),
                                ],
                              ),
                            if (user!.isPro == 1)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Pro : ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(Icons.local_activity,
                                      color: Colors.orange),
                                ],
                              )
                          ],
                        ),
                      ),
                      Container(
                        color: Color(0xffFFFFFF),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 25.0,
                                  right: 25.0,
                                  top: 25.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          AppLocalizations.of(context)!
                                              .personal_Information,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        IconButton(
                                            onPressed: () async {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateProfile(id: id!),
                                                ),
                                              ).then((value) {
                                                GetUser();
                                              });
                                            },
                                            icon: Icon(Icons.edit))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 25.0,
                                  right: 25.0,
                                  top: 25.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          AppLocalizations.of(context)!
                                              .firstName,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 25.0,
                                  right: 25.0,
                                  top: 2.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextField(
                                        controller: _firstnameController,
                                        decoration: InputDecoration(
                                          hintText: firstname.isEmpty
                                              ? AppLocalizations.of(context)!
                                                  .enter_Firstname
                                              : firstname,
                                        ),
                                        enabled: !_status,
                                        autofocus: !_status,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //lastname
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 25.0,
                                  right: 25.0,
                                  top: 25.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          AppLocalizations.of(context)!
                                              .lastName,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 25.0,
                                  right: 25.0,
                                  top: 2.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextField(
                                        controller: _lastnameController,
                                        decoration: InputDecoration(
                                          hintText: lastname.isEmpty
                                              ? AppLocalizations.of(context)!
                                                  .enter_Lastname
                                              : lastname,
                                        ),
                                        enabled: !_status,
                                        autofocus: !_status,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
//email
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 25.0,
                                  right: 25.0,
                                  top: 25.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          AppLocalizations.of(context)!.email,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 25.0,
                                  right: 25.0,
                                  top: 2.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextField(
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                          hintText: email.isEmpty
                                              ? AppLocalizations.of(context)!
                                                  .enter_Email
                                              : email,
                                        ),
                                        enabled: !_status,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //mobile
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 25.0,
                                  right: 25.0,
                                  top: 25.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          AppLocalizations.of(context)!.mobile,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 25.0,
                                  right: 25.0,
                                  top: 2.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextField(
                                        controller: _phoneController,
                                        decoration: InputDecoration(
                                          hintText: phone.isEmpty
                                              ? AppLocalizations.of(context)!
                                                  .enter_phone_Number
                                              : phone,
                                        ),
                                        enabled: !_status,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //address
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 25.0,
                                  right: 25.0,
                                  top: 25.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          AppLocalizations.of(context)!.address,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 25.0,
                                  right: 25.0,
                                  top: 2.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextField(
                                        controller: _addressController,
                                        decoration: InputDecoration(
                                          hintText: address.isEmpty
                                              ? AppLocalizations.of(context)!
                                                  .enter_Address
                                              : address,
                                        ),
                                        enabled: !_status,
                                        autofocus: !_status,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //country
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 25.0,
                                  right: 25.0,
                                  top: 25.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          AppLocalizations.of(context)!.country,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 25.0,
                                  right: 25.0,
                                  top: 2.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextField(
                                        controller: _addressController,
                                        decoration: InputDecoration(
                                          hintText: country.isEmpty
                                              ? AppLocalizations.of(context)!
                                                  .enter_Your_Country
                                              : country,
                                        ),
                                        enabled: !_status,
                                        autofocus: !_status,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: ElevatedButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdatePasswordPage(token: token!)));
                                    },
                                    child: Text("Update Password")
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
