import 'dart:convert';

import 'package:ecommerceversiontwo/Pages/core/model/CategoryModel.dart';
import 'package:flutter/material.dart';
import  'package:http/http.dart' as http;


class FilterForm extends StatefulWidget {
  final String? country;
  final CategoriesModel? category;
  final double? minprice;
  final double? maxprice;
  const FilterForm({super.key, this.country="AllCountrys", this.category, this.minprice, this.maxprice});

  @override
  State<FilterForm> createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  double _minValue = 0;
  double _maxValue = 100;
  TextEditingController _minController = TextEditingController();
  TextEditingController _maxController = TextEditingController();
  String? _country="All Countrys";
  CategoriesModel? _category;

  final _countrys=["All Countrys","tunisia","algeria","french"];


  //final _categorys=["All Categorys","Clothes","Food","Drinks"];

  List<CategoriesModel> _categorys =[];

  Future<List<CategoriesModel>> apicall() async {
    http.Response response;
    response = await http.get(Uri.parse("https://10.0.2.2:7058/api/CategoriesControler/GetAllCategories"));

    if (response.statusCode == 200) {
      List<CategoriesModel> categoryList = (jsonDecode(response.body) as List)
          .map((json) => CategoriesModel.fromJson(json))
          .toList();

      return categoryList;
    } else {
      print(response.body);
      throw Exception('Failed to fetch Categories');
    }
  }

  CategoriesModel? selectedCategory;


  @override
  void initState()  {
    super.initState();
    fetchData();
    _minValue= widget.minprice  as double;
    _maxValue= widget.maxprice as double ;
    _minController.text = _minValue.toStringAsFixed(2);
    _maxController.text = _maxValue.toStringAsFixed(2);
    _country=widget.country.toString();
    //_category=widget.category;
  }
  Future<void> fetchData() async {
    try {
      List<CategoriesModel> categories = await apicall();
      setState(() {
        _categorys = categories;
      });
    } catch (e) {
      print('Error fetching categories: $e');
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

              //price slider
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
              // price box show
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
                  Container(
                    margin:EdgeInsets.fromLTRB(30, 30, 10, 40),
                  decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey), // Add border color
                  borderRadius: BorderRadius.circular(8), // Add border radius
                  ),
                  child:
                  DropdownButton<String>(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    disabledHint: Text("countrys"),
                      value: _country,
                      items: _countrys.map((e) => DropdownMenuItem<String>(child: Text(e),value: e,)).toList(),
                      onChanged:(val){
                          setState(() {
                            _country=val.toString();
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
                  ),
                ),
                  SizedBox(width: 5,),
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
                        future: apicall(),
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
                                value: _category!=null?_category:_categorys[1],
                                items: _categorys.map((e) => DropdownMenuItem<CategoriesModel>(child: Text(e.title.toString()),value: e,)).toList(),
                                onChanged:(CategoriesModel? x){
                                  setState(() {
                                    _category=x;
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
                    /*DropdownButton<CategoriesModel>(
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      disabledHint: Text("Categorys"),
                      value: selectedCategory,
                      items: _categorys.map((e) => DropdownMenuItem<CategoriesModel>(child: Text(e.title.toString()),value: e,)).toList(),
                      onChanged:(CategoriesModel? x){
                        setState(() {
                          selectedCategory=x;
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
                    ),*/
                  ),
                ],
              ),
              //end drop down buttons
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                          context,{'country':_country,'category':_category,'minprice':_minValue,'maxprice':_maxValue}
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
