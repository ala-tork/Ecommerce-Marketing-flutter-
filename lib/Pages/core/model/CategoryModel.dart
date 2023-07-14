class Categories {
  int? idCateg;
  String? title;
  String? description;
  String? image;
  int? idparent;
  int? active;

  Categories(
      {this.idCateg,
        this.title,
        this.description,
        this.image,
        this.idparent,
        this.active});

  Categories.fromJson(Map<String, dynamic> json) {
    idCateg = json['idCateg'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    idparent = json['idparent'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idCateg'] = this.idCateg;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['idparent'] = this.idparent;
    data['active'] = this.active;
    return data;
  }
}