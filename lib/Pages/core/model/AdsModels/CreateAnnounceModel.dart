import 'dart:io';

import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AnnounceModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/FeaturesModel.dart';
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
    this.IdBoost=1,
     this.active});


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['details'] = this.details;
    data['price'] = this.price;
    data['idUser'] = this.IdUser;
    data['imagePrinciple'] = this.imagePrinciple;
    data['videoName'] = this.videoName;
    data['idCateg'] = this.idCateg;
    data['idCountrys'] = this.idCountrys;
    data['idCity'] = this.idCity;
    data['locations'] = this.locations;
    data['idBoost'] = this.IdBoost;
    data['active'] = this.active;
    return data;
  }

  Map<String, dynamic> toJsonUpdate() {
    return {
      "title": title,
      "description": description,
      "details": details,
      "price": price,
      "idUser": IdUser,
      "imagePrinciple": imagePrinciple,
      "videoName": videoName,
      "idCateg": idCateg,
      "idCountrys": idCountrys,
      "idCity": idCity,
      "locations": locations,
      "idBoost": IdBoost,
      "active": active,
    };
  }
/*
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



// Update announce
  Future<AnnounceModel?> updateAnnouncement(int announcementId, CreateAnnounce updatedData) async {
    try {
      var url = Uri.parse("https://10.0.2.2:7058/api/Ads/$announcementId");
      var headers = {'Content-Type': 'application/json'};
      var jsonBody = json.encode(updatedData.toJson());

      var response = await http.put(url, headers: headers, body: jsonBody);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return AnnounceModel.fromJson(responseData);
      } else {
        print('Failed to update announcement. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error updating announcement: $e');
      return null;
    }
  }
*/


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