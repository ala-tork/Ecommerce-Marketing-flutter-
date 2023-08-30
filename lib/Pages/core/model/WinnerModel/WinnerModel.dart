import 'package:ecommerceversiontwo/Pages/core/model/PrizesModels/Prize.dart';
import 'package:ecommerceversiontwo/Pages/core/model/UserModel.dart';


class WinnerModel {
  int? idWinner;
  int? idPrize;
  PrizeModel? prizes;
  String? dateWin;
  int? idUser;
  User? user;
  int? priceRecived;

  WinnerModel(
      {this.idWinner,
        this.idPrize,
        this.prizes,
        this.dateWin,
        this.idUser,
        this.user,
        this.priceRecived});

  WinnerModel.fromJson(Map<String, dynamic> json) {
    idWinner = json['idWinner'];
    idPrize = json['idPrize'];
    prizes = json['prizes'] != null
        ? new PrizeModel.fromJson(json['prizes'])
        : null;
    dateWin = json['dateWin'];
    idUser = json['idUser'];
    user = json['user'] != null
        ? new User.fromJson(json['user'])
        : null;
    priceRecived = json['priceRecived'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idWinner'] = this.idWinner;
    data['idPrize'] = this.idPrize;
    data['dateWin'] = this.dateWin;
    data['idUser'] = this.idUser;
    data['priceRecived'] = this.priceRecived;
    return data;
  }


}