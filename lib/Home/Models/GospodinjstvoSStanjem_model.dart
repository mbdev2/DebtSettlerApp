
class GospodinjstvoSStanjemModel {
  String imeGospodinjstva;
  bool isAdmin;
  double stanjePrijavljenega;

  GospodinjstvoSStanjemModel({
    required this.imeGospodinjstva,
    required this.stanjePrijavljenega,
    this.isAdmin = false,
  });

}