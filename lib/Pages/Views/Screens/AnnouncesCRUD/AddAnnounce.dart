import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/CustomButton.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsFeaturesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AnnounceModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CategoryModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CitiesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CountriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CreateAnnounceModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/FeaturesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/FeaturesValuesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/ImageModel.dart';
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
  TextEditingController details = new TextEditingController();
  TextEditingController images = new TextEditingController();
  bool? boost;


  // category variabales
  List<CategoriesModel> _categorys =[];
  CategoriesModel? _category;
  int CategoryId=0;
  CategoriesModel? selectedCategory;


  //country Variables
  List<CountriesModel> _countrys=[];
  CountriesModel? _country ;
  int CountryId=0;

  // city variables
  List<CitiesModel> _cities=[];
  CitiesModel? _city;

  //features variables
  List<FeaturesModel> _features=[];
  FeaturesModel? _feature;
  int FeatureId=0;
  int indexOfFeature=0;

  //FeaturesValues variables
  List<FeaturesValuesModel> _featuresValues=[];
  FeaturesValuesModel? _featurevalue;

  String? error ="";

// Function to create the announce object
  CreateAnnounce? announce;
  void createAnnounceObject() {

    if(title.toString().isNotEmpty && description.toString().isNotEmpty &&
        (details!=null && details.text.length!=0) && price.toString().isNotEmpty
        && CategoryId!=0 && _country!=null  && _city!=null && _imagesid.length!=0 ){
      announce = CreateAnnounce(
        title: title.text,
        description: description.text,
        details: details.text,
        price: int.parse(price.text),
        imagePrinciple: _imagesid[0].title,
        idCateg: CategoryId,
        idCountrys: _country!.idCountrys!,
        idCity: _city!.idCity!,
        locations: "${_country!.title}, ${_city!.title}",

        //images:_image,
        active: 1,
      );
        error="";
    }else{
        error="pleace complete all the form ";
    }
  }

  // get the features of the announce
  List<ListFeaturesFeatureValues> getFeatures() {

    List<ListFeaturesFeatureValues> lst = [];
    _features.forEach((f) {
      if (f.selected == true && f.value != null) {
        ListFeaturesFeatureValues lfv = ListFeaturesFeatureValues(
          featureId: int.parse(f.idF.toString()),
          featureValueId: int.parse(f.value.toString()),
        );
        lst.add(lfv);
      }
    });
    return lst;
  }



