
class LikeModel {
  int? idLP;
  int? idUser;
  int? idProd;
  int? idAd;
  int? idDeal;
  String? myDate;

  LikeModel(
      {this.idLP,
        this.idUser,
        this.idProd,
        this.idAd,
        this.idDeal,
        this.myDate});

  LikeModel.fromJson(Map<String, dynamic> json) {
    idLP = json['idLP'];
    idUser = json['idUser'];
    if(json['idProd']!=null)
    idProd = json['idProd'];
    if(json['idAd']!=null)
      idAd = json['idAd'];
    if(json['idDeal']!=null)
      idDeal = json['idDeal'];
    if(json['myDate']!=null)
      myDate = json['myDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.idLP!=null)
    data['idLP'] = this.idLP;
    data['idUser'] = this.idUser;
    if(this.idProd!=null)
    data['idProd'] = this.idProd;
    if(this.idAd!=null)
      data['idAd'] = this.idAd;
    if(this.idDeal!=null)
      data['idDeal'] = this.idDeal;
    if(this.myDate!=null)
      data['myDate'] = this.myDate;
    return data;
  }


}