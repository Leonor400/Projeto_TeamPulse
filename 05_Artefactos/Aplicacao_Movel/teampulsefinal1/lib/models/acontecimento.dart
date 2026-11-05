class Acontecimento {
  final String tipo;
  final int minuto;
  final String atleta;
  final String descricao;
  final String? atletaEntra;
  final String? jogoId;

  Acontecimento({
    required this.tipo,
    required this.minuto,
    required this.atleta,
    required this.descricao,
    this.atletaEntra,
    this.jogoId, 
  });
}