//pick the image
  //image picker
  List<File> _image = [];
  List<ImageModel> _imagesid=[];

  Future getImage(source) async{
    final image = await ImagePicker().pickImage(source: source);
    if (image==null) return ;
    final imageTemporary = File(image.path);
    ImageModel response = await ImageModel().addImage(imageTemporary);
    // Handle the response as needed
    print(response);
    setState(() {
      this._imagesid.add(response);
      this._image.add(imageTemporary);
    });
  }

  //save the announce
  void sendAdToApi() async {
    //create the Announce
    CreateAnnounce();
    CreateAnnounce an = CreateAnnounce();
    Map<String, dynamic> response = await an.createAd(announce!);
    // Handle the response as needed
    print(response);
    //save features values
    var x =AnnounceModel.fromJson(response);
    List<ListFeaturesFeatureValues> lfv = getFeatures();
    print(lfv);
    if(lfv!=null && lfv.length!=0){
      lfv.forEach((element) async {
        CreateAdsFeature fd =
        new CreateAdsFeature(idAds: int.parse(x.idAds.toString()),idFeature: int.parse(element.featureId.toString()),idFeaturesValues: int.parse(element.featureValueId.toString()),active: 1);
        print(fd.toJson());
        await fd.Createadsfeature(fd);
        //print(fvres);
      });
    }
    print("//////////////////////// : ${_imagesid!.length}");
    print("//////////////////////// : ${_imagesid[0].IdImage}");
    //update the images
    for(var i=0;i<_imagesid!.length;i++){
      print(int.parse(_imagesid[i].IdImage.toString()));
      await ImageModel().UpdateImages(int.parse(_imagesid[i].IdImage.toString()), int.parse(x.idAds.toString()));
    }
  }


  @override
  void initState()  {
    super.initState();
    fetchCities(CountryId);
    fetchCountries();
    fetchFeatures(CategoryId);
    fetchFeaturesValues(FeatureId);
    fetchData();

    //_country=widget.country;
  }

  /** fetch categorys */
  Future<void> fetchData() async {
    try {
      List<CategoriesModel> categories = await CategoriesModel().GetData();
      setState(() {
        _categorys = categories;
      });

    } catch (e) {
      print('Error fetching categories: $e');
    }
  }
  /** fetch countrys */
  Future<void> fetchCountries() async {
    try {
      List<CountriesModel> countries = await CountriesModel().GetData();
      setState(() {
        _countrys = countries;
      });

    } catch (e) {
      print('Error fetching countrys: $e');
    }
  }
  /** fetch Cities */
  Future<void> fetchCities(int id) async {
    try {
      List<CitiesModel> cities = await CitiesModel().GetData(id);
      setState(() {
        _cities = cities;

      });

    } catch (e) {
      print('Error fetching Cites: $e');
    }
  }

  /** fetch Features */
  Future<void> fetchFeatures(int idcateg) async {
    try {
      List<FeaturesModel> features = await FeaturesModel().GetData(idcateg);
      setState(() {
        _features = features;
      });
    } catch (e) {
      print('Error fetching Features: $e');
    }
  }

  /** fetch Features Values */
  Future<void> fetchFeaturesValues(int idfeature) async {
    try {
      List<FeaturesValuesModel> featuresValues = await FeaturesValuesModel().GetData(idfeature);
      setState(() {
        _featuresValues = featuresValues;
        if(_features[indexOfFeature].selected==true){
          _features[indexOfFeature].valuesList=_featuresValues;
        }else{
          _features[indexOfFeature].valuesList=[];
        }

      });
      //print(featuresValues);
    } catch (e) {
      print('Error fetching Features Values : $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.blueGrey[100],
      appBar: MyAppBar(Daimons: 122,title: "Add Announce",),
      body: Container(
        child: ListView(
          children: [
            SizedBox(height: 20,),
            Center(
                child: Text("Create your announce :",
                  style: TextStyle(

                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.black,
                  )
                  ),
            ),
            SizedBox(height: 30,),
            // create a form
            Container(
              /*decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black.withOpacity(0.15),
                ),
                color: Colors.white
              ),*/
              child: Form(
                  key: formstate,
                  child:
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 18.0, 10, 3),
                        child: TextFormField(
                          controller: title,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(width: 2, color: Colors.indigo),

                          ),
                              hintText: "title"
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 18.0, 10, 3),
                        child: TextFormField(
                          controller: description,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(width: 2, color: Colors.indigo),

                              ),
                              hintText: "Description"
                          ),
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 18.0, 10, 3),
                        child: TextFormField(
                          controller: details,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(width: 2, color: Colors.indigo),

                              ),
                              hintText: "Details"
                          ),
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 18.0, 10, 3),
                        child: TextFormField(
                          controller: price,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(width: 2, color: Colors.indigo),

                              ),
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
                              _image.length != 0
                                  ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: _image.map((img) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 300,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black.withOpacity(0)),
                                    ),
                                    child: Image.file(
                                      img!,
                                      height: 400,
                                      fit: BoxFit.fill,
                                    ),
                                  );
                                }).toList(),
                              )
                                  :
                              Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      height: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.black.withOpacity(0)
                                        ),

                                        image: DecorationImage(

                                          image: AssetImage("assets/images/vide.png"),
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
                      /** country and city*/
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /** Countrys list */
                          Container(
                            margin:EdgeInsets.fromLTRB(10, 30, 10, 0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: FutureBuilder<List<CountriesModel>>(
                              future: CountriesModel().GetData(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  //_countrys = snapshot.data!;

                                  //_country=_countrys![0];
                                  if (_countrys != null && _countrys!.isNotEmpty) {
                                    return Column(
                                      children: [

                                        Container(
                                          child:DropdownButton(
                                            padding: EdgeInsets.symmetric(horizontal: 7),
                                            disabledHint: Text("Select Country"),
                                            value: _country!=null?_country:_countrys[0],
                                            items: _countrys!.map((e) => DropdownMenuItem<CountriesModel>(
                                              child:
                                              Text(e.title.toString()
                                              ),
                                              value: e,)).toList(),

                                            onChanged:(CountriesModel? val){
                                              setState(() {
                                                _country=val;
                                                CountryId=int.parse(val!.idCountrys.toString());
                                                fetchCities(CountryId);
                                              });
                                            },
                                            icon: Icon(Icons.map_outlined),
                                            iconEnabledColor: Colors.indigo,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18
                                            ),
                                            borderRadius: BorderRadius.circular(10),
                                          ), //
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Text('No data available');
                                  }
                                }
                              },
                            ),
                          ),
                          /** Cities list */
                          if(CountryId!=0 && _cities.isNotEmpty)
                            Container(
                              margin:EdgeInsets.fromLTRB(10, 30, 10, 0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FutureBuilder<List<CitiesModel>>(
                                future: CitiesModel().GetData(CountryId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    //print(_cities);
                                    //_countrys = snapshot.data!;

                                    //_country=_countrys![0];
                                    if (_cities.length!=0&& _cities!.isNotEmpty) {
                                      return Column(
                                        children: [

                                          Container(
                                            child:DropdownButton(
                                              padding: EdgeInsets.symmetric(horizontal: 7),
                                              disabledHint: Text("Select Cities"),
                                              value: _city!=null?_city:_cities[0],
                                              items: _cities!.map((e) => DropdownMenuItem<CitiesModel>(
                                                child:
                                                Text(e.title.toString()
                                                ),
                                                value: e,)).toList(),

                                              onChanged:(CitiesModel? city){
                                                setState(() {
                                                  _city=city;
                                                });
                                              },
                                              icon: Icon(Icons.map_outlined),
                                              iconEnabledColor: Colors.indigo,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18
                                              ),
                                              borderRadius: BorderRadius.circular(10),
                                            ), //
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Text('No data available');
                                    }
                                  }
                                },
                              ),
                            ),
                        ],
                      ),

                      /** Category && Features */

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin:EdgeInsets.fromLTRB(10, 30, 10, 0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:/** dropdown list of categorys **/
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: FutureBuilder<List<CategoriesModel>>(
                                future: CategoriesModel().GetData(),
                                builder: (BuildContext context, AsyncSnapshot<List<CategoriesModel>> snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    // Display a loading indicator while waiting for data
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    // Handle the error case
                                    return Text('Failed to fetch data');
                                  } else {
                                    return
                                      DropdownButton<CategoriesModel>(
                                        padding: EdgeInsets.symmetric(horizontal: 7),
                                        disabledHint: Text("Categorys"),
                                        value: _category!=null?_category:_categorys[0],
                                        items: _categorys.map((e) => DropdownMenuItem<CategoriesModel>(child: Text(e.title.toString()),value: e,)).toList(),
                                        onChanged:(CategoriesModel? x){
                                          setState(() {
                                            _category=x;
                                            CategoryId=int.parse(x!.idCateg.toString());
                                            fetchFeatures(CategoryId);
                                          });
                                        },
                                        icon: Icon(Icons.category_outlined),
                                        iconEnabledColor: Colors.indigo,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      );
                                    //
                                  }
                                },
                              ),
                            ),

                          ),
                        ],
                      ),SizedBox(height: 20,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (CategoryId != 0 && _features.isNotEmpty)
                          /** features list */
                        ..._features.asMap().entries.map((entry) {
                          int index = entry.key;
                          FeaturesModel f = entry.value;
                          return Column(
                            children: [
                              SizedBox(width: 10),
                              Text(
                                f.title.toString(),
                                style: TextStyle(fontSize: 17.0),
                              ),
                              SizedBox(width: 3),
                              Checkbox(
                                value: f.selected,
                                onChanged: (x) {
                                  setState(() {
                                    //print(_features[0].valuesList);
                                    f.selected = x as bool;
                                    indexOfFeature=index;
                                    FeatureId=int.parse(f.idF.toString());
                                    fetchFeaturesValues(FeatureId);
                                  });
                                },
                              ),
                              if(f.valuesList!.isNotEmpty)
                                ...f.valuesList!.map((fv) =>
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height:30,
                                              width:150,
                                              child:
                                              RadioListTile(
                                                title: Text(fv.title.toString()),
                                                value: fv.idFv,
                                                groupValue: f.value,
                                                onChanged: (value){
                                                  setState(() {
                                                    f.value=value;
                                                    print(f.value);
                                                  });
                                                },
                                              ),
                                            ),

                                          ],
                                        ),
                                      ],
                                    ),
                                ).toList(),
                              SizedBox(height: 30,)
                            ],
                          );
                        }).toList(),
                          SizedBox(width: 10),
                        ],
                      ),



                      /*
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
                                //print(boost);
                              });
                            },
                          ),
                        ],
                      ),
                      //end radio button
                       */
                      SizedBox(height: 20,),
                      // create button to save the data
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14.0),
                        child: MaterialButton(
                          textColor: Colors.white,
                          color: Colors.indigo,
                          onPressed: () async {
                            createAnnounceObject();
                           if(error!.isNotEmpty){
                              print(error);

                              AwesomeDialog(
                                  context: context,
                                  dialogBackgroundColor: Colors.teal[100],
                                  dialogType: DialogType.warning,
                                  animType: AnimType.topSlide,
                                  title:"Error !",
                                  descTextStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                  desc: error.toString(),
                                  btnCancelColor: Colors.grey,
                                  btnCancelOnPress:(){},

                                  btnOkOnPress: (){}
                              ).show();
                            }else{
                              //Map<String, dynamic> adData = announce!.toJson();
                              //print(adData);
                              sendAdToApi();
                              Navigator.pop(context);
                            }
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
