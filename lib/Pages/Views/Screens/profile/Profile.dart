import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/messagePage.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/profile/ProfileProvider.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/profile/UpdateProfile.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/AppBarWithArrowBack.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/custom_icon_button_widget.dart';
import 'package:ecommerceversiontwo/Pages/app_color.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CountriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/UserModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/CountriesServices/CountryService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  String _selectedCountry = '';
  String selectedCountry = '';
  int? id;
  User? user;



  Future<User> GetUser() async {
    user = await User().GetUserByID(id!);
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

  @override
  void initState() {
    super.initState();

    id = widget.id;

    GetUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithArrowBack(),
      body:FutureBuilder<User>(
        future: GetUser(),
    builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return CircularProgressIndicator();
    } else if (snapshot.hasError) {
    return Text('Failed to fetch data');
    } else {
    return
      Container(
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
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                              "${ApiPaths().ImagePath}${user?.imageUrl}")
                                          : AssetImage("assets/user.png")
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 90.0, right: 100.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: AppColor.primary,
                                    radius: 25.0,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Personal Information',
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
                                      onPressed: () async  {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateProfile(id: id!),
                                          ),
                                        ).then((value)  {
                                           GetUser();
                                        });
                                      },
                                      icon: Icon(Icons.edit)
                                  )
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'FirstName',
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
                                        ? "Enter Firstname"
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'LastName',
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
                                        ? "Enter Lastname"
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Email',
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
                                    hintText:
                                        email.isEmpty ? "Enter Email " : email,
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Mobile',
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
                                        ? "Enter Mobile Number"
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Address',
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
                                        ? "Enter Address"
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Country',
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
                                          ? "Enter Your COuntry"
                                          : country,
                                    ),
                                    enabled: !_status,
                                    autofocus: !_status,
                                  ),
                                ),
                            ],
                          ),
                        ),
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
