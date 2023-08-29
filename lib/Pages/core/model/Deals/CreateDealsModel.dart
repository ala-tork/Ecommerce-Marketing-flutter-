
class CreateDealsModel {
  String? title;
  String? description;
  String? details;
  int? price;
  int? discount;
  int? quantity;
  String? idPricesDelevery;
  String? datePublication;
  String? dateEND;
  String? imagePrinciple;
  String? videoName;
  int? idCateg;
  int? idUser;
  int? idCountrys;
  int? idCity;
  int? idBrand;
  int? idPrize;
  String? locations;
  int? idBoost;
  int? active;

  CreateDealsModel(
      {
        this.title,
        this.description,
        this.details,
        this.price,
        this.discount,
        this.quantity,
        this.idPricesDelevery,
        this.datePublication,
        this.dateEND,
        this.imagePrinciple,
        this.videoName,
        this.idCateg,
        this.idUser,
        this.idCountrys,
        this.idCity,
        this.idBrand,
        this.idPrize,
        this.locations,
        this.idBoost,
        this.active});

  CreateDealsModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    details = json['details'];
    price = json['price'];
    discount = json['discount'];
    quantity = json['quantity'];
    if(json['idPricesDelevery']!=null)
    idPricesDelevery = json['idPricesDelevery'];

    if(json['datePublication']!=null)
    datePublication = json['datePublication'];

    if(json['dateEND']!=null)
    dateEND = json['dateEND'];

    imagePrinciple = json['imagePrinciple'];
    if(json['videoName']!=null)
    videoName = json['videoName'];

    idCateg = json['idCateg'];
    idUser = json['idUser'];
    idCountrys = json['idCountrys'];
    idCity = json['idCity'];
    idBrand = json['idBrand'];

    if(json['idPrize']!=null)
    idPrize = json['idPrize'];

    locations = json['locations'];
    idBoost = json['idBoost'];
    active = json['active'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['title'] = this.title!;
    data['description'] = this.description!;
    data['details'] = this.details!;
    data['price'] = this.price.toString();
    if(this.discount!=null)
    data['discount'] = this.discount.toString();
    data['quantity'] = this.quantity.toString();
    if (idPricesDelevery != null) data['idPricesDelevery'] = this.idPricesDelevery.toString();
    if (datePublication != null) data['datePublication'] = this.datePublication!;
    if (dateEND != null) data['dateEND'] = this.dateEND!;
    data['imagePrinciple'] = this.imagePrinciple!;
    if (videoName != null) data['videoName'] = this.videoName!;
    data['idCateg'] = this.idCateg.toString();
    data['idUser'] = this.idUser.toString();
    data['idCountrys'] = this.idCountrys.toString();
    data['idCity'] = this.idCity.toString();
    if(idBrand!=null)
    data['idBrand'] = this.idBrand.toString();
    data['locations'] = this.locations!;
    if (idBoost != null) data['idBoost'] = this.idBoost.toString();
    if (idPrize != null) data['idPrize'] = this.idPrize.toString();
    data['active'] = this.active.toString();
    return data;
  }

  Map<String, dynamic> toJsonUpdate() {
    return {
      "title": title,
      "description": description,
      "details": details,
      "price": price,
      "discount":discount,
      "quantity" : quantity,
      "idPricesDelevery" : idPricesDelevery,
      "datePublication" : datePublication,
      "dateEND" : dateEND,

      "idUser": idUser,
      "imagePrinciple": imagePrinciple,
      "videoName": videoName,
      "idCateg": idCateg,
      "idCountrys": idCountrys,
      "idCity": idCity,
      "idBrand" : idBrand,
      "idPrize" : idPrize,
      "locations": locations,
      "idBoost": idBoost,
      "active": active,
    };
  }



}



class ListDealsFeaturesFeatureValues {
  int featureId;
  int featureValueId;

  ListDealsFeaturesFeatureValues({required this.featureId, required this.featureValueId});


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['featureId'] = this.featureId;
    data['featureValueId'] = this.featureValueId;
    return data;
  }
}