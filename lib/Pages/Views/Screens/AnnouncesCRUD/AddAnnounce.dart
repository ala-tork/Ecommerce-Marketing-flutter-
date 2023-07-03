import 'dart:io';

import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:image_picker/image_picker.dart';

class AddAnnounces extends StatefulWidget {
  const AddAnnounces({super.key});

  @override
  State<AddAnnounces> createState() => _AddAnnouncesState();
}

class _AddAnnouncesState extends State<AddAnnounces> {

  final formstate = GlobalKey<FormState>();
  TextEditingController title = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController images = new TextEditingController();
  bool? boost;
  //image picker
  File? _image;

  Future getImage(source) async{
    final image = await ImagePicker().pickImage(source: source);
    if (image==null) return ;
    final imageTemporary = File(image.path);
    setState(() {
      this._image = imageTemporary;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.blueGrey[100],
      appBar: MyAppBar(Daimons: 122,title: "Add Announce",),
      body: Container(
        child: ListView(
          children: [
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
                      // image picker
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

                                          image: AssetImage("assets/images/vide.png"), // Replace with your image path
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
                      //end of image picker

                      // radio button for bosting
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
                            groupValue: boost,
                            onChanged: (value){
                              setState(() {
                                boost = value;
                              });
                            },
                          ),
                        ],
                      ),
                      //end radio button
                      SizedBox(height: 20,),
                      // create button to save the data
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14.0),
                        child: MaterialButton(
                          textColor: Colors.indigo,
                          color: Colors.yellow[400],
                          onPressed: () async {
                            print("$boost  $price.");
                          },
                          child: Text("Add Annonces",style: TextStyle(fontSize: 20),),
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
