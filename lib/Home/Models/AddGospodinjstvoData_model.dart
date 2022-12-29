class AddGospodinjstvoData {
  String imeGospodinjstva;
  String geslo;

  AddGospodinjstvoData({
    required this.imeGospodinjstva,
    required this.geslo,
  });

  factory AddGospodinjstvoData.fromJson(Map<String, dynamic> parsedJson){

    return AddGospodinjstvoData(
      imeGospodinjstva: parsedJson["imeimeGospodinjstva"],
      geslo: parsedJson["geslo"],
    );
  }

  Map<String, dynamic> toJson() => {
    "mail": imeGospodinjstva,
    "geslo": geslo,
  };


}