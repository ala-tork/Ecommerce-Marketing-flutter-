import 'dart:convert';

import 'package:ecommerceversiontwo/Pages/core/model/CategoryModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CitiesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CountriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/FeaturesModel.dart';
import 'package:flutter/material.dart';
import  'package:http/http.dart' as http;


class FilterForm extends StatefulWidget {
  final CountriesModel? country;
  final CategoriesModel? category;
  final double? minprice;
  final double? maxprice;
  const FilterForm({super.key, this.country, this.category, this.minprice, this.maxprice});

  @override
  State<FilterForm> createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  double _minValue = 0;
  double _maxValue = 100;
  TextEditingController _minController = TextEditingController();
  TextEditingController _maxController = TextEditingController();



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
  FeaturesModel? _fiture;


  @override
  void initState()  {
    super.initState();
    fetchCities(CountryId);
    fetchCountries();
    fetchFeatures(CategoryId);
    fetchData();
    _minValue= widget.minprice  as double;
    _maxValue= widget.maxprice as double ;
    _minController.text = _minValue.toStringAsFixed(2);
    _maxController.text = _maxValue.toStringAsFixed(2);
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


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 70),
      child: Wrap(
        children: [
          Center(
            child: Text("Make your Search easyer",style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),)
            ,),
          SizedBox(height: 50,),
          Column(
            children: [
              Center(
                child: Text("Price",style: TextStyle(fontSize: 20),),
              ),

              /** price slider*/
              RangeSlider(
                values: RangeValues(_minValue, _maxValue),
                min: 0,
                max: 100,
                onChanged: (values) {
                  setState(() {
                    _minValue = values.start;
                    _maxValue = values.end;
                    _minController.text = _minValue.toStringAsFixed(2);
                    _maxController.text = _maxValue.toStringAsFixed(2);
                  });
                },
              ),
              /** price box show*/
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _minController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _minValue = double.parse(value);
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _maxController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _maxValue = double.parse(value);
                        });
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20,),

              //country list
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /** Countrys list */
                  Container(
                    margin:EdgeInsets.fromLTRB(10, 30, 10, 40),
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
                                    iconEnabledColor: Colors.teal,
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
                  SizedBox(width: 5,),
                  /** Category list */
                  Container(
                    margin:EdgeInsets.fromLTRB(30, 30, 10, 40),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey), // Add border color
                      borderRadius: BorderRadius.circular(8), // Add border radius
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
                                iconEnabledColor: Colors.teal,
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
              ),
              CountryId != 0 || CategoryId!=0?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(CategoryId!=0)
                  /** Cities list */
                  Container(
                    margin:EdgeInsets.fromLTRB(10, 30, 10, 40),
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
                          print(_cities);
                          //_countrys = snapshot.data!;

                          //_country=_countrys![0];
                          if (_cities.length!=0&& _cities!.isNotEmpty) {
                            return Column(
                              children: [

                                Container(
                                  child:DropdownButton(
                                    padding: EdgeInsets.symmetric(horizontal: 7),
                                    disabledHint: Text("Select Cities"),
                                    value: _city,
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
                                    iconEnabledColor: Colors.teal,
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
              ):SizedBox(height: 0,),
              //end drop down buttons
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                          context,{'country':_country,'category':_category,'city':_city,'minprice':_minValue,'maxprice':_maxValue}
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.all(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.filter_alt_rounded),
                        SizedBox(width: 8),
                        Text(
                          'Filter',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }
}
