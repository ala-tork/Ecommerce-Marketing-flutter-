import 'dart:ffi';
import 'dart:io';

import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditeAnnounce extends StatefulWidget {
  final id;
  final title;
  final description;
  final price;
  final images;
  final boosted;

  const EditeAnnounce({super.key, this.id, this.title, this.description, this.price, this.images, this.boosted});

  @override
  State<EditeAnnounce> createState() => _EditeAnnounceState();
}

class _EditeAnnounceState extends State<EditeAnnounce> {

  bool? boost;
  final formstate = GlobalKey<FormState>();
  TextEditingController title = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController description = new TextEditingController();

  //image picker
  File? _image;
  //String images="";

  Future getImage(source) async{
    final image = await ImagePicker().pickImage(source: source);
    if (image==null) return ;
    final imageTemporary = File(image.path);
    setState(() {
      this._image = imageTemporary;
    });
  }

  @override
  void initState() {
  title.text=widget.title;
  description.text=widget.description;
  price.text = widget.price.toString();
  //images =widget.image;
  boost=widget.boosted;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(Daimons: 122,title: "Edite Announce",),
      body: Container(

        child: ListView(
          children: [
            /*Center(child:
            Text("Edite Announce :",style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.pink[200]
            ),)
            ),*/
            SizedBox(height: 30,),
            // create a form
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black.withOpacity(0.15),
                ),
                  color: Colors.white
              ),
              child: Form(
                  key: formstate,
                  child:
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 18.0, 0, 3),
                        child: TextFormField(
                          controller: title,
                          decoration: InputDecoration(
                              hintText: "title"
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 18.0, 0, 3),
                        child: TextFormField(
                          controller: description,
                          decoration: InputDecoration(
                              hintText: "Description"
                          ),
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 18.0, 0, 3),
                        child: TextFormField(
                          controller: price,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 20),
                              //label: ,
                              hintText: "price "
                          ),
                        ),
                      ),
                      SizedBox(height: 40,),
                      Text("add Announce Image :",style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                          child: Column(
                            children: [
                              _image != null
                                  ?
                                Column(
                                mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 300, // Set the desired height for the container
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.black.withOpacity(0)
                                            ),
                                        ),
                                        child: Image.file(_image!,height: 400,fit: BoxFit.fill,)
                                    )
                                    ]
                                )

                                  :
                              Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  height: 300, // Set the desired height for the container
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black.withOpacity(0)
                                    ),

                                    image: DecorationImage(

                                      image: AssetImage(widget.images), // Replace with your image path
                                      fit: BoxFit.fill,

                                    ),
                                  ),

                                ),
                                ]
                              ),

                              SizedBox(height: 30,),
                              CostumButton(
                                  title: "Pick an Image",
                                  iconName: Icons.image_outlined,
                                  onClick: ()=>getImage(ImageSource.gallery)
                              ),
                              CostumButton(
                                  title: "Take picture ",
                                  iconName: Icons.camera,
                                  onClick:()=>getImage(ImageSource.camera) ),
                            ],
                          ),
                        ),
                      ),


                      SizedBox(height: 40,),
                      Text("Do u wana to Boost the Annonce ?",style: TextStyle(
                        fontSize: 18,
                      ),
                      ),
                      Column(
                        children: [
                          RadioListTile(
                            title: Text("Yes"),
                            value: true,
                            selected: boost==true?true:false,
                            groupValue: boost,
                            onChanged: (value){
                              setState(() {
                                boost = value;
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text("No"),
                            value: false,
                            groupValue: boost==false?true:false,
                            onChanged: (value){
                              setState(() {
                                boost = value;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      // create button to save the data
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14.0),
                        child: MaterialButton(
                          textColor: Colors.indigo,
                          color: Colors.yellow[400],
                          onPressed: () async {
                            //print("$boost  $price");
                            print(widget.images);
                          },
                          child: Text("Edite Annonces",style: TextStyle(fontSize: 20),),
                        ),
                      ),
                      SizedBox(height: 20,),
                    ],
                  )
              ),
            )
          ],
        ),

      ),
    );
  }
}
