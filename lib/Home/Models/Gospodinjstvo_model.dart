
class GospodinjstvoModel {
  String imeGospodinjstva;
  String gsToken;
  bool isAdmin;

  GospodinjstvoModel({
    required this.imeGospodinjstva,
    required this.gsToken,
    this.isAdmin = false,
  });

  factory GospodinjstvoModel.fromJson(Map<String, dynamic> parsedJson) {

    var admin = true;
    if (parsedJson['isAdmin'] != null) {
      admin = parsedJson['isAdmin'];
    }

    return GospodinjstvoModel(
      imeGospodinjstva: parsedJson['imeGospodinjstva'],
      gsToken: parsedJson['GStoken'],
      isAdmin: admin,
    );
  }

  Map<String, dynamic> toJson() => {
    "imeGospodinjstva": imeGospodinjstva,
    "GStoken": gsToken,
    "isAdmin": isAdmin,
  };
}

class GospodinjstvoNoToken {
  String imeGospodinjstva;
  bool isAdmin;

  GospodinjstvoNoToken({
    required this.imeGospodinjstva,
    this.isAdmin = false,
  });

  factory GospodinjstvoNoToken.fromGospodinjstvo(GospodinjstvoModel gospodinjstvo) {
    return GospodinjstvoNoToken(
      imeGospodinjstva: gospodinjstvo.imeGospodinjstva,
      isAdmin: gospodinjstvo.isAdmin,
    );
}
}