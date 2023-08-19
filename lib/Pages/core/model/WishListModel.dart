import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AnnounceModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Deals/DealsModel.dart';


class WishListModel {
  int? idwish;
  int? idUser;
  //Null? user;
  int? idDeal;
  DealsModel? deals;
  int? idProd;
  int? idAd;
  AnnounceModel? ads;
  String? myDate;

  WishListModel(
      {this.idwish,
        this.idUser,
        //this.user,
        this.idDeal,
        this.deals,
        this.idProd,
        this.idAd,
        this.ads,
        this.myDate});

  WishListModel.fromJson(Map<String, dynamic> json) {
    idwish = json['idwish'];
    idUser = json['idUser'];
    //user = json['user'];
    idDeal = json['idDeal'];
    deals=json['deals'] != null ? new DealsModel.fromJson(json['deals']) : null;
    idProd = json['idProd'] !=null ? json['idProd'] :null;
    idAd = json['idAd'];
    ads = json['ads'] != null ? AnnounceModel.fromJson(json['ads']) : null;
    myDate = json['myDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idwish'] = this.idwish;
    data['idUser'] = this.idUser;
    //data['user'] = this.user;
    data['idDeal'] = this.idDeal;
    if (this.deals != null) {
      data['deals'] = this.deals!.toJson();
    }
    data['idProd'] = this.idProd;
    data['idAd'] = this.idAd;
    if (this.ads != null) {
      data['ads'] = this.ads!.toJson();
    }
    data['myDate'] = this.myDate;
    return data;
  }


}