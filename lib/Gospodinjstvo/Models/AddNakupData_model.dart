
class AddNakupData {
  int kategorijaNakupa;
  String imeTrgovine;
  String opisNakupa;
  double znesekNakupa;
  List<String> tabelaUpVGos;

  AddNakupData({
    required this.kategorijaNakupa,
    required this.imeTrgovine,
    required this.opisNakupa,
    required this.znesekNakupa,
    required this.tabelaUpVGos,
  });

  factory AddNakupData.fromJson(Map<String, dynamic> parsedJson) {

    var znesek = parsedJson["znesekNakupa"];
    var tabela = parsedJson["tabelaUpVGos"];
    List<String> list = List<String>.from(tabela);

    return AddNakupData(
      kategorijaNakupa: parsedJson["kategorijaNakupa"],
      imeTrgovine: parsedJson["imeTrgovine"],
      opisNakupa: parsedJson["opisNakupa"],
      znesekNakupa: znesek.toDouble(),
      tabelaUpVGos: list,
    );
  }
}