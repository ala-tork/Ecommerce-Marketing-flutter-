import 'package:ecommerceversiontwo/Pages/core/model/UserModel.dart';


class PrizeModel {
  int? idPrize;
  String? title;
  String? image;
  String? description;
  String? datePrize;
  int? idUser;
  User? user;
  int? active;

  PrizeModel(
      {this.idPrize,
        this.title,
        this.image,
        this.description,
        this.datePrize,
        this.idUser,
        this.user,
        this.active});

  PrizeModel.fromJson(Map<String, dynamic> json) {
    idPrize = json['idPrize'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    datePrize = json['datePrize'];
    idUser = json['idUser'];
    //user = json['user'];
    user=json['user'] != null ? new User.fromJson(json['user']) : null;
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['idPrize'] = this.idPrize;
    data['title'] = this.title;
    data['image'] = this.image;
    data['description'] = this.description;
    data['datePrize'] = this.datePrize;
    data['idUser'] = this.idUser;
    //data['user'] = this.user;
    data['active'] = this.active;
    return data;
  }


}
