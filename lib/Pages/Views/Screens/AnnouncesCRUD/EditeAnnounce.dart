
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/CustomButton.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsFeaturesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AnnounceModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CategoriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CitiesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CountriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/CreateAnnounceModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/FeaturesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/FeaturesValuesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/ImageModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/AdsFeaturesServices/AdsFeaturesService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/AnnouncesServices/AnnounceService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/CityServices/CityService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/CountriesServices/CountryService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/FeaturesServices/FeaturesService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/FeaturesValuesServices/FeaturesValuesService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/ImageServices/ImageService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditeAnnounce extends StatefulWidget {
  AnnounceModel? announce;

  EditeAnnounce({ this.announce});

  @override
  State<EditeAnnounce> createState() => _EditeAnnounceState();
}

class _EditeAnnounceState extends State<EditeAnnounce> {

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
  int FeatureId=0;
  int indexOfFeature=0;

  //FeaturesValues variables
  List<FeaturesValuesModel> _featuresValues=[];

  //AdsFeatures Variables
  List<AdsFeature> _AdsFeatures = [];
  String? error ="";



  int? idUser ;

  Future<int> getuserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var decodedToken = JwtDecoder.decode(token!);
    idUser = int.parse(decodedToken['id']);
    print("id user is $idUser");
    return idUser!;
  }
