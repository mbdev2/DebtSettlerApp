class LoginData {
  String mail;
  String geslo;

  LoginData({
    required this.mail,
    required this.geslo,
  });

  factory LoginData.fromJson(Map<String, dynamic> parsedJson){

    return LoginData(
      mail: parsedJson["mail"],
      geslo: parsedJson["geslo"],
    );
  }

  Map<String, dynamic> toJson() => {
    "mail": mail,
    "geslo": geslo,
  };


}