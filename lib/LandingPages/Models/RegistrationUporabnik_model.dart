class RegistrationUporabnik {

  String DStoken;

  RegistrationUporabnik({
    required this.DStoken,
  });

  factory RegistrationUporabnik.fromJson(Map<String, dynamic> parsedJson){

    return RegistrationUporabnik(
      DStoken: parsedJson["DStoken"],
    );
  }
}