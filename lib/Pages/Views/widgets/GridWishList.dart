import 'package:ecommerceversiontwo/Pages/Views/widgets/modals/add_to_cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class GridWishList extends StatefulWidget {
  final  data;
  const GridWishList({super.key, required this.data,});

  @override
  State<GridWishList> createState() => _GridWishListState();
}

class _GridWishListState extends State<GridWishList> {
  List gridMap=[];
  @override
  void initState() {
    // TODO: implement initState
    gridMap = widget.data;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1 ,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        mainAxisExtent: 310,
      ),
      itemCount: gridMap.length,
      itemBuilder: (_, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              16.0,
            ),
            color: Colors.teal[100],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                child: Image.network(
                  "${gridMap.elementAt(index).images}",
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${gridMap.elementAt(index).title}",
                      style: Theme.of(context).textTheme.subtitle1!.merge(
                        const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "${gridMap.elementAt(index).price} DT",
                      style: Theme.of(context).textTheme.subtitle2!.merge(
                        TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 25,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
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
                            size:32,
                            CupertinoIcons.heart,
                          ):Icon(
                            size:32,
                            CupertinoIcons.heart_fill,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                           setState(() {
                             gridMap.remove(gridMap[index]);
                           });
                          },
                          icon: Icon(
                            size:32,
                            CupertinoIcons.star_fill, color: Colors.yellow[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}