// Function to create the announce object
  CreateAnnounce? announce ;
  void createAnnounceObject(int userid)  async {
    await getuserId();
    if(title.toString().isNotEmpty && description.toString().isNotEmpty &&
        (details!=null && details.text.length!=0) && price.toString().isNotEmpty
        && CategoryId!=0 && _country!=null  && _city!=null && _imagesid.length!=0 ){
      announce =  CreateAnnounce(
        title: title.text,
        description: description.text,
        details: details.text,
        price: int.parse(price.text),
        imagePrinciple: _imagesid[0].title,
        idCateg: CategoryId,
        idCountrys: _country!.idCountrys!,
        idCity: _city!.idCity!,
        locations: "${_country!.title}, ${_city!.title}",
        IdUser: userid,
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
    //print(lst[0]);
    return lst;
  }



//pick the image
  //image picker
  List<String> _AnnounceImages = [];
  List<File> _image = [];
  List<ImageModel> _imagesid=[];

  Future getImage(source) async{
    final image = await ImagePicker().pickImage(source: source);
    if (image==null) return ;
    final imageTemporary = File(image.path);
    ImageModel response = await ImageService().addImage(imageTemporary);
    setState(() {
      this._imagesid.add(response);
      this._image.add(imageTemporary);
    });
  }

  //update the announce
  Future<AnnounceModel> UpdateAnnounce() async {
    //create the Announce
     await CreateAnnounce();
    // print(widget.announce!.idAds!);
    AnnounceModel? response = await AnnounceService().updateAnnouncement(widget.announce!.idAds!,announce!);
    // Handle the response as needed
    //print(response);

    //save features values
    var x =response;
     List<ListFeaturesFeatureValues> lfv = getFeatures();
     if(lfv.length!=0) {
       bool resDele = await AdsFeaturesService().deleteData(
           widget.announce!.idAds!);


       //print(lfv);
       if (resDele && lfv != null && lfv.length != 0) {
         lfv.forEach((element) async {
           CreateAdsFeature fd =
           new CreateAdsFeature(idAds: int.parse(x!.idAds.toString()),
               idFeature: int.parse(element.featureId.toString()),
               idFeaturesValues: int.parse(element.featureValueId.toString()),
               active: 1);
           //print(fd.toJson());
           await AdsFeaturesService().Createfeature(fd);
         });
       }
     }
   // print("//////////////////////// : ${_imagesid!.length}");
    //print("//////////////////////// : ${_imagesid[0].IdImage}");
    //update the images
    for(var i=0;i<_imagesid!.length;i++){
     // print(int.parse(_imagesid[i].IdImage.toString()));
      await ImageService().UpdateImages(int.parse(_imagesid[i].IdImage.toString()), int.parse(x!.idAds.toString()));
    }
    return response!;
  }


  @override
  void initState()  {
    super.initState();
    fetchAdsFeaturesByIDAds(widget.announce!.idAds!);
    fetchCountries();
    fetchImages(widget.announce!.idAds!);

    fetchData();

    title.text = widget.announce!.title!;
    description.text = widget.announce!.description!;
    details.text = widget.announce!.details!;
    price.text = widget.announce!.price!.toString();
    images.text = widget.announce!.imagePrinciple!;
    CategoryId = widget.announce!.idCateg!;
    CountryId = widget.announce!.idCountrys!;


    fetchFeatures(CategoryId);
    fetchCities(CountryId);


    fetchFeaturesValues(FeatureId);
  }


  /** fetch categorys */
  Future<void> fetchData() async {
    try {
      List<CategoriesModel> categories = await CategoriesModel().GetData();

      setState(() {
        _categorys = categories;
        _category=_categorys.firstWhere((c) => c.idCateg==widget.announce!.idCateg!);
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  /** fetch countrys */
  Future<void> fetchCountries() async {
    try {
      List<CountriesModel> countries = await CountrySerice().GetData();
      setState(() {
        _countrys = countries;
        _country= _countrys.firstWhere((co) => co.idCountrys==widget.announce!.idCountrys! );
      });

    } catch (e) {
      print('Error fetching countrys: $e');
    }
  }

  /** fetch Cities */
  Future<void> fetchCities(int id) async {
    try {
      List<CitiesModel> cities = await CityService().GetData(id);
      setState(() {
        _cities = cities;
        _city = _cities.firstWhere((ct) => ct.idCity == widget.announce!.idCity!);

      });

    } catch (e) {
      print('Error fetching Cites: $e');
    }
  }

  /** fetch Features */
  Future<void> fetchFeatures(int idcateg) async {
    try {
      List<FeaturesModel> features = await FeaturesService().GetData(idcateg);
      setState(() {
        _features = features;
      });

      for (var af in _AdsFeatures) {
        for (var f in _features) {
          if (f.idF == af.idFeature) {
            f.selected = true;
            FeatureId = f.idF!;
            f.value = af.idFeaturesValues;
            indexOfFeature = _features.indexOf(f);
            await fetchFeaturesValues(FeatureId);
          }
        }
      }
    } catch (e) {
      print('Error fetching Features: $e');
    }
  }

  /** fetch Features Values */
  Future<void> fetchFeaturesValues(int idfeature) async {
    try {
      List<FeaturesValuesModel> featuresValues = await FeaturesValuesService().GetData(idfeature);
      setState(() {
        _featuresValues = featuresValues;

        _AdsFeatures.forEach((af) {
          _featuresValues.forEach((fv) {
            if(af.idFeaturesValues==fv.idFv){
              fv.selected=true;
            }
          });
        });
        if(_features[indexOfFeature].selected==true){
            _features[indexOfFeature].valuesList=_featuresValues;
        }else{
          _features[indexOfFeature].valuesList=[];
        }
      });
    } catch (e) {
      print('Error fetching Features Values : $e');
    }
  }
  /** fetch Images */
  Future<void> fetchImages(int idAds) async {
    try {
      List<ImageModel> images = await ImageService().apicall(idAds);
      setState(() {
        _imagesid = images;
        images.forEach((element) {
          _AnnounceImages.add(element.title!);
        });
      });
    } catch (e) {
      print('Error fetching Images: $e');
    }
  }
  /** fetch Ads features and chnage the features and the features values */
  Future<void> fetchAdsFeaturesByIDAds(int idAds) async {
    try {
      List<AdsFeature> AfList = await AdsFeaturesService().GetAdsFeaturesByIdAds(idAds);

        _AdsFeatures = AfList;
    } catch (e) {
      print('Error fetching AdsFeatures: $e');
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
              child: Text("Edite your announce :",
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
                              _AnnounceImages.length !=0?
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: _AnnounceImages.map((img) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 300,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black.withOpacity(0)),
                                    ),
                                    child: Image.network(
                                      ApiPaths().ImagePath+img!,
                                      height: 400,
                                      fit: BoxFit.fill,
                                    ),
                                  );
                                }).toList(),
                              ):SizedBox(height: 0,),
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
                              future: CountrySerice().GetData(),
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
                                            value: _country,
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
                          if(CountryId!=0 && _cities.length>0)
                            Container(
                              margin:EdgeInsets.fromLTRB(10, 30, 10, 0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FutureBuilder<List<CitiesModel>>(
                                future: CityService().GetData(CountryId),
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
                                      return SizedBox(height: 0,);
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
                                        value: _category,
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
                      /** features and features values*/
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: FutureBuilder<void>(
                          future:
                              fetchAdsFeaturesByIDAds(widget.announce!.idAds!),
                          builder: (BuildContext context,
                              AsyncSnapshot<void> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // Display a loading indicator while waiting for data
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // Handle the error case
                              return Text('Failed to fetch data');
                            } else {
                              return Column(
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
                                                setState(() {
                                                  f.selected = x as bool;
                                                  indexOfFeature = index;
                                                  FeatureId = int.parse(
                                                      f.idF.toString());
                                                });

                                                fetchFeaturesValues(FeatureId);
                                              });
                                            },
                                          ),
                                          if (f.valuesList!.isNotEmpty)
                                            ...f.valuesList!
                                                .map(
                                                  (fv) => Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            height: 30,
                                                            width: 150,
                                                            child:
                                                                RadioListTile(
                                                              title: Text(fv
                                                                  .title
                                                                  .toString()),
                                                              value: fv.idFv,
                                                              groupValue:
                                                                  f.value,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  f.value =
                                                                      value;
                                                                  //print(f.value);
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                                .toList(),
                                          SizedBox(
                                            height: 30,
                                          )
                                        ],
                                      );
                                    }).toList(),
                                  SizedBox(width: 10),
                                ],
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 20,),
                      // create button to save the data
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14.0),
                        child: MaterialButton(
                          textColor: Colors.white,
                          color: Colors.indigo,
                          onPressed: () async {
                            await getuserId().then((value){
                              createAnnounceObject(value);
                            });
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
                               var res = await UpdateAnnounce();
                              Navigator.pop(context,{'updatedAnnounce':res});
                            }
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


