class User {
  int? id;
  String? email;
  String? password;
  String? firstname;
  String? lastname;
  String? phone;
  String? country;
  String? address;
  String? role;
  String? dateInscription;
  int? active;
  String? refreshToken;

  User(
      {this.id,
        this.email,
        this.password,
        this.firstname,
        this.lastname,
        this.phone,
        this.country,
        this.address,
        this.role,
        this.dateInscription,
        this.active,
        this.refreshToken});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phone = json['phone'];
    country = json['country'];
    address = json['address'];
    role = json['role'];
    dateInscription = json['dateInscription'];
    active = json['active'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['password'] = this.password;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['phone'] = this.phone;
    data['country'] = this.country;
    data['address'] = this.address;
    data['role'] = this.role;
    data['dateInscription'] = this.dateInscription;
    data['active'] = this.active;
    data['refreshToken'] = this.refreshToken;
    return data;
  }
}