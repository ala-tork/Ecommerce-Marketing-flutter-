
class CountriesModel {
  int? idCountrys;
  String? title;
  String? flag;
  String? code;
  String? phoneCode;
  int? active;

  CountriesModel(
      {this.idCountrys,
        this.title,
        this.flag,
        this.code,
        this.phoneCode,
        this.active});

  CountriesModel.fromJson(Map<String, dynamic> json) {
    idCountrys = json['idCountrys'];
    title = json['title'];
    flag = json['flag'];
    code = json['code'];
    phoneCode = json['phoneCode'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idCountrys'] = this.idCountrys;
    data['title'] = this.title;
    data['flag'] = this.flag;
    data['code'] = this.code;
    data['phoneCode'] = this.phoneCode;
    data['active'] = this.active;
    return data;
  }


}