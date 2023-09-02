

class User {
  int? id;
  String? email;
  String? password;
  String? firstname;
  String? lastname;
  String? imageUrl;
  String? phone;
  String? country;
  String? address;
  String? role;
  String? dateInscription;
  int? active;
  int? isPro;
  int? isverified;
  int? isPremium;
  int? nbDiamon;
  String? refreshToken;

  User(
      {this.id,
        this.email,
        this.password,
        this.firstname,
        this.lastname,
        this.imageUrl,
        this.phone,
        this.country,
        this.address,
        this.role,
        this.dateInscription,
        this.active,
        this.isPro,
        this.isverified,
        this.isPremium,
        this.nbDiamon,
        this.refreshToken});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    imageUrl = json['imageUrl'];
    phone = json['phone'];
    country = json['country'];
    address = json['address'];
    role = json['role'];
    dateInscription = json['dateInscription'];
    active = json['active'];
    isPro = json['isPro'];
    isverified = json['isverified'];
    isPremium = json['isPremium'];
    nbDiamon = json['nbDiamon'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['password'] = this.password;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['imageUrl'] = this.imageUrl;
    data['phone'] = this.phone;
    data['country'] = this.country;
    data['address'] = this.address;
    data['role'] = this.role;
    data['dateInscription'] = this.dateInscription;
    data['active'] = this.active;
    data['isPro'] = this.isPro;
    data['isverified'] = this.isverified;
    data['isPremium'] = this.isPremium;
    data['nbDiamon'] = this.nbDiamon;
    data['refreshToken'] = this.refreshToken;
    return data;
  }


}