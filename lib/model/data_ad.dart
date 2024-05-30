class DataAd {
  bool status;
  String nome;
  String saida;
  String saida1;
  int dimmerValue;
  bool isDimmerIsOn;

  DataAd(
      {required this.status,
      required this.isDimmerIsOn,
      required this.nome,
      required this.saida,
      required this.saida1,
      required this.dimmerValue});

  factory DataAd.fromRTDB(Map<String, dynamic> data) {
    return DataAd(
      isDimmerIsOn: data ['isDimmerIsOn'] ?? false,
        status: data['status'] ?? false,
        nome: data['nome'] ?? 'Saidas',
        saida: data["saida"] ?? '1',
        saida1: data["saida"] ?? '1',
        dimmerValue: data["dimmerValue"] ?? 10);
  }
}
