import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/CustomButton.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsFeaturesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/BrandsModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CategoriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CitiesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CountriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Deals/CreateDealsModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Deals/DealsModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/FeaturesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/FeaturesValuesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/ImageModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/PrizesModels/Prize.dart';
import 'package:ecommerceversiontwo/Pages/core/services/AdsFeaturesServices/AdsFeaturesService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/BrandsServices/BrandsService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/CategoriesServices/CategoryService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/CityServices/CityService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/CountriesServices/CountryService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/DealsServices/DealsService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/FeaturesServices/FeaturesService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/FeaturesValuesServices/FeaturesValuesService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/ImageServices/ImageService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/PrizeServices/PrizeService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateDeals extends StatefulWidget {
  final DealsModel? deal;

  const UpdateDeals({super.key, this.deal});

  @override
  State<UpdateDeals> createState() => _UpdateDealsState();
}

class _UpdateDealsState extends State<UpdateDeals> {
  GlobalKey<FormState> _DealsFormKey = GlobalKey<FormState>();
  TextEditingController title = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController quantity = new TextEditingController();
  TextEditingController discount = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController details = new TextEditingController();
  TextEditingController images = new TextEditingController();
  TextEditingController EndDate = TextEditingController();
  bool? boost;

  /** Prize Form */
  bool addPrize = false;
  GlobalKey<FormState>? _PrizeformKey = GlobalKey<FormState>();
  TextEditingController? prizeTitle = new TextEditingController();
  TextEditingController? prizeDescription = new TextEditingController();
  TextEditingController? prizeImages = new TextEditingController();
  PrizeModel? DealsPrize;

  /** Prize pick the image */
  File? _Prizeimage;

  ImageModel? _Prizeimagesid;

  Future AddPrizeImage(source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    final imageTemporary = File(image.path);
    ImageModel response = await ImageService().addImage(imageTemporary);
    setState(() {
      this._Prizeimagesid = response;
      this._Prizeimage = imageTemporary;
    });
  }

  Future<void> fetchPrizeImages(int? idPrize) async {
    try {
      ImageModel image = await ImageService().getPrizeImage(idPrize!);
      setState(() {
        _Prizeimagesid = image;
      });
    } catch (e) {
      print('Error fetching Prize Images: $e');
    }
  }

  Future<PrizeModel?> GetPrize(int? IdPrize) async {
    if (IdPrize != null) {
      PrizeModel p = await PrizeService().GetPrizeById(IdPrize);
      if (p != null) {
        fetchPrizeImages(p.idPrize!);

        DealsPrize = p;
        prizeTitle!.text = p.title!;
        prizeDescription!.text = p.description!;
        prizeImages!.text = p.image!;
      }
      return p;
    }
    return DealsPrize;
  }

  Future<PrizeModel> AddPrize() async {
    int iduser = await getuserId();
    PrizeModel prize = PrizeModel(
        title: prizeTitle!.text,
        description: prizeDescription!.text,
        image: _Prizeimagesid!.title!,
        datePrize: EndDate.text,
        idUser:iduser,
        active: 1);
    try {
      PrizeModel newprize = await PrizeService().AddPrize(prize);
      if (newprize != null) {
        setState(() {
          DealsPrize = newprize;
        });
        try {
          await ImageService()
              .UpdatePrizeImages(_Prizeimagesid!.IdImage!, newprize!.idPrize!);
        } catch (e) {
          throw Exception("faild to update Prize Image : $e");
        }
      }
      print(DealsPrize);
      print("Prize added successfully.");
      return newprize;
    } catch (e) {
      print("Error adding Prize: $e");
      throw Exception("faild to add Prize :  $e");
    }
  }

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
  FeaturesModel? _feature;
  int FeatureId = 0;
  int indexOfFeature = 0;

  //FeaturesValues variables
  List<FeaturesValuesModel> _featuresValues = [];
  FeaturesValuesModel? _featurevalue;

  //Brands
  List<BrandsModel> _brands = [];
  BrandsModel? _brand;

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

// Function to create the Deals object
  CreateDealsModel? deals;

