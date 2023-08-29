
import 'package:ecommerceversiontwo/Pages/core/model/UserModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class UserProfileProvider extends ChangeNotifier{
  User? _user;

  User? get user  => _user;

  void FetchUserProvider(int id) async {
   User? u = await User().GetUserByID(id);
    if (u!=null) {
      _user =u;
    } else {
      throw Exception("user Not Found !");
    }
  }

  Future<void> updateUserInformation(Map<String, dynamic> updatedUser,int id) async {
    try {
      final response = await http.put(
        Uri.parse('https://10.0.2.2:7058/User/UpdateUser?id=$id'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(updatedUser),
      );

      if (response.statusCode == 200) {
        FetchUserProvider(id);
        print("User updated successfully!");
      } else {
        print("Failed to update user. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error while updating user: $e");
    }
  }

}