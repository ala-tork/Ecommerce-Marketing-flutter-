import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AnnounceModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Deals/DealsModel.dart';

class BoostSlideShowModel {
  int? boostedId;
  String? itemType;
  String? datePublication;
  int? price;
  String? locations;
  String? dateEND;
  int? discount;
  String? title;
  String? imageUrl;
  AnnounceModel? ads;
  DealsModel? deals;

  BoostSlideShowModel(
      {this.boostedId,
      this.itemType,
      this.datePublication,
      this.price,
      this.locations,
      this.dateEND,
      this.discount,
      this.title,
      this.imageUrl,
      this.ads,
      this.deals});

  BoostSlideShowModel.fromJson(Map<String, dynamic> json) {
    boostedId = json['boostedId'];
    itemType = json['itemType'];
    datePublication = json['datePublication'];
    price = json['price'];
    locations = json['locations'];
    // if(json['dateEND']!=null)
    dateEND = json['dateEND'];
    // if(json['discount']!=null)
    discount = json['discount'];
    title = json['title'];
    imageUrl = json['imageUrl'];
    ads = json['ads'] != null ? new AnnounceModel.fromJson(json['ads']) : null;
    deals =
        json['deals'] != null ? new DealsModel.fromJson(json['deals']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['boostedId'] = this.boostedId;
    data['itemType'] = this.itemType;
    data['datePublication'] = this.datePublication;
    data['price'] = this.price;
    data['locations'] = this.locations;
    data['dateEND'] = this.dateEND;
    data['discount'] = this.discount;
    data['title'] = this.title;
    data['imageUrl'] = this.imageUrl;
    if (this.ads != null) {
      data['ads'] = this.ads!.toJson();
    }
    if (this.deals != null) {
      data['deals'] = this.deals!.toJson();
    }
    return data;
  }
}
