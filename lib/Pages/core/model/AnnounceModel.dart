
class AnnounceModel{
  int id;
  String title;
  String? shortDescription;
  double price;
  String image;
  bool boosted;
  DateTime? datepub;
  AnnounceModel({required this.id,required this.title,this.shortDescription,required this.price,required this.image,required this.boosted});
}
