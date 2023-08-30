import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/messagePage.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/custom_icon_button_widget.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CountriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/UserModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/CountriesServices/CountryService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ecommerceversiontwo/Pages/app_color.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ProfileDetails extends StatefulWidget {
  final int id;

  ProfileDetails({required this.id});

  @override
  ProfileDetailsState createState() => ProfileDetailsState();
}

class ProfileDetailsState extends State<ProfileDetails>
    with SingleTickerProviderStateMixin {
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

  Future<List<dynamic>> fetchCountries() async {
    final apiUrl = 'https://10.0.2.2:7058/api/Country/getCountry';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // Ensure jsonData is a list
        if (jsonData is List<dynamic>) {
          return jsonData; // Directly return the list of countries
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to fetch countries');
      }
    } catch (e) {
      throw Exception('Error: $e');
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

  List<String> countries = [];

  Future<Map<String, dynamic>> fetchUserData() async {
    final apiUrl = 'https://10.0.2.2:7058/User/GetUserById?id=$id';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData is Map<String, dynamic>) {
          return jsonData;
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  User? user;

  Future<User> GetUser() async {
    user = await User().GetUserByID(id!);
    if (user != null) {
      return user!;
    } else {
      throw Exception("user Not Found !");
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

    fetchCountries().then((List<dynamic> fetchedCountries) {
      setState(() {
        countries = fetchedCountries
            .map((country) => country['title'].toString())
            .toList();
      });
    });
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .pushNamed("LandingPage"); // Redirect to previous screen
          },
        ),
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.indigo,
        title: Text(
          "announcements",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5.0, 5.0, 0),
            child: CustomIconButtonWidget(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MessagePage()));
              },
              value: 2,
              icon: Icon(
                Icons.mark_unread_chat_alt_outlined,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5.0, 15.0, 0),
            child: CustomIconButtonWidget(
              onTap: () {
                AwesomeDialog(
                        context: context,
                        dialogBackgroundColor: Colors.indigo,
                        dialogType: DialogType.info,
                        animType: AnimType.topSlide,
                        title: "Diamond",
                        descTextStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        desc:
                            "Hello, welcome to ADS & Deals.\n \n What are diamonds?!\n Diamonds are the currency within our application.\n With diamonds, you can add your products to the application and enhance their visibility. If you would like to refill your wallet and purchase diamonds, please click OK",
                        btnCancelColor: Colors.grey,
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {})
                    .show();
              },
              value: 122,
              icon: Icon(
                Icons.diamond_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Container(
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
                                    AppLocalizations.of(context)!.personal_Information,
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
                                  _status ? _getEditIcon() : Container(),
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
                              if (_status == true)
                                Flexible(
                                  child: TextField(
                                    controller: _addressController,
                                    decoration: InputDecoration(
                                      hintText: country.isEmpty
                                          ? "Enter Your COuntry"
                                          : country,
                                    ),
                                    enabled: true,
                                  ),
                                ),
                              if (_status == false)
                                Flexible(
                                  child: FutureBuilder<void>(
                                    future: FetchCountries(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        if (_countrys != null &&
                                            _countrys!.isNotEmpty) {
                                          return Column(
                                            children: [
                                              Container(
                                                child: DropdownButton(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 7),
                                                  disabledHint:
                                                      Text("Select Country"),
                                                  value: _country != null
                                                      ? _country
                                                      : _countrys?[0],
                                                  items: _countrys!
                                                      .map(
                                                        (e) => DropdownMenuItem<
                                                            CountriesModel>(
                                                          child: Text(e.title
                                                              .toString()),
                                                          value: e,
                                                        ),
                                                      )
                                                      .toList(),
                                                  onChanged:
                                                      (CountriesModel? val) {
                                                    setState(() {
                                                      _country = val;
                                                      country = val!.title!;
                                                    });
                                                  },
                                                  icon:
                                                      Icon(Icons.map_outlined),
                                                  iconEnabledColor:
                                                      Colors.indigo,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
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
                        !_status ? _getActionButtons() : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });

                  // Prepare the updated user data based on the text controller values
                  var updatedUser = {
                    'firstname': _firstnameController.text,
                    'lastname': _lastnameController.text,
                    'email': _emailController.text,
                    'phone': _phoneController.text,
                    'address': _addressController.text,
                    'country': _selectedCountry,
                  };

                  // Call the separate method to update the user
                  updateUserInformation(updatedUser).then((_) {
                    // Re-enable the button after the API call is completed
                    setState(() {
                      _status = false;
                    });
                  });
                  _showUpdateSuccessAlert();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _status = true;
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _status = false;
        });
        FocusScope.of(context).requestFocus(myFocusNode);
      },
      child: CircleAvatar(
        backgroundColor: AppColor.primary,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
    );
  }

  void _showUpdateSuccessAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('User updated successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                _status = true;
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
