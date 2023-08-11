import 'package:ecommerceversiontwo/Pages/Views/Screens/BottomBar/AnnouceBottomBar/AnnounceCard.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/ImageViewer.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/SellerDetail.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/ads_slide_show.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/curstom_app_bar.dart';
import 'package:ecommerceversiontwo/Pages/app_color.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsFeaturesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AdsFilterModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AnnounceModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/ImageModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/AdsFeaturesServices/AdsFeaturesService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/AnnouncesServices/AnnounceService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/ImageServices/ImageService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:lecle_flutter_carousel_pro/lecle_flutter_carousel_pro.dart';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class AnounceDetails extends StatefulWidget {
  final AnnounceModel Announce;

  AnounceDetails({required this.Announce});

  @override
  _AnounceDetailsState createState() => _AnounceDetailsState();
}

class _AnounceDetailsState extends State<AnounceDetails> {
  PageController productImageSlider = PageController();

  /** User  */
  String email = "";
  String firstname = "";
  String lastname = "";
  String phone = "";
  String country = "";
  String address = "";
  String _selectedCountry = '';
  String selectedCountry = '';
  String id = "";

  //
  List<AnnounceModel> similar = [];

  @override
  void initState() {
    super.initState();
    GetSimilar(widget.Announce, 1);
    fetchAdsFeaturesByIDAds(widget.Announce.idAds!);
    fetchImages(widget.Announce.idAds!);
    fetchUserData().then((user) {
      setState(() {
        email = user['email'];
        firstname = user['firstname'];
        lastname = user['lastname'];
        phone = user['phone'];
        address = user['address'];
        country = user['country'];
      });
    });
    print("Like IDDDDDDDDD :${widget.Announce.likeId}");
  }

  /** fetch Images */
  List<ImageModel> _images = [];
  List<String> _urlImages = [];

  Future<void> fetchImages(int idAds) async {
    try {
      List<ImageModel> images = await ImageService().apicall(idAds);
      _images = images;
      _images.forEach((i) {
        _urlImages.add(i.title!);
      });
      //print(_images);
      //print(featuresValues);
    } catch (e) {
      print('Error fetching Images: $e');
    }
  }

  List<AdsFeature> _AdsFeatures = [];

  /** fetch Ads features and chnage the features and the features values */
  Future<void> fetchAdsFeaturesByIDAds(int idAds) async {
    try {
      List<AdsFeature> AfList =
          await AdsFeaturesService().GetAdsFeaturesByIdAds(idAds);
      setState(() {
        _AdsFeatures = AfList;
      });
      //print(_AdsFeatures);
    } catch (e) {
      print('Error fetching AdsFeatures: $e');
    }
  }

  /** Get User */

