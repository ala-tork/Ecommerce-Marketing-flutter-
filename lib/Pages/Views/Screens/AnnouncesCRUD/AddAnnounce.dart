import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(Daimons: 122,title: "Add Announce",),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          child: ListView(
            children: [
              // create a form
              Form(
                  key: formstate,
                  child:
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 18.0, 0, 3),
                        child: TextFormField(
                          controller: title,
                          decoration: InputDecoration(
                              hintText: "title"
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 18.0, 0, 3),
                        child: TextFormField(
                          controller: description,
                          decoration: InputDecoration(
                              hintText: "Description"
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 18.0, 0, 3),
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
                          /*
                          FormBuilder(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FormBuilderImagePicker(
                                  name: 'photos',
                                  decoration: const InputDecoration(labelText: 'Pick Photos'),
                                  maxImages: 1,
                                ),
                                const SizedBox(height: 15),
                                RaisedButton(onPressed: (){
                                  if(_formKey.currentState.saveAndValidate()){
                                    print(_formKey.currentState.value);
                                  }
                                })
                              ],
                            ),
                          ),*/

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
                      Container(height: 20,),
                      // create button to save the data
                      MaterialButton(
                        textColor: Colors.white,
                        color: Colors.blueAccent,
                        onPressed: () async {
                          print("$boost  $price.");
                        },
                        child: Text("Add Annonces"),
                      )
                    ],
                  )
              )
            ],
          ),

        ),
      ),
    );
  }
}
