import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/MyAppBAr.dart';
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
import 'package:ecommerceversiontwo/Pages/core/services/CategoriesServices/CategoryService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/CityServices/CityService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/CountriesServices/CountryService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/FeaturesServices/FeaturesService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/FeaturesValuesServices/FeaturesValuesService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/ImageServices/ImageService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditeAnnounce extends StatefulWidget {
  AnnounceModel? announce;

  EditeAnnounce({this.announce});

  @override
  State<EditeAnnounce> createState() => _EditeAnnounceState();
}

class _EditeAnnounceState extends State<EditeAnnounce> {
  GlobalKey<FormState> _AdsFormKey = GlobalKey<FormState>();
  TextEditingController title = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController details = new TextEditingController();
  TextEditingController images = new TextEditingController();

  //bool? boost;

  // category variabales
  List<CategoriesModel> _categorys = [];
  CategoriesModel? _category;
  int CategoryId = 0;
  CategoriesModel? selectedCategory;

  //country Variables
  List<CountriesModel> _countrys = [];
  CountriesModel? _country;

  int CountryId = 0;

  // city variables
  List<CitiesModel> _cities = [];
  CitiesModel? _city;

  //features variables
  List<FeaturesModel> _features = [];
  int FeatureId = 0;
  int indexOfFeature = 0;

  //FeaturesValues variables
  List<FeaturesValuesModel> _featuresValues = [];

  //AdsFeatures Variables
  List<AdsFeature> _AdsFeatures = [];
  String? error = "";

  int? idUser;

  Future<int> getuserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var decodedToken = JwtDecoder.decode(token!);
    idUser = int.parse(decodedToken['id']);
    print("id user is $idUser");
    return idUser!;
  }

