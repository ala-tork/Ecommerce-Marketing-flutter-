import 'package:ecommerceversiontwo/Pages/Views/Screens/AnnouncesCRUD/EditeAnnounce.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AnnounceModel.dart';
import 'package:flutter/material.dart';



class MyAnnounces extends StatefulWidget {
  const MyAnnounces({super.key});

  @override
  State<MyAnnounces> createState() => _MyAnnouncesState();
}

class _MyAnnouncesState extends State<MyAnnounces> {
  List announces = [
    AnnounceModel(id:1,title:"ITIWIT",shortDescription:"CANOE KAYAK CONFORTABLE",price:1890,image : "assets/images/Announces/deals1.png",boosted: false),
    AnnounceModel(id:2,title:"OLAIAN",shortDescription:"SURFER BOARDSHORT",price:50,image : "assets/images/Announces/deals2.png",boosted: false),
    AnnounceModel(id:3,title:"SUBEA",shortDescription:"CHAUSSURES ELASTIQUE ADULTE",price:50,image :"assets/images/Announces/deals3.png",boosted: false),
  ];
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
        appBar: AppBar(
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.indigo[900],
          title: Text("My Announces",
            style: TextStyle(
                color: Colors.white
            ),
          ),
          centerTitle: true,
        ),
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
                                      
                                image: AssetImage('${announces[index].image}'), // Replace with your image path
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
                                Text("${announces[index].shortDescription}",
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
                                        description: announces[index].shortDescription,
                                        price: announces[index].price,
                                        image: announces[index].image,
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
                                      // Add your onPressed logic here
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
