import 'package:ecommerceversiontwo/Pages/Views/widgets/AppBarWithArrowBack.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CountriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/UserModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/CountriesServices/CountryService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateProfile extends StatefulWidget {
  final int id;
  const UpdateProfile({super.key, required this.id});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

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
      return user!;
    } else {
      throw Exception("user Not Found !");
    }
  }

  List<CountriesModel>? _countries;
  CountriesModel? _selectedCountryModel;


  List<CountriesModel>? _countrys;
  CountriesModel? _country;
  /** fetch countrys */
  Future<void> FetchCountries() async {
    try {
      List<CountriesModel> countries = await CountrySerice().GetData();
      _countrys = countries;
      if(_countrys!.isNotEmpty){
        _country=_countrys!.firstWhere((c) => c.title==country);
      }
    } catch (e) {
      print('Error fetching countrys: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    id = widget.id;

    GetUser().then((user) {
      setState(() {
        email = user.email ?? "";
        firstname = user.firstname ?? "";
        lastname = user.lastname ?? "";
        phone = user.phone ?? "";
        address = user.address ?? "";
        country = user.country ?? "";
        _emailController.text = email;
        _firstnameController.text = firstname;
        _phoneController.text = phone;
        _countryController.text = country;
        _addressController.text = address;
        _lastnameController.text = lastname;
      });
    });
    FetchCountries();
  }

  Future<void> updateUserInformation(Map<String, dynamic> updatedUser) async {
    try {
      final response = await http.put(
        Uri.parse('https://10.0.2.2:7058/User/UpdateUser?id=$id'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(updatedUser),
      );

      if (response.statusCode == 200) {
        print("User updated successfully!");
      } else {
        print("Failed to update user. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error while updating user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithArrowBack(title:AppLocalizations.of(context)!.update_Profile),
      body : Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
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
                            bottom: 15
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)!.update_Personal_Information,
                                    style: TextStyle(
                                      fontSize: 22.0,
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
                                    AppLocalizations.of(context)!.firstName,
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
                                    hintText: firstname.isEmpty ?
                                    AppLocalizations.of(context)!.enter_Firstname
                                        : firstname,
                                  ),

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
                                    AppLocalizations.of(context)!.lastName,
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
                                    hintText: lastname.isEmpty ?
                                    AppLocalizations.of(context)!.enter_Lastname
                                        : lastname,
                                  ),
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
                                    hintText: email.isEmpty ?
                                    AppLocalizations.of(context)!.enter_Email
                                        : email,

                                  ),
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
                                    hintText: phone.isEmpty ?
                                    AppLocalizations.of(context)!.enter_phone_Number
                                        : phone,
                                  ),
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
                                    hintText: address.isEmpty ?
                                    AppLocalizations.of(context)!.enter_Address
                                        : address,
                                  ),
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
                                  child:
                                  FutureBuilder<void>(
                                    future: FetchCountries(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        if (_countrys != null && _countrys!.isNotEmpty) {
                                          return Column(
                                            children: [
                                              Container(
                                                child: DropdownButton(
                                                  padding: EdgeInsets.symmetric(horizontal: 7),
                                                  disabledHint: Text("Select Country"),
                                                  value: _country != null ? _country : _countrys?[0],
                                                  items: _countrys!.map((e) => DropdownMenuItem<CountriesModel>(
                                                    child: Text(e.title.toString()),
                                                    value: e,
                                                  ),
                                                  ).toList(),
                                                  onChanged:(CountriesModel? val) {
                                                    setState(() {
                                                      _country = val;
                                                      country = val!.title!;
                                                    });
                                                  },
                                                  icon: Icon(Icons.map_outlined),
                                                  iconEnabledColor: Colors.indigo,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Text('No data available');
                                        }
                                      }
                                    },
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
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Container(
                          child:
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                FocusScope.of(context).requestFocus(FocusNode());
                              });

                              // Prepare the updated user data based on the text controller values
                              var updatedUser = {
                                'firstname': _firstnameController.text,
                                'lastname': _lastnameController.text,
                                'email': _emailController.text,
                                'phone': _phoneController.text,
                                'address': _addressController.text,
                                'country': country,
                              };
                              // Call the separate method to update the user
                              updateUserInformation(updatedUser);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.save,
                              style: TextStyle(color: Colors.white),
                            ),
                          )

                      ),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Container(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    flex: 2,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
