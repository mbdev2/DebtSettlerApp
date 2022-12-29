
class Izdelek {
  String izdelekId;
  String izdelekIme;
  int izdelekKolicina;
  String izdelekOpis;
  String idAvtorja;

  bool isSelected;

  Izdelek({
    required this.izdelekId,
    required this.izdelekIme,
    required this.izdelekKolicina,
    required this.izdelekOpis,
    required this.idAvtorja,
    this.isSelected = false,
  });

  factory Izdelek.fromJson(Map<String, dynamic> parsedJson){
    return Izdelek(
      izdelekId: parsedJson['_id'],
      izdelekIme : parsedJson ['naslov'],
      izdelekKolicina: parsedJson ['kolicina'],
      izdelekOpis: parsedJson ['opis'],
      idAvtorja: parsedJson['upVGosID'],
    );
  }
}