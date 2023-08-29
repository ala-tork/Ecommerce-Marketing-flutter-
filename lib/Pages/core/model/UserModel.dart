import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  int? id;
  String? email;
  String? password;
  String? firstname;
  String? lastname;
  String? imageUrl;
  String? phone;
  String? country;
  String? address;
  String? role;
  String? dateInscription;
  int? active;
  String? refreshToken;

  User(
      {this.id,
        this.email,
        this.password,
        this.firstname,
        this.lastname,
        this.imageUrl,
        this.phone,
        this.country,
        this.address,
        this.role,
        this.dateInscription,
        this.active,
        this.refreshToken});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    imageUrl=json['imageUrl'];
    phone = json['phone'];
    country = json['country'];
    address = json['address'];
    role = json['role'];
    dateInscription = json['dateInscription'];
    active = json['active'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['password'] = this.password;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['phone'] = this.phone;
    data['country'] = this.country;
    data['address'] = this.address;
    data['role'] = this.role;
    data['dateInscription'] = this.dateInscription;
    data['active'] = this.active;
    data['refreshToken'] = this.refreshToken;
    return data;
  }


  Future<User> GetUserByID(int idUser) async {
    final String apiUrl = "https://10.0.2.2:7058/User/GetUserById?id=$idUser";
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

}