

class Boost {
  int? idBoost;
  String? titleBoost;
  int? price;
  String? discount;
  int? maxDurationPerDay;
  int? inSliders;
  int? inSideBar;
  int? inFooter;
  int? inRelatedPost;
  int? inFirstLogin;
  int? hasLinks;
  int? orders;

  Boost(
      {this.idBoost,
        this.titleBoost,
        this.price,
        this.discount,
        this.maxDurationPerDay,
        this.inSliders,
        this.inSideBar,
        this.inFooter,
        this.inRelatedPost,
        this.inFirstLogin,
        this.hasLinks,
        this.orders});

  Boost.fromJson(Map<String, dynamic> json) {
    idBoost = json['idBoost'];
    titleBoost = json['titleBoost'];
    price = json['price'];
    discount = json['discount'];
    maxDurationPerDay = json['maxDurationPerDay'];
    inSliders = json['inSliders'];
    inSideBar = json['inSideBar'];
    inFooter = json['inFooter'];
    inRelatedPost = json['inRelatedPost'];
    inFirstLogin = json['inFirstLogin'];
    hasLinks = json['hasLinks'];
    orders = json['orders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idBoost'] = this.idBoost;
    data['titleBoost'] = this.titleBoost;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['maxDurationPerDay'] = this.maxDurationPerDay;
    data['inSliders'] = this.inSliders;
    data['inSideBar'] = this.inSideBar;
    data['inFooter'] = this.inFooter;
    data['inRelatedPost'] = this.inRelatedPost;
    data['inFirstLogin'] = this.inFirstLogin;
    data['hasLinks'] = this.hasLinks;
    data['orders'] = this.orders;
    return data;
  }


}