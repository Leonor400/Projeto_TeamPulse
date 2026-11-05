class Atleta {
final String nome; 
final int numero; 
final String posicao;
final bool disponivel; 
final int idade; 
final String peDominante;

Atleta({
  required this.nome,
  required this.numero,
  required this.posicao,
  required this.idade,
  required this.disponivel,
  required this.peDominante,
});

// Converter os dados do servidor num Atleta
factory Atleta.fromMap(Map<String, dynamic> mapa) => Atleta(
  nome: mapa['nome'] as String,
  numero: mapa['numero_camisola'] as int,
  posicao: mapa['posicao'] as String,
  idade: mapa['idade'] as int,
  disponivel: true,
  peDominante: '-',
);
}
