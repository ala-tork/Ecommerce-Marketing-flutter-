import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/CrudProduct/MyProductList.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/DealsCrudViews/MyDealsList.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/LoginPage.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/profile/Profile.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/wishlist.dart';
import 'package:ecommerceversiontwo/Pages/core/model/UserModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/UsersServices/UserService.dart';
import 'package:ecommerceversiontwo/language_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  String? token;
  String firstname = '';
  int? idUser;
  int setting=0;
  @override
  void initState() {
    super.initState();
    GetUser();
    _loadAuthToken();
  }

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
    var decodedToken = JwtDecoder.decode(token!);
    setState(() {
      firstname = decodedToken['firstname'] ?? '';
    });
  }

//// My Code
  int? id;

  Future<void> getuserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var decodedToken = JwtDecoder.decode(token!);
    id = int.parse(decodedToken['id']);
  }

  User? user;

  Future<User> GetUser() async {
    await getuserId();
    user = await UserService().GetUserByID(id!);
    if (user != null) {
      return user!;
    } else {
      throw Exception("user Not Found !");
    }
  }
  Future<void> Disconnect() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("token", "");
}

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: FutureBuilder<User>(
            future: GetUser(),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Failed to fetch data');
              } else {
                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Row(
                        children: [
                          Text(
                            "${user!.firstname} ${user!.lastname}",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(width: 5,),
                          if(user!.isverified==1)
                          Icon(Icons.verified, color: Colors.blue),
                          SizedBox(width: 8.0),
                          if(user!.isPremium==1)
                          Icon(Icons.star, color: Colors.greenAccent),
                          SizedBox(width: 8.0),
                          if(user!.isPro==1)
                          Icon(Icons.local_activity, color: Colors.orange),
                          SizedBox(width: 8.0),

                        ],
                      ),
                      accountEmail: Text(""),
                      currentAccountPicture: Container(
                        width: 100,
                        height: 100,
                        child: ClipOval(
                          child: user!.imageUrl != null
                              ? Image.network(
                            "${ApiPaths().UserImagePath}${user!.imageUrl}",
                            fit: BoxFit.cover,
                          )
                              : Image.asset(
                            "assets/user.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.indigo[900],
                        image: DecorationImage(
                          image: NetworkImage(''),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.account_circle_outlined),
                      title: Text(
                        //"Profile",
                        AppLocalizations.of(context)!.profile,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile(id: id!),
                          ),
                        ).then((value) async {
                          await GetUser().then((u) {
                            setState(() {
                              user=u;
                            });
                          });
                        });
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.shopping_bag_outlined),
                      title: Text(
                        AppLocalizations.of(context)!.sales_Orders,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.shopping_cart_outlined),
                      title: Text(
                        AppLocalizations.of(context)!.purchase_orders,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.list_alt),
                      title: Text(
                        AppLocalizations.of(context)!.my_Announces,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed("MyAnnounces");
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.list_alt),
                      title: Text(
                        AppLocalizations.of(context)!.my_Deals,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyDeals(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.list_alt),
                      title: Text(
                        AppLocalizations.of(context)!.my_Products,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyProducts(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(CupertinoIcons.star),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.my_Favorites,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(width: 30.0),
                          Container(
                            child: Text(
                              "",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WishList(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 50.0),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text(
                        AppLocalizations.of(context)!.setting,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          if(setting==0) {
                            setting = 1;
                          }else{setting=0;}
                        });
                      },
                    ),
                    if(setting==1)
                    Padding(
                      padding: const EdgeInsets.only(left: 48),
                      child: LanguagePickerWidget(),
                    ),
                    ListTile(
                      leading: Icon(Icons.exit_to_app_outlined),
                      title: Text(
                        AppLocalizations.of(context)!.logout,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      onTap: () async {
                        await Disconnect();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },

                    ),

                  ],
                );
              }
            }));
  }
}