// Function to create the announce object
  CreateAnnounce? announce;

  void createAnnounceObject(int userid) async {
    await getuserId();
    if (title.toString().isNotEmpty &&
        description.toString().isNotEmpty &&
        (details != null && details.text.length != 0) &&
        price.toString().isNotEmpty &&
        CategoryId != 0 &&
        _country != null &&
        _city != null &&
        _imagesid.length != 0) {
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
        IdUser: userid,
        active: 0,
      );
      if (widget.announce!.IdBoost != null) {
        announce!.IdBoost = widget.announce!.IdBoost;
      }
      error = "";
    } else {
      error = "pleace complete all the form ";
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
  List<ImageModel> _AnnounceImages = [];
  List<File> _image = [];
  List<ImageModel> _imagesid = [];

  Future getImage(source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
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
    AnnounceModel? response = await AnnounceService()
        .updateAnnouncement(widget.announce!.idAds!, announce!);

    //save features values
    var x = response;
    List<ListFeaturesFeatureValues> lfv = getFeatures();
    bool resDele =
        await AdsFeaturesService().deleteData(widget.announce!.idAds!);

    if (resDele && lfv != null && lfv.length != 0) {
      lfv.forEach((element) async {
        CreateAdsFeature fd = new CreateAdsFeature(
            idAds: int.parse(x!.idAds.toString()),
            idFeature: int.parse(element.featureId.toString()),
            idFeaturesValues: int.parse(element.featureValueId.toString()),
            active: 1);
        await AdsFeaturesService().Createfeature(fd);
      });
    }

    //update the images
    for (var i = 0; i < _imagesid!.length; i++) {
      await ImageService().UpdateImages(
          int.parse(_imagesid[i].IdImage.toString()),
          int.parse(x!.idAds.toString()));
    }
    return response!;
  }

  @override
  void initState() {
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
      List<CategoriesModel> categories = await CategoryService().GetData();
      CategoriesModel? targetCategory =
          findCategoryById(categories, widget.announce!.idCateg!);

      if (targetCategory != null) {
        setState(() {
          _categorys = categories;
          _category = targetCategory;
          fetchFeatures(targetCategory.idCateg!);
        });
      } else {
        print('Category with ID ${widget.announce!.idCateg!} not found.');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  CategoriesModel? findCategoryById(
      List<CategoriesModel> categories, int targetId) {
    for (var category in categories) {
      if (category.idCateg == targetId) {
        return category;
      }

      if (category.children != null && category.children!.isNotEmpty) {
        CategoriesModel? childResult =
            findCategoryById(category.children!, targetId);
        if (childResult != null) {
          return childResult;
        }
      }
    }

    return null;
  }

  /** fetch countrys */
  Future<void> fetchCountries() async {
    try {
      List<CountriesModel> countries = await CountrySerice().GetData();
      setState(() {
        _countrys = countries;
        _country = _countrys
            .firstWhere((co) => co.idCountrys == widget.announce!.idCountrys!);
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
        _city =
            _cities.firstWhere((ct) => ct.idCity == widget.announce!.idCity!);
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
      List<FeaturesValuesModel> featuresValues =
          await FeaturesValuesService().GetData(idfeature);
      setState(() {
        _featuresValues = featuresValues;

        _AdsFeatures.forEach((af) {
          _featuresValues.forEach((fv) {
            if (af.idFeaturesValues == fv.idFv) {
              fv.selected = true;
            }
          });
        });
        if (_features[indexOfFeature].selected == true) {
          _features[indexOfFeature].valuesList = _featuresValues;
        } else {
          _features[indexOfFeature].valuesList = [];
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
          _AnnounceImages.add(element);
        });
      });
    } catch (e) {
      print('Error fetching Images: $e');
    }
  }

  /** fetch Ads features and chnage the features and the features values */
  Future<void> fetchAdsFeaturesByIDAds(int idAds) async {
    try {
      List<AdsFeature> AfList =
          await AdsFeaturesService().GetAdsFeaturesByIdAds(idAds);

      _AdsFeatures = AfList;
      //print(_AdsFeatures);
    } catch (e) {
      print('Error fetching AdsFeatures: $e');
    }
  }

  /** Category DropDown Items */
  List<DropdownMenuItem<CategoriesModel>> buildDropdownItems(
      List<CategoriesModel> categories,
      {String? parentTitle}) {
    List<DropdownMenuItem<CategoriesModel>> items = [];

    for (var category in categories) {
      String label = parentTitle != null
          ? "$parentTitle / ${category.title}"
          : category.title!;
      items.add(DropdownMenuItem<CategoriesModel>(
        child: Text(label),
        value: category,
      ));

      if (category.children != null && category.children!.isNotEmpty) {
        items.addAll(buildDropdownItems(category.children!,
            parentTitle: category.title));
      }
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.blueGrey[100],
      appBar: MyAppBar(
        title: "Add Announce",
      ),
      body: Container(
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text("Edite your announce :",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.black,
                  )),
            ),
            SizedBox(
              height: 30,
            ),
            // create a form
            Container(
              child: Form(
                  key: _AdsFormKey,
                  child: Column(
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
                              hintText: "title"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Title is required';
                            }
                            return null;
                          },
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
                              hintText: "Description"),
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 2,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Description is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 18.0, 10, 3),
                        child: TextFormField(
                            controller: details,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.indigo),
                                ),
                                hintText: "Details"),
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Details is required';
                              }
                              return null;
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 18.0, 10, 3),
                        child: TextFormField(
                          controller: price,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}$')),
                          ],
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.indigo),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 20),
                            hintText: "Price",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Price is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "add Announce Image :",
                        style: TextStyle(
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
                              _AnnounceImages.length != 0
                                  ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: _AnnounceImages.asMap()
                                    .entries
                                    .map((entry) {
                                  int index = entry.key;
                                  String img = entry.value.title!;
                                  return Column(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width,
                                        height: 300,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.black
                                                  .withOpacity(0)),
                                        ),
                                        child: Stack(
                                          children: [
                                            Image.network(
                                              ApiPaths().ImagePath + img,
                                              height: 400,
                                              width: 420,
                                              fit: BoxFit.fill,
                                            ),
                                          ],
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          bool res = await ImageService()
                                              .deleteImage(entry.value.IdImage!);

                                          setState(() {
                                            _AnnounceImages.remove(entry.value);
                                            _imagesid.remove(entry.value);
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.red,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.delete,
                                                color: Colors.white),
                                            SizedBox(width: 8),
                                            Text(
                                              "Delete",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              )
                                  : SizedBox(height: 0),
                              _image.length != 0
                                  ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children:
                                _image.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  File img = entry.value;
                                  return Column(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 300,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.black
                                                  .withOpacity(0)),
                                        ),
                                        child: Stack(
                                          children: [
                                            Image.file(
                                              img,
                                              height: 400,
                                              fit: BoxFit.fill,
                                            ),
                                          ],
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          bool res = await ImageService()
                                              .deleteImage(
                                              _imagesid[index].IdImage!);

                                          setState(() {
                                            _AnnounceImages.removeWhere((i) =>i.IdImage== _imagesid[index].IdImage);
                                            _imagesid.removeWhere((i) =>i.IdImage== _imagesid[index].IdImage);
                                            _image.remove(entry.value);
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.red,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.delete,
                                                color: Colors.white),
                                            SizedBox(width: 8),
                                            Text(
                                              "Delete",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 30),
                                    ],
                                  );
                                }).toList(),
                              )
                                  : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  if (_AnnounceImages.length == 0)
                                    Container(
                                      height: 300,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.black
                                                .withOpacity(0)),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/vide.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  SizedBox(height: 30),
                                ],
                              ),
                              CostumButton(
                                title: "Pick an Image",
                                iconName: Icons.image_outlined,
                                onClick: () => getImage(ImageSource.gallery),
                              ),
                              CostumButton(
                                title: "Take a picture",
                                iconName: Icons.camera,
                                onClick: () => getImage(ImageSource.camera),
                              ),
                            ],
                          ),
                        ),
                      ),
                     /* Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                          child: Column(
                            children: [
                              _AnnounceImages.length != 0
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: _AnnounceImages.asMap()
                                          .entries
                                          .map((entry) {
                                        int index = entry.key;
                                        String img = entry.value.title!;
                                        return Column(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 300,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.black
                                                        .withOpacity(0)),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Image.network(
                                                    ApiPaths().ImagePath + img,
                                                    height: 400,
                                                    width: 420,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                bool res = await ImageService()
                                                    .deleteImage(
                                                        entry.value.IdImage!);

                                                setState(() {
                                                  _AnnounceImages.remove(
                                                      entry.value);
                                                  _imagesid.remove(entry.value);
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.red,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.delete,
                                                      color: Colors.white),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    )
                                  : SizedBox(
                                      height: 0,
                                    ),
                              _image.length != 0
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: _image.map((img) {
                                        return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 300,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.black
                                                    .withOpacity(0)),
                                          ),
                                          child: Image.file(
                                            img!,
                                            height: 400,
                                            fit: BoxFit.fill,
                                          ),
                                        );
                                      }).toList(),
                                    )
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                          if (_AnnounceImages.length == 0)
                                            Container(
                                              height: 300,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.black
                                                        .withOpacity(0)),
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/images/vide.png"),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                        ]),
                              SizedBox(
                                height: 30,
                              ),
                              CostumButton(
                                  title: "Pick an Image",
                                  iconName: Icons.image_outlined,
                                  onClick: () => getImage(ImageSource.gallery)),
                              CostumButton(
                                  title: "Take picture ",
                                  iconName: Icons.camera,
                                  onClick: () => getImage(ImageSource.camera)),
                            ],
                          ),
                        ),
                      ),*/
                      //end of image picker
                      /** country and city*/
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /** Countrys list */
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: FutureBuilder<List<CountriesModel>>(
                              future: CountrySerice().GetData(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  //_countrys = snapshot.data!;

                                  //_country=_countrys![0];
                                  if (_countrys != null &&
                                      _countrys!.isNotEmpty) {
                                    return Column(
                                      children: [
                                        Container(
                                          child: DropdownButton(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 7),
                                            disabledHint:
                                                Text("Select Country"),
                                            value: _country,
                                            items: _countrys!
                                                .map((e) => DropdownMenuItem<
                                                        CountriesModel>(
                                                      child: Text(
                                                          e.title.toString()),
                                                      value: e,
                                                    ))
                                                .toList(),
                                            onChanged: (CountriesModel? val) {
                                              setState(() {
                                                _country = val;
                                                CountryId = int.parse(
                                                    val!.idCountrys.toString());
                                                fetchCities(CountryId);
                                              });
                                            },
                                            icon: Icon(Icons.map_outlined),
                                            iconEnabledColor: Colors.indigo,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                          if (CountryId != 0 && _cities.length > 0)
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FutureBuilder<List<CitiesModel>>(
                                future: CityService().GetData(CountryId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    //print(_cities);
                                    //_countrys = snapshot.data!;

                                    //_country=_countrys![0];
                                    if (_cities.length != 0 &&
                                        _cities!.isNotEmpty) {
                                      return Column(
                                        children: [
                                          Container(
                                            child: DropdownButton(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 7),
                                              disabledHint:
                                                  Text("Select Cities"),
                                              value: _city != null
                                                  ? _city
                                                  : _cities[0],
                                              items: _cities!
                                                  .map((e) => DropdownMenuItem<
                                                          CitiesModel>(
                                                        child: Text(
                                                            e.title.toString()),
                                                        value: e,
                                                      ))
                                                  .toList(),
                                              onChanged: (CitiesModel? city) {
                                                setState(() {
                                                  _city = city;
                                                });
                                              },
                                              icon: Icon(Icons.map_outlined),
                                              iconEnabledColor: Colors.indigo,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ), //
                                          ),
                                        ],
                                      );
                                    } else {
                                      return SizedBox(
                                        height: 0,
                                      );
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
                            margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: /** dropdown list of categorys **/
                                Padding(
                              padding: const EdgeInsets.all(0),
                              child: FutureBuilder<List<CategoriesModel>>(
                                future: CategoryService().GetData(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<CategoriesModel>>
                                        snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Display a loading indicator while waiting for data
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    // Handle the error case
                                    return Text('Failed to fetch data');
                                  } else {
                                    return DropdownButton<CategoriesModel>(
                                      value: _category ?? _categorys[0],
                                      items: buildDropdownItems(_categorys),
                                      onChanged: (CategoriesModel? x) {
                                        setState(() {
                                          _category = x;
                                          CategoryId = x!.idCateg!;
                                          fetchFeatures(CategoryId);
                                        });
                                      },
                                      icon: Icon(Icons.category_outlined),
                                      iconEnabledColor: Colors.indigo,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      borderRadius: BorderRadius.circular(10),
                                    );
                                    //
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
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
                                    ..._features.asMap().entries.map((entry) {
                                      int index = entry.key;
                                      FeaturesModel f = entry.value;
                                      return Column(
                                        children: [
                                          SizedBox(height: 10),
                                          Text(
                                            f.title.toString(),
                                            style: TextStyle(fontSize: 17.0),
                                          ),
                                          SizedBox(height: 3),
                                          Checkbox(
                                            value: f.selected,
                                            onChanged: (x) {
                                              setState(() {
                                                f.selected = x as bool;
                                                indexOfFeature = index;
                                                FeatureId =
                                                    int.parse(f.idF.toString());
                                                fetchFeaturesValues(FeatureId);
                                              });
                                            },
                                          ),
                                          if (f.valuesList!.isNotEmpty)
                                            ...f.valuesList!
                                                .map(
                                                  (fv) => Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Radio(
                                                                value: fv.idFv,
                                                                groupValue:
                                                                    f.value,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    f.value =
                                                                        value;
                                                                    //print(featuresvalues);
                                                                  });
                                                                },
                                                              ),
                                                              Text(
                                                                fv.title
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      17.0,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          SizedBox(height: 30),
                                        ],
                                      );
                                    }).toList(),
                                  SizedBox(height: 10),
                                ],
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // create button to save the data
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14.0),
                        child: MaterialButton(
                          textColor: Colors.white,
                          color: Colors.indigo,
                          onPressed: () async {
                            if (_AdsFormKey.currentState!.validate()) {
                              if (CategoryId != 0 && _country != null && _city != null &&
                                  _imagesid.length != 0) {
                                await getuserId().then((value) {
                                  createAnnounceObject(value);
                                });
                              } else {
                                // setState(() {
                                error =
                                "Pleaser complete the  Form First";
                                // });
                                AwesomeDialog(
                                  context: context,
                                  dialogBackgroundColor: Colors.teal[100],
                                  dialogType: DialogType.warning,
                                  animType: AnimType.topSlide,
                                  title: "Erreur !",
                                  descTextStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  desc: error.toString(),
                                  btnCancelColor: Colors.grey,
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {
                                    setState(() {
                                      error = "";
                                    });
                                  },
                                ).show();
                                return;
                              }

                              if (error!.isNotEmpty) {
                                print(error);

                                AwesomeDialog(
                                  context: context,
                                  dialogBackgroundColor: Colors.teal[100],
                                  dialogType: DialogType.warning,
                                  animType: AnimType.topSlide,
                                  title: "Error !",
                                  descTextStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  desc: error.toString(),
                                  btnCancelColor: Colors.grey,
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {},
                                ).show();
                              } else {
                                /* Map<String, dynamic> adData = deals!.toJson();
                                print(adData);*/
                                AnnounceModel adsRes = await UpdateAnnounce();
                                Navigator.pop(context, {"NewAd": adsRes});
                              }
                            }
                          },
                          child: Text(
                            "Edite Annonces",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