  Future<void> createDealsObject(int userid) async {
    if (CategoryId != 0 &&
        _country != null &&
        _city != null &&
        _brand!=null &&
        _imagesid.length != 0) {
      deals = CreateDealsModel(
        title: title.text,
        description: description.text,
        details: details.text,
        price: int.parse(price.text),
        quantity: int.parse(quantity.text),
        discount: int.parse(discount.text),
        imagePrinciple: _imagesid[0].title,
        idCateg: CategoryId,
        idCountrys: _country!.idCountrys!,
        idCity: _city!.idCity!,
        idBrand: _brand!.idBrand,
        idUser: userid,
        locations: "${_country!.title}, ${_city!.title}",
        active: 0,
      );
      if (EndDate != null) {
        deals!.dateEND = EndDate.text;
      }
      if (DealsPrize != null) {
        deals!.idPrize = DealsPrize!.idPrize;
      } else if (widget.deal!.idPrize != null) {
        deals!.idPrize = widget.deal!.idPrize;
      }if(widget.deal!.idBoost!=null){
        deals!.idBoost=widget.deal!.idBoost;
      }
      setState(() {
        error = "";
      });
    } else {
      setState(() {
        error = "pleace complete all the form ";
      });
    }
  }

  // get the features of the Deals
  List<ListDealsFeaturesFeatureValues> getFeatures() {
    List<ListDealsFeaturesFeatureValues> lst = [];
    _features.forEach((f) {
      if (f.selected == true && f.value != null) {
        ListDealsFeaturesFeatureValues lfv = ListDealsFeaturesFeatureValues(
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
  List<ImageModel> _DealImages = [];
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

  /** Update the deal */
  Future<DealsModel> updateDeal() async {
    int iduser = await getuserId();
    await createDealsObject(iduser);
    if (deals != null) {
      DealsModel? response =
          await DealsService().updateDeals(widget.deal!.idDeal!, deals!);
      var x = response;
      // Update the Features Values
      List<ListDealsFeaturesFeatureValues> lfv = getFeatures();
      print(lfv);
      bool resDele =
          await AdsFeaturesService().deleteDeals(widget.deal!.idDeal!);

      if (resDele && lfv != null && lfv.length != 0) {
        lfv.forEach((element) async {
          CreateAdsFeature fd = new CreateAdsFeature(
              idDeals: int.parse(x!.idDeal.toString()),
              idFeature: int.parse(element.featureId.toString()),
              idFeaturesValues: int.parse(element.featureValueId.toString()),
              active: 1);
          await AdsFeaturesService().Createfeature(fd);
        });
      }

      //update the images
      for (var i = 0; i < _imagesid!.length; i++) {
        await ImageService().UpdateDelaImages(
            int.parse(_imagesid[i].IdImage.toString()),
            int.parse(x!.idDeal.toString()));
      }
      return response!;
    }
    setState(() {
      error = "pleace complete all the form ";
    });
    throw Exception(
        "Ther is an Error creating the Deals Check your fields Please");
  }

  /** fetch categorys */
  //int? IdCategoryFeatures;
  Future<void> fetchData() async {
    try {
      List<CategoriesModel> categories = await CategoryService().GetData();
      CategoriesModel? targetCategory =
          findCategoryById(categories, widget.deal!.idCateg!);

      if (targetCategory != null) {
        setState(() {
          _categorys = categories;
          _category = targetCategory;
          CategoryId = _category!.idCateg!;
          fetchFeatures(CategoryId!);
        });
      } else {
        print('Category with ID ${widget.deal!.idCateg!} not found.');
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
            .firstWhere((co) => co.idCountrys == widget.deal!.idCountrys!);
      });
    } catch (e) {
      print('Error fetching countrys: $e');
    }
  }

  /** fetch Brands */
  Future<void> fetchBrands() async {
    try {
      List<BrandsModel> Brands = await BrandsService().GetAllBrands();
      setState(() {
        _brands = Brands;
        _brand = _brands.firstWhere((b) => b.idBrand == widget.deal!.idBrand!);
      });
    } catch (e) {
      print('Error fetching Brands: $e');
    }
  }

  /** fetch Cities */
  Future<void> fetchCities(int id) async {
    try {
      List<CitiesModel> cities = await CityService().GetData(id);
      setState(() {
        _cities = cities;
        _city = _cities.firstWhere((ct) => ct.idCity == widget.deal!.idCity!);
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

      for (var af in _DealsFeatures) {
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

        _DealsFeatures.forEach((af) {
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
  Future<void> fetchImages(int idDeal) async {
    try {
      List<ImageModel> images = await ImageService().getImage(idDeal);
      setState(() {
        _imagesid = images;
        images.forEach((element) {
          _DealImages.add(element);
        });
      });
    } catch (e) {
      print('Error fetching Images: $e');
    }
  }

  List<AdsFeature> _DealsFeatures = [];

  /** fetch deals features and chnage the features and the features values */
  Future<void> fetchDealsFeaturesByIDDeal(int idADeals) async {
    try {
      List<AdsFeature> AfList =
          await AdsFeaturesService().GetDealsFeaturesByIdDeals(idADeals);

      _DealsFeatures = AfList;
    } catch (e) {
      print('Error fetching AdsFeatures: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.deal!.idPrize != null) {
      GetPrize(widget.deal!.idPrize);
    }
    fetchDealsFeaturesByIDDeal(widget.deal!.idDeal!);
    fetchImages(widget.deal!.idDeal!);
    title.text = widget.deal!.title!;
    description.text = widget.deal!.description!;
    details.text = widget.deal!.details!;
    price.text = widget.deal!.price!.toString();
    images.text = widget.deal!.imagePrinciple!;
    CategoryId = widget.deal!.idCateg!;
    CountryId = widget.deal!.idCountrys!;
    quantity.text = widget.deal!.quantity!.toString();
    discount.text = widget.deal!.discount!.toString();
    if (widget.deal!.dateEND != null) {
      EndDate.text = widget.deal!.dateEND!;
    } else {
      EndDate.text = "";
    }

    fetchCities(CountryId);
    fetchCountries();
    fetchBrands();
    fetchData();
    fetchFeatures(CategoryId);
    fetchFeaturesValues(FeatureId);
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
        title: "Update Deals",
      ),
      body: Container(
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text("Create your Deal :",
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
                  key: _DealsFormKey,
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
                              hintText: "Title"),
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
                                borderSide:
                                    BorderSide(width: 2, color: Colors.indigo),
                              ),
                              hintText: "Details"),
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Details is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 18.0, 10, 3),
                        child: TextFormField(
                          controller: price,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.indigo),
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 20),
                              //label: ,
                              hintText: "Price "),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Price is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 18.0, 10, 3),
                        child: TextFormField(
                          controller: quantity,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.indigo),
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 20),
                              //label: ,
                              hintText: "Quantity "),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Quantity is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 18.0, 10, 3),
                        child: TextFormField(
                          controller: discount,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.indigo),
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 20),
                              //label: ,
                              hintText: "Discount "),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: EndDate,
                          decoration: InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            labelText: "End Date",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'End Date is required';
                            }
                            return null;
                          },
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2050),
                            );
                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              setState(() {
                                EndDate.text = formattedDate;
                              });
                            }
                          },
                        ),
                      ),

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
                                            value: _country != null
                                                ? _country
                                                : _countrys[0],
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
                          if (CountryId != 0 && _cities.isNotEmpty)
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
                                      return Text('No data available');
                                    }
                                  }
                                },
                              ),
                            ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_brands.isNotEmpty)
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FutureBuilder<List<BrandsModel>>(
                                future: BrandsService().GetAllBrands(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    if (_brands!.isNotEmpty) {
                                      return Column(
                                        children: [
                                          Container(
                                            child: DropdownButton(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 7),
                                              disabledHint:
                                                  Text("Select Cities"),
                                              value: _brand != null
                                                  ? _brand
                                                  : _brands[0],
                                              items: _brands!
                                                  .map((e) => DropdownMenuItem<
                                                          BrandsModel>(
                                                        child: Text(
                                                            e.title.toString()),
                                                        value: e,
                                                      ))
                                                  .toList(),
                                              onChanged: (BrandsModel? b) {
                                                if(b!.idBrand!=1){
                                                  setState(() {
                                                    _brand = b;
                                                  });
                                                }
                                              },
                                              icon: Icon(
                                                  Icons.branding_watermark),
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
                      Column(
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
                                        FeatureId = int.parse(f.idF.toString());
                                        fetchFeaturesValues(FeatureId);
                                      });
                                    },
                                  ),
                                  if (f.valuesList!.isNotEmpty)
                                    ...f.valuesList!
                                        .map(
                                          (fv) => Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
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
                                                        groupValue: f.value,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            f.value = value;
                                                          });
                                                        },
                                                      ),
                                                      Text(
                                                        fv.title.toString(),
                                                        style: TextStyle(
                                                          fontSize: 17.0,
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
                              _DealImages.length != 0
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: _DealImages.asMap()
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
                                                  _DealImages.remove(
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
                                                  _DealImages.removeWhere((i) =>i.IdImage== _imagesid[index].IdImage);
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
                                        if (_DealImages.length == 0)
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

                      //end of image picker

                      /** Prize Form */

                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (addPrize == false)
                              addPrize = true;
                            else {
                              addPrize = false;
                            }
                          });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.add),
                            Text(
                              "Add Prize",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (addPrize)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.indigo, width: 2),
                              color: Colors.white,
                            ),
                            child: Form(
                              key: _PrizeformKey,
                              child: Column(
                                children: [
                                  Center(
                                    child: Text("Add Prize To Deal :",
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
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 18.0, 10, 3),
                                    child: TextFormField(
                                      controller: prizeTitle,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2, color: Colors.indigo),
                                        ),
                                        hintText: "Prize Title",
                                      ),
                                      enabled:
                                          DealsPrize == null ? true : false,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Prize title is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 18.0, 10, 3),
                                    child: TextFormField(
                                      controller: prizeDescription,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2, color: Colors.indigo),
                                        ),
                                        hintText: "Prise Description",
                                      ),
                                      keyboardType: TextInputType.multiline,
                                      minLines: 1,
                                      maxLines: 2,
                                      enabled:
                                          DealsPrize == null ? true : false,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Description is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "add Prize Image :",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 15, 0, 0),
                                      child: Column(
                                        children: [
                                          _Prizeimagesid != null
                                              ? Column(
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 300,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          color: Colors.black
                                                              .withOpacity(0),
                                                        ),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          Image.network(
                                                            ApiPaths()
                                                                    .ImagePath +
                                                                _Prizeimagesid!
                                                                    .title!,
                                                            height: 400,
                                                            width: 420,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : SizedBox(height: 0),

                                          _Prizeimage != null
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 300,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: Colors.black
                                                            .withOpacity(0)),
                                                  ),
                                                  child: Image.file(
                                                    _Prizeimage!,
                                                    height: 400,
                                                    fit: BoxFit.fill,
                                                  ),
                                                )
                                              : Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    if (_Prizeimagesid == null)
                                                      Container(
                                                        height: 300,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                            color: Colors.black
                                                                .withOpacity(0),
                                                          ),
                                                          image:
                                                              DecorationImage(
                                                            image: AssetImage(
                                                                "assets/images/vide.png"),
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                          if (DealsPrize == null)
                                            CostumButton(
                                              title: "Pick an Image",
                                              iconName: Icons.image_outlined,
                                              onClick: () => AddPrizeImage(
                                                  ImageSource.gallery),
                                            ),
                                          if (DealsPrize == null)
                                            CostumButton(
                                              title: "Take picture",
                                              iconName: Icons.camera,
                                              onClick: () => AddPrizeImage(
                                                  ImageSource.camera),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (DealsPrize == null)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (DealsPrize == null)
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (_Prizeimage != null ||
                                                  prizeTitle != null ||
                                                  prizeDescription != null) {
                                                if (_Prizeimagesid != null) {
                                                  bool res =
                                                      await ImageService()
                                                          .deleteImage(
                                                              _Prizeimagesid!
                                                                  .IdImage!);
                                                  print(res);
                                                }
                                                setState(() {
                                                  DealsPrize = null;
                                                  prizeTitle = null;
                                                  prizeDescription = null;
                                                  prizeImages = null;
                                                  _Prizeimagesid = null;
                                                  _Prizeimage = null;
                                                  _PrizeformKey = null;
                                                });
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.grey[400],
                                              onPrimary: Colors.black,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.cancel_outlined),
                                                SizedBox(width: 8),
                                                Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
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
                            if (_DealsFormKey.currentState!.validate()) {
                              if (DealsPrize == null &&
                                  (_Prizeimage != null || (prizeTitle != null && prizeTitle!.text.isNotEmpty)
                                      || (prizeDescription != null && prizeDescription!.text.isNotEmpty))) {
                                if (_PrizeformKey!.currentState!.validate()) {
                                  if (_Prizeimagesid != null &&
                                      CategoryId != 0 &&
                                      _country != null &&
                                      _city != null &&
                                      _imagesid.length != 0) {
                                    await AddPrize();
                                    await getuserId().then((value) {
                                      createDealsObject(value);
                                    });
                                  } else {
                                    error =
                                        "Pleaser complete the prize Form or Cancel it ";
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
                                } else {
                                  error = "Add Price Image !!";
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
                              } else if (CategoryId > 1 &&
                                  _country != null &&
                                  _city != null &&
                                  _imagesid.length != 0) {
                                await getuserId().then((value) {
                                  createDealsObject(value);
                                  print(deals!.toJson());
                                });
                              } else {
                                setState(() {
                                  error = "Veuillez compléter le formulaire";
                                });

                                //return;
                              }

                              if (error!.isNotEmpty) {
                                print(error);

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
                              } else {
                                DealsModel? res = await updateDeal();
                                Navigator.pop(context, {"UpatedDeals": res});
                              }
                            }
                          },
                          child: Text(
                            "Update Deals",
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
