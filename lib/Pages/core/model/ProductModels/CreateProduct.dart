class CreateProduct {
  String? codeBar;
  String? codeProduct;
  String? reference;
  String? title;
  String? description;
  String? details;
  String? datePublication;
  int? qte;
  String? color;
  String? unity;
  int? tax;
  int? price;
  int? idPricesDelevery;
  int? discount;
  String? imagePrincipale;
  String? videoName;
  int? idMagasin;
  int? idCateg;
  //Null? categories;
  int? idUser;
  //Null? user;
  int? idCountry;
  //Null? countries;
  int? idCity;
  //Null? cities;
  int? idBrand;
  //Null? brands;
  int? idPrize;
  //Null? prizes;
  int? idBoost;
  //Null? boosts;
  int? active;

  CreateProduct(
      {
        this.codeBar,
        this.codeProduct,
        this.reference,
        this.title,
        this.description,
        this.details,
        this.datePublication,
        this.qte,
        this.color,
        this.unity,
        this.tax,
        this.price,
        this.idPricesDelevery,
        this.discount,
        this.imagePrincipale,
        this.videoName,
        this.idMagasin,
        this.idCateg,
        //this.categories,
        this.idUser,
        //this.user,
        this.idCountry,
        //this.countries,
        this.idCity,
        //this.cities,
        this.idBrand,
        //this.brands,
        this.idPrize,
        //this.prizes,
        this.idBoost,
        //this.boosts,
        this.active});

  CreateProduct.fromJson(Map<String, dynamic> json) {
    codeBar = json['codeBar'];
    codeProduct = json['codeProduct'];
    reference = json['reference'];
    title = json['title'];
    description = json['description'];
    details = json['details'];
    datePublication = json['datePublication'];
    qte = json['qte'];
    color = json['color'];
    unity = json['unity'];
    tax = json['tax'];
    price = json['price'];
    idPricesDelevery = json['idPricesDelevery'];
    discount = json['discount'];
    imagePrincipale = json['imagePrincipale'];
    videoName = json['videoName'];
    idMagasin = json['idMagasin'];
    idCateg = json['idCateg'];
    //categories = json['categories'];
    idUser = json['idUser'];
    //user = json['user'];
    idCountry = json['idCountry'];
    //countries = json['countries'];
    idCity = json['idCity'];
    //cities = json['cities'];
    idBrand = json['idBrand'];
    //brands = json['brands'];
    idPrize = json['idPrize'];
    //prizes = json['prizes'];
    idBoost = json['idBoost'];
    //boosts = json['boosts'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codeBar'] = this.codeBar;
    data['codeProduct'] = this.codeProduct;
    data['reference'] = this.reference;
    data['title'] = this.title;
    data['description'] = this.description;
    data['details'] = this.details;
    if(this.datePublication!=null)
    data['datePublication'] = this.datePublication;
    data['qte'] = this.qte;
    if(this.color!=null)
    data['color'] = this.color;
    if(this.unity!=null)
    data['unity'] = this.unity;
    if(this.tax!=null)
    data['tax'] = this.tax;
    data['price'] = this.price;
    if(this.idPricesDelevery!=null)
    data['idPricesDelevery'] = this.idPricesDelevery;
    data['discount'] = this.discount;
    data['imagePrincipale'] = this.imagePrincipale;
    if(this.videoName!=null)
    data['videoName'] = this.videoName;
    if(this.idMagasin!=null)
    data['idMagasin'] = this.idMagasin;
    data['idCateg'] = this.idCateg;
    //data['categories'] = this.categories;
    data['idUser'] = this.idUser;
    //data['user'] = this.user;
    data['idCountry'] = this.idCountry;
    //data['countries'] = this.countries;
    data['idCity'] = this.idCity;
    //data['cities'] = this.cities;
    data['idBrand'] = this.idBrand;
    //data['brands'] = this.brands;
    if(this.idPrize!=null)
    data['idPrize'] = this.idPrize;
    //data['prizes'] = this.prizes;
    if(this.idBoost!=null)

      data['idBoost'] = this.idBoost;
    //data['boosts'] = this.boosts;
    data['active'] = this.active;
    return data;
  }
}
