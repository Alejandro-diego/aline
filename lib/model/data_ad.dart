class DataAd {
  bool status;
  String nome;
  String saida;
  int dimmerValue;
  bool isDimmerIsOn;
  bool isCCTOn;
  bool isRGBOn;

  DataAd(
      {required this.status,
      required this.isCCTOn,
      required this.isRGBOn,
      required this.isDimmerIsOn,
      required this.nome,
      required this.saida,
      required this.dimmerValue});

  factory DataAd.fromRTDB(Map<String, dynamic> data) {
    return DataAd(
        isRGBOn: data['isRGBOn'] ?? false,
        isCCTOn: data['isCCTOn'] ?? false,
        isDimmerIsOn: data['isDimmerIsOn'] ?? false,
        status: data['status'] ?? false,
        nome: data['nome'] ?? 'Saidas',
        saida: data["saida"] ?? '1',
        dimmerValue: data["dimmerValue"] ?? 10);
  }
}
