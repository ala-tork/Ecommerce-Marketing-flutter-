import 'package:ecommerceversiontwo/Pages/Views/Screens/BottomBar/AnnouceBottomBar/AnnounceDetails.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/modals/add_to_cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class GridB extends StatefulWidget {
  final  data;
  const GridB({super.key, required this.data,});

  @override
  State<GridB> createState() => _GridBState();
}

class _GridBState extends State<GridB> {
  List gridMap=[];
  @override
  void initState() {
    // TODO: implement initState
    gridMap = widget.data;
    //print(gridMap[0].title);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return
      GridView.builder(

      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2 ,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        mainAxisExtent: 327,
      ),
      itemCount: gridMap.length,
      itemBuilder: (_, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AnounceDetails(Announce: gridMap[index],),
              ),
            );
          },
          child: Container(
            //onTap:(){},
            width: MediaQuery.of(context).size.width / 2 - 16 - 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17.0),
              border: Border.all(
                color: Colors.indigo,
                width: 1.0,

              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // item image
                Container(
                  width: MediaQuery.of(context).size.width / 0 - 0 - 0,
                  height: MediaQuery.of(context).size.width / 2 - 0 - 26,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                        image: NetworkImage("https://10.0.2.2:7058"+gridMap[index].imagePrinciple), fit: BoxFit.cover),
                  ),
                ),
                // item details
                Container(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${gridMap[index].title}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 2, bottom: 8),
                        child: Text(
                          '${gridMap[index].price} DT',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                      Text(
                        '${gridMap[index].countries.title}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if(gridMap[index].like==true){
                                  gridMap[index].like=false;
                                }else{
                                  gridMap[index].like=true;
                                }
                              });
                            },
                            icon: gridMap[index].like == false ? Icon(
                              CupertinoIcons.heart,
                            ):Icon(
                              CupertinoIcons.heart_fill,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              AddToCartModal();
                            },
                            icon: Icon(
                              CupertinoIcons.star,
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}



