class RegistrationData {
  String ime;
  String mail;
  String geslo;
  String barva;

  RegistrationData({
    required this.ime,
    required this.mail,
    required this.geslo,
    required this.barva,
  });

  factory RegistrationData.fromJson(Map<String, dynamic> parsedJson){

    return RegistrationData(
      ime: parsedJson["ime"],
      mail: parsedJson["mail"],
      geslo: parsedJson["geslo"],
      barva: parsedJson["barvaUporabnika"],
    );
  }

  Map<String, dynamic> toJson() => {
    "ime": ime,
    "mail": mail,
    "geslo": geslo,
    "barvaUporabnika": barva
  };


}