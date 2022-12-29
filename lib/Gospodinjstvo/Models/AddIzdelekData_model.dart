
class AddIzdelekData {
  String izdelekIme;
  int izdelekKolicina;
  String izdelekOpis;
  String idAvtorja;

  AddIzdelekData({
    required this.izdelekIme,
    required this.izdelekKolicina,
    required this.izdelekOpis,
    required this.idAvtorja,
  });

  factory AddIzdelekData.fromJson(Map<String, dynamic> parsedJson){
    return AddIzdelekData(
      izdelekIme : parsedJson ['naslov'],
      izdelekKolicina: parsedJson ['kolicina'],
      izdelekOpis: parsedJson ['opis'],
      idAvtorja: parsedJson['upVGosID'],
    );
  }
}