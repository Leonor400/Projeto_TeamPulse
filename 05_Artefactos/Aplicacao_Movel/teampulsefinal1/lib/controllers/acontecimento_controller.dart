import 'package:flutter/foundation.dart';

import '../models/acontecimento.dart';

class AcontecimentoController extends ChangeNotifier {
  final List<Acontecimento> _acontecimentos = [];

  List<Acontecimento> get acontecimentos => List.unmodifiable(_acontecimentos);

  void adicionarAcontecimento(Acontecimento acontecimento) {
    _acontecimentos.add(acontecimento);
    notifyListeners();
  }

  // Remover acontecimento
  void removerAcontecimento(Acontecimento acontecimento) {
    _acontecimentos.remove(acontecimento);
    notifyListeners();
  }

  List<Acontecimento> acontecimentosDoJogo(String jogoId) {
    return _acontecimentos
        .where((acontecimento) => acontecimento.jogoId == jogoId)
        .toList();
  }

  int contarGolos(String nomeAtleta) {
    int total = 0;

    for (final acontecimento in _acontecimentos) {
      if (acontecimento.tipo == 'Golo' &&
          acontecimento.atleta.trim() == nomeAtleta.trim()) {
        total++;
      }
    }

    return total;
  }

  int contarAssistencias(String nomeAtleta) {
    int total = 0;

    for (final acontecimento in _acontecimentos) {
      if (acontecimento.tipo == 'Assistência' &&
          acontecimento.atleta.trim() == nomeAtleta.trim()) {
        total++;
      }
    }

    return total;
  }
}
