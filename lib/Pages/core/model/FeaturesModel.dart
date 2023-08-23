import 'package:ecommerceversiontwo/Pages/core/model/FeaturesValuesModel.dart';


class FeaturesModel {
  int? idF;
  String? title;
  String? description;
  String? unit;
  int? active;
  int? idCategory;
  bool? selected=false;
  List<FeaturesValuesModel>?  valuesList=[];
  int? value;

  FeaturesModel(
      {this.idF,
        this.title,
        this.description,
        this.unit,
        this.active,
        this.idCategory,
        this.selected=false,
        this.valuesList,
        this.value,
        });

  FeaturesModel.fromJson(Map<String, dynamic> json) {
    idF = json['idF'];
    title = json['title'];
    description = json['description'];
    unit = json['unit'];
    active = json['active'];
    idCategory = json['idCategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idF'] = this.idF;
    data['title'] = this.title;
    data['description'] = this.description;
    data['unit'] = this.unit;
    data['active'] = this.active;
    data['idCategory'] = this.idCategory;
    return data;
  }


}