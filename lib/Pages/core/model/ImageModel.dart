
class ImageModel {
  int? IdImage;
  String? title;
  String? type;
  int? idAds;
  int? idDeals;
  int? idProduct;
  int? idPrize;
  int? active;

  ImageModel({
    this.IdImage,
    this.title,
    this.type,
    this.idAds,
    this.idDeals,
    this.idProduct,
    this.idPrize,
    this.active=1,
  });

  Map<String, dynamic> toJson() {
    return {
      "Title": title,
      "Type": type,
      "IdAds": idAds,
      "IdDeals": idDeals,
      "IdProduct": idProduct,
      'IdPrize' : idPrize,
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
    idPrize = json['idPrize'];
    active = json['active'];
  }

}