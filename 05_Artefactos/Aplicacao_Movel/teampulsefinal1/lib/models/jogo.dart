class Jogo {
  final String adversario;
  final String data;
  final String hora;
  final String local; 
  final bool emCasa; 
  final int? golosMarcados;
  final int? golosSofridos; 
  final int? minutoFim;
  final List<String> titulares;
  final String id; 

  Jogo({
    required this.adversario,
    required this.data, 
    required this.emCasa,
    required this.golosMarcados, 
    required this.golosSofridos,
    required this.hora,
    required this.local,
    this.minutoFim,
    this.titulares = const [],
    required this.id, 
  });
}