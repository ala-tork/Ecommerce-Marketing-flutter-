import 'package:flutter/material.dart';

class FilterAllForm extends StatefulWidget {
  final String? country;
  final String? category;
  final double? minprice;
  final double? maxprice;
  final bool Deals;
  final bool Announces;
  final bool Products;
  const FilterAllForm({super.key, this.country="AllCountrys", this.category="AllCategorys",
    this.minprice, this.maxprice,this.Deals= false,this.Announces= false,this.Products= false});

  @override
  State<FilterAllForm> createState() => _FilterAllFormState();
}

class _FilterAllFormState extends State<FilterAllForm> {
  double _minValue = 0;
  double _maxValue = 100;
  TextEditingController _minController = TextEditingController();
  TextEditingController _maxController = TextEditingController();
  String? _country="All Countrys";
  String? _category="All Categorys";
  bool _Deals = false;
  bool _Announces = false;
  bool _Products = false;

  final _countrys=["All Countrys","tunisia","algeria","french"];


  final _categorys=["All Categorys","Clothes","Food","Drinks"];


  @override
  void initState()  {
    super.initState();
    _minValue= widget.minprice  as double;
    _maxValue= widget.maxprice as double ;
    _minController.text = _minValue.toStringAsFixed(2);
    _maxController.text = _maxValue.toStringAsFixed(2);
    _country=widget.country.toString();
    _category=widget.category.toString();
    _Deals=widget.Deals ;
    _Announces=widget.Announces;
    _Products=widget.Products;
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
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
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
                    child:
                    DropdownButton(
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      disabledHint: Text("Categorys"),
                      value: _category,
                      items: _categorys.map((e) => DropdownMenuItem<String>(child: Text(e),value: e,)).toList(),
                      onChanged:(val){
                        setState(() {
                          _category=val.toString();
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
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ //Text
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      /**deals checkbox**/
                      SizedBox(
                        width: 10,
                      ), //SizedBox
                      Text(
                        'Deals:',
                        style: TextStyle(fontSize: 17.0),
                      ), //Text
                      SizedBox(width: 3), //SizedBox

                      Checkbox(
                        value: _Deals,
                        onChanged: (x) {
                          setState(() {
                            _Deals = x as bool;
                          });
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ), //SizedBox
                      Text(
                        'Ads:',
                        style: TextStyle(fontSize: 17.0),
                      ), //Text
                      SizedBox(width: 3), //SizedBox
                      Checkbox(
                        value: _Announces,
                        onChanged: (x) {
                          setState(() {
                            _Announces = x as bool;
                          });
                        },
                      ),
                      /**Products checkbox**/
                      SizedBox(
                        width: 10,
                      ), //SizedBox
                      Text(
                        'Products:',
                        style: TextStyle(fontSize: 17.0),
                      ), //Text
                      SizedBox(width: 3), //SizedBox

                      Checkbox(
                        value: _Products,
                        onChanged: (x) {
                          setState(() {
                            _Products = x as bool;
                          });
                        },
                      )
                    ], //<Widget>[]
                  ), //Row
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
                          context,{'country':_country,
                        'category':_category,
                        'minprice':_minValue,
                        'maxprice':_maxValue,
                        'Deals':_Deals,
                      'Announces':_Announces,
                      'Products':_Products}
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

          //end ranger


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
