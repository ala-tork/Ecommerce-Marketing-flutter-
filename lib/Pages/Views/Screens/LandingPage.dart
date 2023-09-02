import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/AnnouncesCRUD/AddAnnounce.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/BottomBar/AnnouceBottomBar/announces.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/BottomBar/DealsBotomBar/deals.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/BottomBar/StoreBottomBar/store.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/HomePage.dart';
import 'package:ecommerceversiontwo/Pages/core/model/UserModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/SettingServices/SettingService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/UsersServices/UserService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  /** User  */
  User? user;

  Future<User> GetUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var decodedToken = JwtDecoder.decode(token!);
    String id = decodedToken['id'];
    user = await UserService().GetUserByID(int.parse(id));
    if (user != null) {
      return user!;
    } else {
      throw Exception("user Not Found !");
    }
  }

  int? nbDiamonAds;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetUser().then((value) {
      setState(() async {
        nbDiamonAds = await SettingService().getNbDiamondAds();
      });
    });
  }

  int currentTab = 0;
  final List<Widget> screens = [HomePage(), Deals(), Store(), Announces()];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: FutureBuilder<User>(
          future: GetUser(),
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Failed to fetch data');
            } else {
              return FloatingActionButton(
                backgroundColor: Colors.teal[100],
                onPressed: () {
                  if (nbDiamonAds! <= user!.nbDiamon!) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddAnnounces(newUserdiamond: user!.nbDiamon! - nbDiamonAds!),
                      ),
                    );
                  } else {
                    AwesomeDialog(
                            context: context,
                            dialogBackgroundColor: Colors.teal[100],
                            dialogType: DialogType.warning,
                            animType: AnimType.topSlide,
                            title: "Error !",
                            descTextStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            desc: "You don't have enough diamonds.",
                            btnCancelColor: Colors.grey,
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {})
                        .show();
                  }
                },
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              );
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 30,
                    onPressed: () {
                      setState(() {
                        currentScreen = HomePage();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          color: currentTab == 0 ? Colors.indigo : Colors.grey,
                        ),
                        Text(
                          AppLocalizations.of(context)!.reception,
                          style: TextStyle(
                              color: currentTab == 0
                                  ? Colors.indigo
                                  : Colors.grey),
                        )
                      ],
                    ),
                  ),
                  //SizedBox(width: 15,),
                  MaterialButton(
                    minWidth: 30,
                    onPressed: () {
                      setState(() {
                        currentScreen = Deals();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: currentTab == 1 ? Colors.indigo : Colors.grey,
                        ),
                        Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          AppLocalizations.of(context)!.deals,
                          style: TextStyle(
                              color: currentTab == 1
                                  ? Colors.indigo
                                  : Colors.grey),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MaterialButton(
                    minWidth: 30,
                    onPressed: () {
                      setState(() {
                        currentScreen = Store();
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.storefront_outlined,
                          color: currentTab == 2
                              ? Colors.indigo[400]
                              : Colors.grey,
                        ),
                        Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          AppLocalizations.of(context)!.store,
                          style: TextStyle(
                              color: currentTab == 2
                                  ? Colors.indigo[400]
                                  : Colors.grey),
                        )
                      ],
                    ),
                  ),
                  //SizedBox(width: 15,),
                  MaterialButton(
                    minWidth: 30,
                    onPressed: () {
                      setState(() {
                        currentScreen = Announces();
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.announcement_rounded,
                          color: currentTab == 3
                              ? Colors.indigo[400]
                              : Colors.grey,
                        ),
                        Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          AppLocalizations.of(context)!.announcements,
                          style: TextStyle(
                              color: currentTab == 3
                                  ? Colors.indigo[400]
                                  : Colors.grey),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
