class FilterProduct {
  String? productName;
  String? codeBar;
  String? codeProd;
  String? reference;
  int? idCountrys;
  int? idBrand;
  int? idCity;
  List<int?>? idFeaturesValues;
  int? idCategory;
  double? minPrice;
  double? maxPrice;
  int pageNumber;

  FilterProduct({
    this.productName,
    this.codeBar,
    this.codeProd,
    this.reference,
    this.idCountrys,
    this.idCity,
    this.idBrand,
    this.idFeaturesValues,
    this.idCategory,
    this.minPrice,
    this.maxPrice,
    required this.pageNumber,
  });

  factory FilterProduct.fromJson(Map<String, dynamic> json) {
    return FilterProduct(
      productName: json['productName'],
      codeBar: json['codeBar'],
      codeProd: json['codeProd'],
      reference: json['reference'],
      idCountrys: json['idCountrys'],
      idCity: json['idCity'],
      idBrand: json['idBrand'],
      idFeaturesValues: List<int?>.from(json['IdFeaturesValues']),
      idCategory: json['idCategory'],
      minPrice: json['minPrice'],
      maxPrice: json['maxPrice'],
      pageNumber: json['pageNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'pageNumber': pageNumber,
    };
    if (productName != null) data['productName'] = productName;
    if (codeBar != null) data['codeBar'] = codeBar;
    if (codeProd != null) data['codeProd'] = codeProd;
    if (reference != null) data['reference'] = reference;
    if (idCountrys != null) data['idCountrys'] = idCountrys;
    if (idCity != null) data['idCity'] = idCity;
    if (idBrand != null) data['idBrand'] = idBrand;
    if (idFeaturesValues != null) data['idFeaturesValues'] = idFeaturesValues;
    if (idCategory != null) data['idCategory'] = idCategory;
    if (minPrice != null) data['minPrice'] = minPrice;
    if (maxPrice != null) data['maxPrice'] = maxPrice;

    return data;
  }
}
