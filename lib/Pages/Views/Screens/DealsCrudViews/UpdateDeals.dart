import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
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
import 'package:ecommerceversiontwo/Pages/core/services/AdsFeaturesServices/AdsFeaturesService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/BrandsServices/BrandsService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/CityServices/CityService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/CountriesServices/CountryService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/FeaturesServices/FeaturesService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/FeaturesValuesServices/FeaturesValuesService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/ImageServices/ImageService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateDeals extends StatefulWidget {
  final DealsModel? deal;
  const UpdateDeals({super.key,this.deal});

  @override
  State<UpdateDeals> createState() => _UpdateDealsState();
}

class _UpdateDealsState extends State<UpdateDeals> {


  final formstate = GlobalKey<FormState>();
  TextEditingController title = new TextEditingController();
  TextEditingController price = new TextEditingController();
  //TextEditingController priceDelevery = new TextEditingController();
  TextEditingController quantity = new TextEditingController();
  TextEditingController discount = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController details = new TextEditingController();
  TextEditingController images = new TextEditingController();
  TextEditingController EndDate = TextEditingController();
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

  //Brands
  List<BrandsModel> _brands = [];
  BrandsModel? _brand;

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


// Function to create the Deals object
  CreateDealsModel? deals;
  void createDealsObject(int userid) async {

    if(
    title.toString().isNotEmpty && description.toString().isNotEmpty &&
        (details!=null && details.text.length!=0) && price.toString().isNotEmpty
        && quantity.toString().isNotEmpty
        && CategoryId!=0 && _country!=null  && _city!=null && _imagesid.length!=0
    ){
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
        active: 1,
      );
      if(EndDate!=null){
        deals!.dateEND=EndDate.text;
      }
      error="";
    }else{
      error="pleace complete all the form ";
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
  List<String> _DealImages = [];
  List<File> _image = [];
  List<ImageModel> _imagesid=[];

  Future getImage(source) async{
    final image = await ImagePicker().pickImage(source: source);
    if (image==null) return ;
    final imageTemporary = File(image.path);
    ImageModel response = await ImageService().addImage(imageTemporary);
    print(response);
    setState(() {
      this._imagesid.add(response);
      this._image.add(imageTemporary);
    });
  }

  //save the deal
  Future<DealsModel> updateDeal() async {
    int iduser = await getuserId();
    createDealsObject(iduser);
    print(deals!.toJson());
    DealsModel? response  = await deals!.updateDeals(widget.deal!.idDeal!, deals!);

    //print(response);

    var x =response;
    print("//////////////////////// : ${x!.idDeal}");

    bool resDele=  await AdsFeaturesService().deleteDeals(widget.deal!.idDeal!);
//  print(resDele);

    List<ListDealsFeaturesFeatureValues> lfv = getFeatures();
   // print(lfv);

    if(resDele  && lfv!=null && lfv.length!=0){
      lfv.forEach((element) async {
        CreateAdsFeature fd =
        new CreateAdsFeature(idDeals: int.parse(x!.idDeal.toString()),idFeature: int.parse(element.featureId.toString()),idFeaturesValues: int.parse(element.featureValueId.toString()),active: 1);
        //print(fd.toJson());
        await AdsFeaturesService().Createfeature(fd);
      });
    }

    //print("//////////////////////// : ${_imagesid!.length}");
    //print("//////////////////////// : ${_imagesid[0].IdImage}");
    //update the images
    for(var i=0;i<_imagesid!.length;i++){
      // print(int.parse(_imagesid[i].IdImage.toString()));
      await ImageService().UpdateDelaImages(int.parse(_imagesid[i].IdImage.toString()), int.parse(x!.idDeal.toString()));
    }
    return response!;
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
      List<CountriesModel> countries = await CountrySerice().GetData();
      setState(() {
        _countrys = countries;
        _country= _countrys.firstWhere((co) => co.idCountrys==widget.deal!.idCountrys! );
        _category=_categorys.firstWhere((c) => c.idCateg==widget.deal!.idCateg!);
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
        _brand = _brands.firstWhere((b) => b.idBrand == widget.deal!.idBrand! );
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
      List<FeaturesValuesModel> featuresValues = await FeaturesValuesService().GetData(idfeature);
      setState(() {
        _featuresValues = featuresValues;

        _DealsFeatures.forEach((af) {
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
  Future<void> fetchImages(int idDeal) async {
    try {
      List<ImageModel> images = await ImageService().getImage(idDeal);
      setState(() {
        _imagesid = images;
        images.forEach((element) {
          _DealImages.add(element.title!);
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
      List<AdsFeature> AfList = await AdsFeaturesService().GetDealsFeaturesByIdDeals(idADeals);

      _DealsFeatures = AfList;
    } catch (e) {
      print('Error fetching AdsFeatures: $e');
    }
  }

  @override
  void initState()  {
    super.initState();
    fetchDealsFeaturesByIDDeal(widget.deal!.idDeal!);
    fetchImages(widget.deal!.idDeal!);

    title.text = widget.deal!.title!;
    description.text = widget.deal!.description!;
    details.text = widget.deal!.details!;
    price.text = widget.deal!.price!.toString();
    images.text = widget.deal!.imagePrinciple!;
    CategoryId = widget.deal!.idCateg!;
    CountryId = widget.deal!.idCountrys!;
    quantity.text= widget.deal!.quantity!.toString();
    discount.text = widget.deal!.discount!.toString();
    if (widget.deal!.dateEND != null) {
      EndDate.text = widget.deal!.dateEND!;
    } else {
      EndDate.text = "";
    }

    fetchCities(CountryId);
    fetchCountries();
    fetchBrands();
    fetchFeatures(CategoryId);
    fetchFeaturesValues(FeatureId);
    fetchData();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.blueGrey[100],
      appBar: MyAppBar(Daimons: 122,title: "Add Deals",),
      body: Container(
        child: ListView(
          children: [
            SizedBox(height: 20,),
            Center(
              child: Text("Create your Deal :",
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
                              hintText: "Title"
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
                          minLines: 3,
                          maxLines: 5,
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
                              hintText: "Price "
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 18.0, 10, 3),
                        child: TextFormField(
                          controller: quantity,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(width: 2, color: Colors.indigo),

                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 20),
                              //label: ,
                              hintText: "Quantity "
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 18.0, 10, 3),
                        child: TextFormField(
                          controller: discount,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(width: 2, color: Colors.indigo),

                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 20),
                              //label: ,
                              hintText: "Discount "
                          ),
                        ),
                      ),
                      TextField(
                        controller: EndDate,
                        decoration: InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            labelText: "End Date"
                        ),
                        readOnly: true,
                        //set it true, so that user will not able to edit text
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2050));

                          if (pickedDate != null) {
                            print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            setState(() {
                              EndDate.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {}
                        },
                      ),

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
                          if(_brands.isNotEmpty)
                            Container(
                              margin:EdgeInsets.fromLTRB(10, 30, 10, 0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FutureBuilder<List<BrandsModel>>(
                                future: BrandsService().GetAllBrands(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    if (_brands!.isNotEmpty) {
                                      return Column(
                                        children: [
                                          Container(
                                            child:DropdownButton(
                                              padding: EdgeInsets.symmetric(horizontal: 7),
                                              disabledHint: Text("Select Cities"),
                                              value: _brand!=null?_brand:_brands[0],
                                              items: _brands!.map((e) => DropdownMenuItem<BrandsModel>(
                                                child:
                                                Text(e.title.toString()
                                                ),
                                                value: e,)).toList(),

                                              onChanged:(BrandsModel? b){
                                                setState(() {
                                                  _brand=b;
                                                });
                                              },
                                              icon: Icon(Icons.branding_watermark),
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
                              _DealImages.length !=0?
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: _DealImages.map((img) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 300,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black.withOpacity(0)),
                                    ),
                                    child: Image.network(
                                      "https://10.0.2.2:7058"+img!,
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
                      SizedBox(height: 20,),
                      // create button to save the data
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14.0),
                        child: MaterialButton(
                          textColor: Colors.white,
                          color: Colors.indigo,
                          onPressed: () async {
                            await getuserId().then((value){
                              createDealsObject(idUser!);
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
                              //Map<String, dynamic> adData = deals!.toJson();
                              //print(adData);
                              updateDeal();
                              Navigator.pop(context);
                            }
                          },
                          child: Text("Update Deals",style: TextStyle(fontSize: 20),),
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
