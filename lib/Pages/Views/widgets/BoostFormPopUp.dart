import 'package:flutter/material.dart';
import 'package:ecommerceversiontwo/Pages/core/model/BoostModules/Boost.dart';

class BoostFormPopUp extends StatefulWidget {
  @override
  _BoostFormPopUpState createState() => _BoostFormPopUpState();
}

class _BoostFormPopUpState extends State<BoostFormPopUp> {
  List<Boost>? listBoost = [];
  dynamic selectedBoost;

  @override
  void initState() {
    super.initState();
    fetchAllBoosts();
  }

  Future<void> fetchAllBoosts() async {
    try {
      List<Boost> boosts = await Boost().GetAllBoosts();
      setState(() {
        listBoost = boosts;
      });
    } catch (e) {
      print('Error fetching Boosts : $e');
      // Handle the error
    }
  }

  String getBoostLabel(Boost boost) {
    String ch = "";
    if (boost.inSliders == 1) {
      ch = ch + 'In Sliders';
    }
    if (boost.inSideBar == 1) {
      ch = ch + ' In Side Bar';
    }
    if (boost.inFooter == 1) {
      ch = ch + ' In Footer';
    }
    if (boost.inRelatedPost == 1) {
      ch = ch + ' In Related Post';
    }
    if (boost.inFirstLogin == 1) {
      ch = ch + ' In First Login';
    }
    if (boost.hasLinks == 1) {
      ch = ch + ' and Has Links';
    }
    return ch;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(20),
          constraints: BoxConstraints(maxWidth: 400,maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Select a Boost',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: listBoost!.map((b) {
                    final boostLabel = getBoostLabel(b);
                    return RadioListTile(
                      title: Text(
                        '${b.titleBoost!}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        'With this BOOST, your post will be displayed :\n'
                            '- $boostLabel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[600],
                        ),
                      ),
                      secondary: Text(
                        '${b.price} DT',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      value: b.idBoost,
                      groupValue: selectedBoost,
                      onChanged: (value) {
                        setState(() {
                          selectedBoost = value;
                          //print(selectedBoost);
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context,{"idBoost":selectedBoost});
                },
                child: Text(
                  'By Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
