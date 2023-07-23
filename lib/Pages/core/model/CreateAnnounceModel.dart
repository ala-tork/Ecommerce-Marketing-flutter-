import 'dart:io';

import  'package:http/http.dart' as http;
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class CreateAnnounce {
  String? title;
  String? description;
  String? details;
  int? price;
  int? IdUser;
  String? imagePrinciple;
  String? videoName;
  int? idCateg;
  int? idCountrys;
  int? idCity;
  String? locations;
  int? IdBoost;
  //<ListFeaturesFeatureValues>? listFeaturesFeatureValues;
  int? active;

  CreateAnnounce({ this.title,
     this.description,
     this.details,
     this.price,
    this.IdUser=1,
    this.imagePrinciple,
    this.videoName,
     this.idCateg,
     this.idCountrys,
     this.idCity,
     this.locations,
    //this.listFeaturesFeatureValues,
    this.IdBoost=1,
     this.active});


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['details'] = this.details;
    data['price'] = this.price;
    data['IdUser'] = this.IdUser;
    data['imagePrinciple'] = this.imagePrinciple;
    data['videoName'] = this.videoName;
    data['idCateg'] = this.idCateg;
    data['idCountrys'] = this.idCountrys;
    data['idCity'] = this.idCity;
    data['locations'] = this.locations;
   /* if (this.listFeaturesFeatureValues != null) {
      data['listFeatures_FeatureValues'] =
          this.listFeaturesFeatureValues!.map((v) => v.toJson()).toList();
    }*/
    data['IdBoost'] = this.IdBoost;
    data['active'] = this.active;
    return data;
  }



  Future<Map<String, dynamic>> createAd(CreateAnnounce adModel) async {

    var request = http.MultipartRequest('POST', Uri.parse("https://10.0.2.2:7058/api/Ads/CreateAds"));

    // Convert adModel to JSON
    Map<String, dynamic> adData = adModel.toJson();

    // Add other fields to the request
    adData.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Send the request
    var response = await request.send();

    // Read response
    String responseString = await response.stream.bytesToString();

    // Parse the response JSON
    Map<String, dynamic> responseData = json.decode(responseString);

    return responseData;
  }

  //save the image

  Future<int> AddImage(File imagePath) async {
    var request = http.MultipartRequest('POST', Uri.parse("https://10.0.2.2:7058/api/ImagesControler"));

    // Add image file to the request
    if (imagePath != null && imagePath.length != 0) {
      request.files.add(await http.MultipartFile.fromPath('imageFile', imagePath.path));
    }

    print(request.files);

    // Send the request
    var response = await request.send();

    // Check the response status code
    if (response.statusCode != 200) {
      throw Exception('Failed to upload image: ${response.statusCode}');
    }

    // Read response
    String responseString = await response.stream.bytesToString();

    // Parse the response as int
    int responseData = int.parse(responseString);
    if (responseData == null) {
      throw Exception('Invalid response format: $responseString');
    }

    return responseData;
  }

  Future UpdateImages(int idimages, int idAds) async {
    var request = http.MultipartRequest('put', Uri.parse("https://10.0.2.2:7058/api/ImagesControler?idImage=${idimages}&idAds=${idAds}"));

    // Send the request
    var response = await request.send();

    // Check the response status code
    if (response.statusCode != 200) {
      throw Exception('Failed to upload image: ${response.statusCode}');
    }

  }
}


class ListFeaturesFeatureValues {
  int featureId;
  int featureValueId;

  ListFeaturesFeatureValues({required this.featureId, required this.featureValueId});


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['featureId'] = this.featureId;
    data['featureValueId'] = this.featureValueId;
    return data;
  }
}