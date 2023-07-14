import 'package:ecommerceversiontwo/Pages/Views/Screens/AnnouncesCRUD/EditeAnnounce.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AnnounceModel.dart';
import 'package:flutter/material.dart';



class MyAnnounces extends StatefulWidget {
  const MyAnnounces({super.key});

  @override
  State<MyAnnounces> createState() => _MyAnnouncesState();
}

class _MyAnnouncesState extends State<MyAnnounces> {
  List<dynamic> announces = [
    AnnounceModel(idAds:1,title:"ITIWIT",description:"CANOE KAYAK CONFORTABLE",price:1890,imagePrinciple : "assets/images/Announces/deals1.png",like:false),
    AnnounceModel(idAds:2,title:"OLAIAN",description:"SURFER BOARDSHORT",price:50,imagePrinciple : "assets/images/Announces/deals2.png",like: false),
    AnnounceModel(idAds:3,title:"SUBEA",description:"CHAUSSURES ELASTIQUE ADULTE",price:50,imagePrinciple :"assets/images/Announces/deals3.png",like: false),
  ];
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow[400],
        onPressed: (){
          Navigator.of(context).pushNamed("AddAnnounce");
        },
      child: Icon(Icons.add,color: Colors.indigo,),),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar:MyAppBar(title:"My Announces" ,),/* AppBar(
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.indigo[900],
          title: Text("My Announces",
            style: TextStyle(
                color: Colors.white
            ),
          ),
          centerTitle: true,
        ),*/
        body:Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 70.0),
          child: ListView.builder(

              shrinkWrap:true,
              itemCount: announces.length,
              itemBuilder:(context,index){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                  child:
                  Card(
                    color: Colors.white,
                    borderOnForeground: true,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.black.withOpacity(0.20),
                        ),
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            height: 200, // Set the desired height for the container
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.black.withOpacity(0)
                                ),

                                image: DecorationImage(
                                      
                                image: AssetImage('${announces[index].images}'), // Replace with your image path
                                fit: BoxFit.fill,

                              ),
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${announces[index].title}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                /*
                                Align(
                                  alignment: Alignment.centerRight,
                                  child:Text(
                                    '${annonces[index]["datepub"]}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )*/
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                            child: Row(
                              children: [
                                Text("${announces[index].description}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[500],
                                  ),
                                )
                              ],

                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                            child: Row(
                              children: [
                                Text("${announces[index].price} DT",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo
                                  ),
                                )
                              ],

                            ),
                          ),

                          SizedBox(height: 20,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton.icon(
                                    style: ButtonStyle(
                                     // backgroundColor: MaterialStateProperty.all<Color>(Colors.grey), // Replace with your desired background color
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditeAnnounce(

                                        id: announces[index].id,
                                        title: announces[index].title,
                                        description: announces[index].description,
                                        price: announces[index].price,
                                        images: announces[index].images,
                                        boosted: announces[index].boosted,
                                      )
                                      )
                                      );
                                    },
                                    icon: Icon(Icons.edit,color: Colors.greenAccent,), // Replace with your desired icon
                                    label: Text('Edit',style: TextStyle(color: Colors.black),),
                                  ),
                                  SizedBox(width: 20,),
                                  TextButton.icon(
                                    style: ButtonStyle(
                                      //backgroundColor: MaterialStateProperty.all<Color>(Colors.grey), // Replace with your desired background color
                                    ),
                                    onPressed: () {
                                      // Add your onPressed logic here
                                    },
                                    icon: Icon(Icons.flash_on,color: Colors.yellowAccent,), // Replace with your desired icon
                                    label: Text('Boost',style: TextStyle(color: Colors.black),),
                                  ),
                                  SizedBox(width: 20,),
                                  TextButton.icon(
                                    style: ButtonStyle(
                                      //backgroundColor: MaterialStateProperty.all<Color>(Colors.grey), // Replace with your desired background color
                                    ),
                                    onPressed: () {
                                     setState(() {
                                       announces.removeAt(index);
                                     });
                                    },
                                    icon: Icon(Icons.delete,color: Colors.red,), // Replace with your desired icon
                                    label: Text('Delete',style: TextStyle(color: Colors.black),),
                                  ),
                                  // Add more icons as needed
                                ],
                              ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        )

    );
  }
}
