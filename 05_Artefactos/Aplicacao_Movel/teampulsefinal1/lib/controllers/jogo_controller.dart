import 'package:flutter/foundation.dart';

import '../models/jogo.dart';
import '../models/acontecimento.dart';

class JogoController extends ChangeNotifier {
  final List<Jogo> _jogos = [];

  List<Jogo> get jogos => List.unmodifiable(_jogos);

  // Adicionar jogo
  void adicionarJogo(Jogo jogo) {
    _jogos.add(jogo);
    notifyListeners();
  }

  // Remover jogo
  void removerJogo(Jogo jogo) {
    _jogos.remove(jogo);
    notifyListeners();
  }

  // Atualizar resultado
  void atualizarResultados(Jogo jogo, int golosMarcados, int golosSofridos) {
    final index = _jogos.indexOf(jogo);

    if (index == -1) return;

    _jogos[index] = Jogo(
      id: jogo.id,
      adversario: jogo.adversario,
      data: jogo.data,
      hora: jogo.hora,
      local: jogo.local,
      emCasa: jogo.emCasa,
      golosMarcados: golosMarcados,
      golosSofridos: golosSofridos,
      minutoFim: jogo.minutoFim,
      titulares: jogo.titulares,
    );

    notifyListeners();
  }

  // Verificar se uma atleta participou num jogo
  bool participouNoJogo(
    String nomeAtleta,
    Jogo jogo,
    List<Acontecimento> acontecimentos,
  ) {
    if (jogo.minutoFim == null) {
      return false;
    }

    final nome = nomeAtleta.trim();

    final foiTitular = jogo.titulares.any((titular) => titular.trim() == nome);

    final entrouComoSuplente = acontecimentos.any(
      (acontecimento) =>
          acontecimento.jogoId == jogo.id &&
          acontecimento.tipo == 'Substituição' &&
          acontecimento.atletaEntra?.trim() == nome &&
          acontecimento.minuto <= jogo.minutoFim!,
    );

    return foiTitular || entrouComoSuplente;
  }

  // Obter o histórico de jogos de uma atleta
  List<Jogo> historicoAtleta(
    String nomeAtleta,
    List<Acontecimento> acontecimentos,
  ) {
    return _jogos.where((jogo) {
      return participouNoJogo(nomeAtleta, jogo, acontecimentos);
    }).toList();
  }

  // Contar jogos realizados
  int contarJogos(String nomeAtleta, List<Acontecimento> acontecimentos) {
    return historicoAtleta(nomeAtleta, acontecimentos).length;
  }

  // Calcular minutos jogados
  int contarMinutos(String nomeAtleta, List<Acontecimento> acontecimentos) {
    int totalMinutos = 0;
    final nome = nomeAtleta.trim();

    for (final jogo in _jogos) {
      final minutoFim = jogo.minutoFim;

      if (minutoFim == null) {
        continue;
      }

      final acontecimentosDoJogo = acontecimentos
          .where((a) => a.jogoId == jogo.id)
          .toList();

      acontecimentosDoJogo.sort((a, b) => a.minuto.compareTo(b.minuto));

      int? minutoEntrada =
          jogo.titulares.any((titular) => titular.trim() == nome) ? 0 : null;

      for (final acontecimento in acontecimentosDoJogo) {
        if (acontecimento.tipo != 'Substituição') {
          continue;
        }

        final minuto = acontecimento.minuto;

        if (minuto > minutoFim) {
          continue;
        }

        final atletaSai = acontecimento.atleta.trim();
        final atletaEntra = acontecimento.atletaEntra?.trim();

        if (atletaSai == nome && minutoEntrada != null) {
          totalMinutos += minuto - minutoEntrada;
          minutoEntrada = null;
        }

        if (atletaEntra == nome && minutoEntrada == null) {
          minutoEntrada = minuto;
        }
      }

      if (minutoEntrada != null) {
        totalMinutos += minutoFim - minutoEntrada;
      }
    }

    return totalMinutos;
  }
}
