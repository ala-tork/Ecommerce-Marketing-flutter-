import 'package:ecommerceversiontwo/Pages/core/model/CategoriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CitiesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CountriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/CreateAnnounceModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/FeaturesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/FeaturesValuesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/CategoriesServices/CategoryService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/CityServices/CityService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/CountriesServices/CountryService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/FeaturesServices/FeaturesService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/FeaturesValuesServices/FeaturesValuesService.dart';
import 'package:flutter/material.dart';

class FilterForm extends StatefulWidget {
  final CountriesModel? country;
  final CategoriesModel? category;
  final CitiesModel? city;
  final double? minprice;
  final double? maxprice;
  final List<FeaturesValuesModel>? featursValuesSelected;

  const FilterForm(
      {super.key,
      this.country,
      this.city,
      this.category,
      this.featursValuesSelected,
      this.minprice,
      this.maxprice});

  @override
  State<FilterForm> createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  double _minValue = 0;
  double _maxValue = 1000;
  TextEditingController _minController = TextEditingController();
  TextEditingController _maxController = TextEditingController();

  //list of features values Selected
  List<FeaturesValuesModel> featuresvalues = [];

  //list of Features values ids
  List<int> featuresvaluesid = [];

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

  /** fetch categorys */
  Future<void> fetchData() async {
    try {
      List<CategoriesModel> categories = await CategoryService().GetData();

      setState(() {
        _categorys = categories;
      });
      if (widget.category != null && _categorys.isNotEmpty) {
        CategoriesModel? targetCategory =
        findCategoryById(categories, widget.category!.idCateg!);
        setState(() {
          _category = targetCategory;
        });
        CategoryId = _category!.idCateg!;
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

  /** fetch countrys */
  Future<void> fetchCountries() async {
    try {
      List<CountriesModel> countries = await CountrySerice().GetData();
      setState(() {
        _countrys = countries;
      });
      if (widget.country != null && _countrys.isNotEmpty) {
        setState(() {
          _country = _countrys
              .firstWhere((c) => c.idCountrys == widget.country!.idCountrys);
          CountryId = _country!.idCountrys!;
          fetchCities(CountryId);
        });
      }
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
      });
      if (widget.city != null && _cities.isNotEmpty) {
        setState(() {
          _city = _cities.firstWhere((c) => c.idCity == widget.city!.idCity);
        });
      }
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
      print(
          "////////////////////////////////// : ${widget.featursValuesSelected}");
      for (var af in widget.featursValuesSelected!) {
        for (var f in _features) {
          if (f.idF == af.idF) {
            f.selected = true;
            FeatureId = f.idF!;
            f.value = af.idFv;
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
        if (widget.featursValuesSelected != null) {
          widget.featursValuesSelected!.forEach((fs) {
            _featuresValues.forEach((fv) {
              if (fs.idFv == fv.idFv) {
                setState(() {
                  fv.selected = true;
                });
              }
            });
          });
        }
        if (_features[indexOfFeature].selected == true) {
          _features[indexOfFeature].valuesList = _featuresValues;
        } else {
          _features[indexOfFeature].valuesList = [];
        }
      });
      //print(featuresValues);
    } catch (e) {
      print('Error fetching Features Values : $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCities(CountryId);
    fetchCountries();
    fetchFeatures(CategoryId);
    fetchFeaturesValues(FeatureId);
    fetchData();
    _minValue = widget.minprice as double;
    if (widget.maxprice! > 0) {
      _maxValue = widget.maxprice as double;
    }
    if (widget.country != null) {
      print(" /////// / : ${widget.country!.title!}");
    }
    _minController.text = _minValue.toStringAsFixed(2);
    _maxController.text = _maxValue.toStringAsFixed(2);
    //_country=widget.country;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 20, 4, 70),
        child: Wrap(
          children: [
            Center(
              child: Text(
                "Make your Search easyer",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Column(
              children: [
                Center(
                  child: Text(
                    "Price",
                    style: TextStyle(fontSize: 20),
                  ),
                ),

                /** price slider*/
                RangeSlider(
                  values: RangeValues(_minValue, _maxValue),
                  min: 0,
                  max: 10000,
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

                SizedBox(
                  height: 20,
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
                            //_countrys = snapshot.data!;

                            //_country=_countrys![0];
                            if (_countrys != null && _countrys!.isNotEmpty) {
                              return Column(
                                children: [
                                  Container(
                                    child: DropdownButton(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 7),
                                      disabledHint: Text("Select Country"),
                                      value: _country != null
                                          ? _country
                                          : _countrys[0],
                                      items: _countrys!
                                          .map((e) =>
                                              DropdownMenuItem<CountriesModel>(
                                                child: Text(e.title.toString()),
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
                              if (_cities.length != 0 && _cities!.isNotEmpty) {
                                return Column(
                                  children: [
                                    Container(
                                      child: DropdownButton(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 7),
                                        disabledHint: Text("Select Cities"),
                                        value:
                                            _city != null ? _city : _cities[0],
                                        items: _cities!
                                            .map((e) =>
                                                DropdownMenuItem<CitiesModel>(
                                                  child:
                                                      Text(e.title.toString()),
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
                              AsyncSnapshot<List<CategoriesModel>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
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
                                    (fv) => Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 30,
                                              width: 150,
                                              child: RadioListTile(
                                                title:
                                                    Text(fv.title.toString()),
                                                value: fv.idFv,
                                                groupValue: f.value,
                                                onChanged: (value) {
                                                  setState(() {
                                                    f.value = value;
                                                    featuresvalues.add(fv);
                                                    featuresvaluesid
                                                        .add(value!);
                                                    //print(featuresvalues);
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
                              height: 10,
                            )
                          ],
                        );
                      }).toList(),
                    SizedBox(width: 10),
                  ],
                ),
                //end drop down buttons
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          'country': _country,
                          'category': _category,
                          'city': _city,
                          'minprice': _minValue,
                          'maxprice': _maxValue,
                          'featuresvalues': featuresvalues,
                          'featuresvaluesids': featuresvaluesid,
                        });
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
