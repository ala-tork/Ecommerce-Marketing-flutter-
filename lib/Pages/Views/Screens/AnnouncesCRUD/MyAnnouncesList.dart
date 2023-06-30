import 'package:ecommerceversiontwo/Pages/Views/Screens/AnnouncesCRUD/EditeAnnounce.dart';
import 'package:flutter/material.dart';



class MyAnnounces extends StatefulWidget {
  const MyAnnounces({super.key});

  @override
  State<MyAnnounces> createState() => _MyAnnouncesState();
}

class _MyAnnouncesState extends State<MyAnnounces> {
  final List<Map> annonces=
  List.generate(3, (index) => {
    "id":index,
    "title":"Product $index",
    "price":120.0,
    "description":"My Description ......",
    "image":"assets/images/adidasjacket.jpg",
    "datepub":DateTime.now(),
    "Boosted":false,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).pushNamed("AddAnnounce");
        },
      child: Icon(Icons.add),),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        appBar: AppBar(title: Text("My Announces"),),
        body:ListView.builder(

            shrinkWrap:true,
            itemCount: annonces.length,
            itemBuilder:(context,index){
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                child:
                Card(
                  color: Colors.white,
                  borderOnForeground: true,
                  elevation: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: 200, // Set the desired height for the container
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('${annonces[index]["image"]}'), // Replace with your image path
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
                                  '${annonces[index]["title"]}',
                                  style: TextStyle(
                                    fontSize: 16,
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
                            Text("${annonces[index]["price"]} DT",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo
                              ),
                            )
                          ],

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                        child: Row(
                          children: [
                            Text("${annonces[index]["description"]}",
                              style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                                color: Colors.grey[400],
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

                                    id: annonces[index]['id'],
                                    title: annonces[index]['title'],
                                    description: annonces[index]['description'],
                                    price: annonces[index]['price'],
                                    image: annonces[index]['image'],
                                    boosted: annonces[index]['Boosted'],
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
              );
            })

    );
  }
}
