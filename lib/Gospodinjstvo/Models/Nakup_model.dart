
class Nakup {
  int kategorijaNakupa;
  String imeTrgovine;
  String opisNakupa;
  double znesekNakupa;
  String upVGosID;
  List<String> tabelaUpVGos;
  String id;
  DateTime datumNakupa;

  Nakup({
    required this.kategorijaNakupa,
    required this.imeTrgovine,
    required this.opisNakupa,
    required this.znesekNakupa,
    required this.upVGosID,
    required this.tabelaUpVGos,
    required this.id,
    required this.datumNakupa,
  });

  factory Nakup.fromJson(Map<String, dynamic> parsedJson) {

    var znesek = parsedJson["znesekNakupa"];
    var datum = parsedJson["datumNakupa"];
    var tabela = parsedJson["tabelaUpVGos"];
    List<String> list = new List<String>.from(tabela);

    return Nakup(
      kategorijaNakupa: parsedJson["kategorijaNakupa"],
      imeTrgovine: parsedJson["imeTrgovine"],
      opisNakupa: parsedJson["opisNakupa"],
      znesekNakupa: znesek.toDouble(),
      upVGosID: parsedJson["upVGosID"],
      tabelaUpVGos: list,
      id: parsedJson["_id"],
      datumNakupa: DateTime.parse(datum),
    );
  }
}