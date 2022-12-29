class LoginUporabnik {

  String imeUporabnika;
  String uporabnikGlobalId;
  String barvaUporabnika;
  String DStoken;
  String mail;

  LoginUporabnik({
    required this.imeUporabnika,
    required this.uporabnikGlobalId,
    required this.barvaUporabnika,
    required this.DStoken,
    required this.mail,
  });

  factory LoginUporabnik.fromJson(Map<String, dynamic> parsedJson){

    return LoginUporabnik(
      imeUporabnika: parsedJson["imeUporabnika"],
      uporabnikGlobalId: parsedJson["idUporabnika"],
      barvaUporabnika: parsedJson["barvaUporabnika"],
      DStoken: parsedJson["DStoken"],
      mail: parsedJson["mail"]
    );
  }

  Map<String, dynamic> toJson() => {
    "imeUporabnika": imeUporabnika,
    "idUporabnika": uporabnikGlobalId,
    "barvaUporabnika": barvaUporabnika,
    "mail": mail,
    "DStoken": DStoken,
  };
}