import 'dart:io';

import 'package:ecommerceversiontwo/Pages/core/model/AnnounceModel.dart';
import  'package:http/http.dart' as http;
import 'dart:convert';


class ImageModel {
  int? IdImage;
  String? title;
  String? type;
  int? idAds;
  int? idDeals;
  int? idProduct;
  int? active;

  ImageModel({
    this.IdImage,
    this.title,
    this.type,
    this.idAds,
    this.idDeals,
    this.idProduct,
    this.active=1,
  });

  Map<String, dynamic> toJson() {
    return {
      "Title": title,
      "Type": type,
      "IdAds": idAds,
      "IdDeals": idDeals,
      "IdProduct": idProduct,
      "Active": active,
    };
  }

  ImageModel.fromJson(Map<String, dynamic> json) {
    IdImage = json['idImage'];
    title = json['title'];
    type = json['type'];
    idAds = json['idAds'];
    idDeals = json['idDeals'];
    idProduct = json['idProduct'];
    active = json['active'];
  }

  //save the image
  Future<ImageModel> addImage(File imagePath) async {
    var request =
    http.MultipartRequest('POST', Uri.parse("https://10.0.2.2:7058/api/ImagesControler"));

    // Add image file to the request
    if (imagePath != null && imagePath.lengthSync() != 0) {
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
    // Parse the response as JSON
    Map<String, dynamic> jsonResponse = jsonDecode(responseString);
    print("//////////////////////////////////////////${jsonResponse['idImage']}");
    // Create and return ImageModel from the parsed JSON data
    return ImageModel(
      IdImage: jsonResponse['idImage'],
      title: jsonResponse['title'],
      type: jsonResponse['type'],
      idAds: jsonResponse['idAds'],
      idDeals: jsonResponse['idDeals'],
      idProduct: jsonResponse['idProduct'],
      active: jsonResponse['active'],
    );
  }

  Future UpdateImages(int idimages, int idAds) async {
    var request = http.MultipartRequest('put', Uri.parse("https://10.0.2.2:7058/api/ImagesControler?idImage=${idimages}&idAds=${idAds}"));

    // Send the request
    var response = await request.send();

    // Check the response status code
    if (response.statusCode != 200) {
      throw Exception('Failed to Update image: ${response.statusCode}');
    }
  }

  Future<bool> deleteData(int id) async {
    final String apiUrl = "https://10.0.2.2:7058/api/ImagesControler?idAds=$id";

    try {
      final response = await http.delete(Uri.parse(apiUrl),);

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to delete Images . Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error deleting item: $e");
      return false;
    }
  }


//get Images by Ads
  Future<List<ImageModel>> apicall(int Ads) async {
    http.Response response;
    response = await http
        .get(Uri.parse("https://10.0.2.2:7058/api/ImagesControler?idAds=${Ads}"));
    if (response.statusCode == 200) {
      var responseBody = response.body;
     List<ImageModel> images =(jsonDecode(responseBody) as List)
          .map((json) => ImageModel.fromJson(json))
          .toList();
      //nbr Page


      return images;
    } else {
      print(response.body);
      throw Exception('Failed to fetch Images');
    }
  }
}