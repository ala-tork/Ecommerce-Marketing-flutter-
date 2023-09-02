import 'dart:io';
import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/core/model/UserModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  Future<User> GetUserByID(int idUser) async {
    final String apiUrl = "${ApiPaths().GetUserByIdUrl}$idUser";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        dynamic jsonResponse = json.decode(response.body);
        User user = User.fromJson(jsonResponse);
        return user;
      } else {
        throw Exception("Failed to fetch User. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error Fetching User: $e");
      throw Exception("Error fetching User: $e");
    }
  }
  Future<User> addUserImage(int idUser, File img) async {
    var request = http.MultipartRequest('PUT', Uri.parse("${ApiPaths().AddUserImage}$idUser"),);
    request.files.add(await http.MultipartFile.fromPath('img', img.path),);

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        dynamic jsonResponse = json.decode(await response.stream.bytesToString());
        User user = User.fromJson(jsonResponse);
        return user;
      } else {
        throw Exception("Failed to add user image. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error adding user image: $e");
      throw Exception("Error adding user image: $e");
    }
  }

  /** update user diamond */
  Future<void> updateUserDiamond(Map<String, dynamic> updatedUser , int id) async {
    try {
      final response = await http.put(Uri.parse('${ApiPaths().UpdateUserUrl}$id'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(updatedUser),
      );
      if (response.statusCode == 200) {
        print("User updated successfully!");
      } else {
        print("Failed to update user. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error while updating user: $e");
    }
  }
}