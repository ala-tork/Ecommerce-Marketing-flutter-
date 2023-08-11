import 'package:ecommerceversiontwo/Pages/core/model/ImageModel.dart';
import  'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ImageService{
  //save the image
  Future<ImageModel> addImage(File imagePath) async {
    var request =
    http.MultipartRequest('POST', Uri.parse("https://10.0.2.2:7058/api/ImagesControler"));
    if (imagePath != null && imagePath.lengthSync() != 0) {
      request.files.add(await http.MultipartFile.fromPath('imageFile', imagePath.path));
    }
    print(request.files);
    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to upload image: ${response.statusCode}');
    }
    String responseString = await response.stream.bytesToString();
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
    var response = await request.send();
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
      return images;
    } else {
      print(response.body);
      throw Exception('Failed to fetch Images');
    }
  }


  // get image by id deals
  Future<List<ImageModel>> getImage(int Deals) async {
    http.Response response;
    response = await http
        .get(Uri.parse("https://10.0.2.2:7058/api/ImagesControler/getAllDealsImages?idDeals=${Deals}"));
    if (response.statusCode == 200) {
      var responseBody = response.body;
      List<ImageModel> images =(jsonDecode(responseBody) as List)
          .map((json) => ImageModel.fromJson(json))
          .toList();
      return images;
    } else {
      print(response.body);
      throw Exception('Failed to fetch Images Deals');
    }
  }

  Future UpdateDelaImages(int idimages, int idDeals) async {
    var request = http.MultipartRequest('put', Uri.parse("https://10.0.2.2:7058/api/ImagesControler/updateDealsImages?idImage=${idimages}&idDeals=${idDeals}"));
    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to Update image: ${response.statusCode}');
    }
  }

  Future<bool> deleteDealImage(int id) async {
    final String apiUrl = "https://10.0.2.2:7058/api/ImagesControler/deleteDealsImages?idDeals=${id}";

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
}