
class Uporabnik {
  String uporabnikId;
  String upVGosID;
  String ime;
  double stanje;
  String barvaUporabnika;
  double porabljenDenar;

  Uporabnik({
    required this.uporabnikId,
    required this.upVGosID,
    required this.ime,
    required this.stanje,
    required this.barvaUporabnika,
    required this.porabljenDenar,
  });

  factory Uporabnik.fromJson(Map<String, dynamic> parsedJson){

    var stanje = parsedJson["stanjeDenarja"];
    var porabljen = parsedJson["porabljenDenar"];

    return Uporabnik(
      uporabnikId: parsedJson["idUporabnika"],
      upVGosID: parsedJson["upVGosID"],
      ime : parsedJson["imeUporabnika"],
      stanje: stanje.toDouble(),
      barvaUporabnika: parsedJson ['barvaUporabnika'],
      porabljenDenar: porabljen.toDouble(),
    );
  }

}