  Future<Map<String, dynamic>> fetchUserData() async {
    final apiUrl =
        'https://10.0.2.2:7058/User/GetUserById?id=${widget.Announce.iduser}';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData is Map<String, dynamic>) {
          return jsonData;
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /** Get similar Announce */

  Future<List<AnnounceModel>> GetSimilar(AnnounceModel an, int page) async {
    AdsFilterModel adsFilter =
        AdsFilterModel(pageNumber: page, idFeaturesValues: []);
    if (an.idCountrys != null) {
      adsFilter.idCountrys = an.idCountrys;
    }
    if (an.idCateg != null) {
      adsFilter.idCategory = an.idCateg;
    }
    try {
      Map<String, dynamic> response =
          await AnnounceService().getFilteredAds(adsFilter);

      if (response["ads"] != null) {
        List<dynamic> adsJsonList = response["ads"];
        if (page == 1) {
          similar.clear();
          similar.addAll(
              adsJsonList.map((json) => AnnounceModel.fromJson(json)).toList());
        }
        print("////////////////////////// : $similar");
        return similar;
      } else {
        print(response["ads"]);
        throw Exception('Failed to fetch Ads');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    AnnounceModel announce = widget.Announce;

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              margin: EdgeInsets.only(right: 14),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: AppColor.secondary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () {},
                child: SvgPicture.asset('assets/icons/Chat.svg',
                    color: Colors.white),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 64,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppColor.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    final Uri call = Uri(scheme: 'tel', path: phone.toString());
                    //print(call);
                    if (await canLaunchUrl(call)) {
                      await launchUrl(call);
                    } else {
                      print("it cant launch");
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Call the seller',
                        style: TextStyle(
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // appbar
                Expanded(
                  child: CustomAppBar(
                    title: '${announce.title}',
                    leftIcon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
                    rightIcon: SvgPicture.asset(
                      'assets/icons/Bookmark.svg',
                      color: Colors.black.withOpacity(0.5),
                    ),
                    leftOnTap: () {
                      Navigator.of(context).pop();
                    },
                    rightOnTap: () {},
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: [
                // Section 1 - product image
                Container(
                  margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: FutureBuilder<void>(
                    future: fetchImages(announce!.idAds!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        //print(_images);
                        if (_images.length != 0) {
                          return Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              // product image
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ImageViewer(
                                        imageUrl: _urlImages,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 310,
                                  color: Colors.white,
                                  child: PageView(
                                    physics: BouncingScrollPhysics(),
                                    controller: productImageSlider,
                                    children: List.generate(
                                      _images.length,
                                      (index) => Image.network(
                                        "https://10.0.2.2:7058" +
                                            _images![index].title!.toString(),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
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

                // Section 2 - AppBar
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                announce.title.toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Section 3 - product info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 2, bottom: 8),
                            child: Text(
                              '${announce.price} DT',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 2, bottom: 8),
                              child: Text(
                                '${announce.DatePublication}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              )
                          ),
                        ],
                      ),
                      Text(
                        announce.locations!,
                        style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.7),
                          height: 150 / 100,
                        ),
                      ),
                      Text(
                        announce.details!,
                        style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.7),
                          height: 150 / 100,
                        ),
                      ),
                      /** announcer info*/
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              TextButton(
                                child: Text(
                                  firstname + lastname,
                                  style: TextStyle(
                                    color: AppColor.secondary.withOpacity(1),
                                    height: 150 / 100,
                                  ),
                                ),
                                onPressed: () {
                                  SellerDetailsPopUp().showDialogFunc(
                                      context,
                                      "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png",
                                      firstname + lastname,
                                      email,
                                      phone);
                                },
                              ),
                              RatingBar.builder(
                                initialRating: 3.5,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 15,
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {},
                                ignoreGestures: true,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(
                                "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /** Features Table */
                if (_AdsFeatures.isNotEmpty)
                  DataTable(
                    columns: [
                      DataColumn(
                        label: Text(
                          'Characteristic',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Value',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: _AdsFeatures.map((characteristic) {
                      return DataRow(
                        cells: [
                          DataCell(Text(characteristic.features!.title!)),
                          DataCell(Text(characteristic.featuresValues!.title!)),
                        ],
                      );
                    }).toList(),
                  ),
                SizedBox(height: 50,),
                /** Similar */
                FutureBuilder<List<AnnounceModel>>(
                  future: GetSimilar(widget.Announce, 1),
                  builder: (BuildContext context, AsyncSnapshot<List<AnnounceModel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Display a loading indicator while waiting for data
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Failed to fetch Similar');
                    } else {
                      similar.removeWhere((e) => e.idAds == widget.Announce.idAds);
                      return Row(
                        children: [
                          /** similar list  **/
                          Container(
                            width: MediaQuery.of(context).size.width,
                            color: AppColor.primarySoft, //Color.fromRGBO(1,120,186, 1),
                            padding: EdgeInsets.only(top: 12, bottom: 24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Similar',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                // Category list
                                Container(
                                  margin: EdgeInsets.only(top: 12),
                                  height: 340,
                                  //width:100,
                                  child: ListView.separated(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    itemCount: similar.length,
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) {
                                      return SizedBox(width: 16);
                                    },
                                    itemBuilder: (context, index) {
                                      return AnnounceCard(
                                        data: similar[index],
                                        //onTap: () {},
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
