import 'package:ecommerceversiontwo/Pages/Views/Screens/BottomBar/announces.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/BottomBar/deals.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/BottomBar/store.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/HomePage.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  int currentTab=0;
  final List<Widget> screens=[
    HomePage(),
    Deals(),
    Store(),
    Announces()
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomePage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {  },
        child: Icon(Icons.add),
      ),
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
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        currentScreen = HomePage();
                        currentTab=0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home,color: currentTab==0?Colors.blue:Colors.grey,),
                        Text(
                          "Dashbord",
                          style: TextStyle(
                              color: currentTab==0?Colors.blue:Colors.grey
                          ),
                        )
                      ],

                    ),
                  ),
                  SizedBox(width: 15,),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        currentScreen = Deals();
                        currentTab=1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person,color: currentTab==1 ?Colors.blue:Colors.grey,),
                        Text(
                          "Deals",
                          style: TextStyle(
                              color: currentTab==1 ?Colors.blue:Colors.grey
                          ),
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
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        currentScreen = Store();
                        currentTab=2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.storefront_outlined,color: currentTab==2?Colors.blue:Colors.grey,),
                        Text(
                          "Stor",
                          style: TextStyle(
                              color: currentTab==2?Colors.blue:Colors.grey
                          ),
                        )
                      ],

                    ),
                  ),
                  SizedBox(width: 15,),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        currentScreen = Announces();
                        currentTab=3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.announcement_rounded,color: currentTab==3?Colors.blue:Colors.grey,),
                        Text(
                          "Announce",
                          style: TextStyle(
                              color: currentTab==3?Colors.blue:Colors.grey
                          ),
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
