import 'dart:ffi';

import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:flutter/material.dart';

class EditeAnnounce extends StatefulWidget {
  final id;
  final title;
  final description;
  final price;
  final image;
  final boosted;

  const EditeAnnounce({super.key, this.id, this.title, this.description, this.price, this.image, this.boosted});

  @override
  State<EditeAnnounce> createState() => _EditeAnnounceState();
}

class _EditeAnnounceState extends State<EditeAnnounce> {

  final formstate = GlobalKey<FormState>();
  TextEditingController title = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController images = new TextEditingController();

  @override
  void initState() {
  title.text=widget.title;
  description.text=widget.description;
  price.text = widget.price.toString();
  images.text=widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(Daimons: 122,title: "Edite Announce",),
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
                      Container(height: 20,),
                      // create button to save the data
                      MaterialButton(
                        textColor: Colors.white,
                        color: Colors.blueAccent,
                        onPressed: () async {
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
