import 'package:ecommerceversiontwo/Pages/Views/Screens/BottomBar/DealsBotomBar/DealsDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridDeals extends StatefulWidget {
  final data;

  const GridDeals({
    super.key,
    required this.data,
  });

  @override
  State<GridDeals> createState() => _GridDealsState();
}

class _GridDealsState extends State<GridDeals> {
  List gridMap = [];

  @override
  void initState() {
    gridMap = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        mainAxisExtent: 300,
      ),
      itemCount: gridMap.length,
      itemBuilder: (_, index) {
        var pricewithdiscount = gridMap[index].price +
            ((gridMap[index].discount * gridMap[index].price) / 100);
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DealsDetails(
                  Deals: gridMap[index],
                ),
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
                  height: MediaQuery.of(context).size.width / 2 - 0 - 6,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                        image: NetworkImage("https://10.0.2.2:7058" +
                            gridMap[index].imagePrinciple),
                        fit: BoxFit.cover),
                  ),
                  child: /** Discount band */
                      gridMap[index].discount > 0
                          ? Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      topRight: Radius.circular(17)),
                                ),
                                child: Text(
                                  '${gridMap[index].discount}% OFF',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 0,
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
                        child: Row(
                          children: [
                            Text(
                              '${gridMap[index].price} DT',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                                color: Colors.indigo,
                              ),
                            ),
                            SizedBox(width: 8),
                            if (gridMap[index].discount > 0)
                              Text(
                                '$pricewithdiscount DT',
                                style: TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                            if (gridMap[index].discount > 0)
                              Text(
                                '(${gridMap[index].discount}% off)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Text(
                        '${gridMap[index].countries.title}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
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
