

class FeaturesValuesModel {
  int? idFv;
  String? title;
  int? active;
  int? idF;
  bool? selected=false;
  //FeaturesModel? features;

  FeaturesValuesModel(
      {this.idFv, this.title, this.active, this.idF,this.selected /*this.features*/});

  FeaturesValuesModel.fromJson(Map<String, dynamic> json) {
    idFv = json['idFv'];
    title = json['title'];
    active = json['active'];
    idF = json['idF'];
   /* features = json['features'] != null
        ? new FeaturesModel.fromJson(json['features'])
        : null;*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idFv'] = this.idFv;
    data['title'] = this.title;
    data['active'] = this.active;
    data['idF'] = this.idF;
   /* if (this.features != null) {
      data['features'] = this.features!.toJson();
    }*/
    return data;
  }


}