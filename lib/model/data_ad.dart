class DataAd {
  bool rele;
  String nome;
  String saida;
  int dimmerValue;
  bool isDimmerIsOn;
  bool isCCTOn;
  bool isRGBOn;
  bool programarHora;
  String listaDeHorasInicio;

  DataAd(
      {required this.listaDeHorasInicio,
      required this.rele,
      required this.programarHora,
      required this.isCCTOn,
      required this.isRGBOn,
      required this.isDimmerIsOn,
      required this.nome,
      required this.saida,
      required this.dimmerValue});

  factory DataAd.fromRTDB(Map<String, dynamic> data) {
    return DataAd(
        listaDeHorasInicio: data['listaDeHorasInicio'] ?? '',
        programarHora: data['programarHora'] ?? false,
        isRGBOn: data['isRGBOn'] ?? false,
        isCCTOn: data['isCCTOn'] ?? false,
        isDimmerIsOn: data['isDimmerIsOn'] ?? false,
        rele: data['rele'] ?? false,
        nome: data['nome'] ?? 'Saidas',
        saida: data["saida"] ?? '1',
        dimmerValue: data["dimmerValue"] ?? 10);
  }
}
