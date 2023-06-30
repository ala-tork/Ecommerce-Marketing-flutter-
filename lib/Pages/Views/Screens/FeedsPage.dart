
import 'package:ecommerceversiontwo/Pages/Views/widgets/explore_card_widget.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/main_app_bar_widget.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/update_card_widget.dart';
import 'package:ecommerceversiontwo/Pages/app_color.dart';
import 'package:ecommerceversiontwo/Pages/core/model/ExploreItem.dart';
import 'package:ecommerceversiontwo/Pages/core/model/ExploreUpdate.dart';
import 'package:ecommerceversiontwo/Pages/core/services/ExploreService.dart';
import 'package:flutter/material.dart';

class FeedsPage extends StatefulWidget {
  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> with TickerProviderStateMixin {
  late TabController tabController;
  List listExploreItem = ExploreService.listExploreItem;
  List listExploreUpdateItem = ExploreService.listExploreUpdateItem;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        cartValue: 2,
        chatValue: 2,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          // Tabbbar
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            color: AppColor.secondary,
            child: TabBar(
              onTap: (index) {
                setState(() {
                  tabController.index = index;
                });
              },
              controller: tabController,
              indicatorColor: AppColor.accent,
              indicatorWeight: 5,
              unselectedLabelColor: Colors.white.withOpacity(0.5),
              labelStyle: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'poppins'),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400, fontFamily: 'poppins'),
              tabs: [
                Tab(
                  text: 'Update',
                ),
                Tab(
                  text: 'Explore',
                ),
              ],
            ),
          ),
          // Section 2 - Tab View
          IndexedStack(
            index: tabController.index,
            children: [
              // Tab 1 - Update
              ListView.separated(
                itemCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return UpdateCardWidget(
                    data: listExploreUpdateItem[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 24,
                  );
                },
              ),
              // Tab 2 - Explore
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                childAspectRatio: 1 / 1,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(listExploreItem.length, (index) {
                  return ExploreCardWidget(data: listExploreItem[index]);
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}