import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/core/model/ImageModel.dart';
import  'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ImageService{
  //save the image
  Future<ImageModel> addImage(File imagePath) async {
    var request =
    http.MultipartRequest('POST', Uri.parse(ApiPaths().AddImageUrl));
    if (imagePath != null && imagePath.lengthSync() != 0) {
      request.files.add(await http.MultipartFile.fromPath('imageFile', imagePath.path));
    }
    //print(request.files);
    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to upload image: ${response.statusCode}');
    }
    String responseString = await response.stream.bytesToString();
    Map<String, dynamic> jsonResponse = jsonDecode(responseString);
    //print("//////////////////////////////////////////${jsonResponse['idImage']}");
    return ImageModel(
      IdImage: jsonResponse['idImage'],
      title: jsonResponse['title'],
      type: jsonResponse['type'],
      idAds: jsonResponse['idAds'],
      idDeals: jsonResponse['idDeals'],
      idProduct: jsonResponse['idProduct'],
      idPrize: jsonResponse['idPrize'],
      active: jsonResponse['active'],
    );
  }
  Future<bool> deleteImage(int id) async {
    final String apiUrl = "${ApiPaths().DeleteImgeByIdUrl}$id";

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

  Future UpdateImages(int idimages, int idAds) async {
    var request = http.MultipartRequest('put', Uri.parse("${ApiPaths().UpdateImagePath}idImage=${idimages}&idAds=${idAds}"));
    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to Update image: ${response.statusCode}');
    }
  }

  Future<bool> deleteAdsImage(int id) async {
    final String apiUrl = "${ApiPaths().DeleteImagePath}$id";

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
        .get(Uri.parse("${ApiPaths().GetAdsImageUrl}${Ads}"));
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
        .get(Uri.parse("${ApiPaths().GetDealsImageUrl}${Deals}"));
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
    print(idimages);
    print(idDeals);
    var request = http.MultipartRequest('put', Uri.parse("${ApiPaths().UpdateDealsImages}${idimages}&idDeals=${idDeals}"));
    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to Update image: ${response.statusCode}');
    }
  }

  Future<bool> deleteDealImage(int id) async {
    final String apiUrl = "${ApiPaths().DeleteDealsImages}${id}";

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



  Future<ImageModel> getPrizeImage(int idPrize) async {
    http.Response response;
    response = await http.get(Uri.parse("${ApiPaths().GetPrizeImages}${idPrize}"));

    if (response.statusCode == 200) {
      var responseBody = response.body;
      Map<String, dynamic> jsonData = jsonDecode(responseBody);
      ImageModel image = ImageModel.fromJson(jsonData);
      print("image");
      return image;
    } else {
      print(response.body);
      throw Exception('Failed to fetch Prize Image');
    }
  }


  Future UpdatePrizeImages(int idimages, int idPrize) async {
    var request = http.MultipartRequest('put',
        Uri.parse("${ApiPaths().UpdatePrizeImageUrl}$idPrize&idImage=$idimages"));
    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to Update image: ${response.statusCode}');
    }
  }

  Future<bool> deletePrizeImage(int id) async {
    final String apiUrl = "${ApiPaths().DeletePrizeImageUrl}$id";
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