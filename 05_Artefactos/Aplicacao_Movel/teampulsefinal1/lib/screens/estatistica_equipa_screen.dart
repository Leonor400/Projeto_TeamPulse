import 'package:flutter/material.dart';

import '../controllers/jogo_controller.dart';
import '../controllers/acontecimento_controller.dart';
import '../controllers/equipa_controller.dart';
import '../models/jogo.dart';

class EstatisticasEquipaScreen extends StatefulWidget {
  final JogoController jogoController;
  final AcontecimentoController? acontecimentoController;
  final Equipacontroller equipacontroller;

  const EstatisticasEquipaScreen({
    super.key,
    required this.jogoController,
    this.acontecimentoController,
    required this.equipacontroller,
  });

  @override
  State<EstatisticasEquipaScreen> createState() =>
      _EstatisticasEquipaScreenState();
}

class _EstatisticasEquipaScreenState extends State<EstatisticasEquipaScreen> {
  static const Color fundo = Color(0xFF200607);
  static const Color cartao = Color(0xFF752329);
  static const Color vermelho = Color(0xFFFF0033);

  @override
  void initState() {
    super.initState();
    widget.jogoController.addListener(atualizar);
    widget.acontecimentoController?.addListener(atualizar);
  }

  void atualizar() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.jogoController.removeListener(atualizar);
    widget.acontecimentoController?.removeListener(atualizar);
    super.dispose();
  }

  DateTime? converterData(String texto) {
    try {
      final partes = texto.split('/');
      if (partes.length != 3) return null;

      final dia = int.parse(partes[0]);
      final mes = int.parse(partes[1]);
      final ano = int.parse(partes[2]);

      final data = DateTime(ano, mes, dia);

      if (data.day != dia || data.month != mes || data.year != ano) {
        return null;
      }

      return data;
    } catch (_) {
      return null;
    }
  }

  Widget tituloSecao(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        titulo,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget numeroClassificacao(String numero, String legenda, Color cor) {
    return Expanded(
      child: Column(
        children: [
          Text(
            numero,
            style: TextStyle(
              color: cor,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            legenda,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget construirClassificacao(
    int total,
    int vitorias,
    int empates,
    int derrotas,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cartao,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CLASSIFICAÇÃO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              numeroClassificacao('$total', 'J', Colors.white),
              numeroClassificacao('$vitorias', 'V', const Color(0xFF24D45A)),
              numeroClassificacao('$empates', 'E', const Color(0xFFFFA500)),
              numeroClassificacao('$derrotas', 'D', const Color(0xFFFF444F)),
            ],
          ),
          const SizedBox(height: 17),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 7,
              child: total == 0
                  ? Container(color: Colors.white24)
                  : Row(
                      children: [
                        if (vitorias > 0)
                          Expanded(
                            flex: vitorias,
                            child: Container(color: const Color(0xFF24D45A)),
                          ),
                        if (empates > 0)
                          Expanded(
                            flex: empates,
                            child: Container(color: const Color(0xFFFFA500)),
                          ),
                        if (derrotas > 0)
                          Expanded(
                            flex: derrotas,
                            child: Container(color: const Color(0xFFFF444F)),
                          ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget construirMarcadoras() {
    final controller = widget.acontecimentoController;

    if (controller == null) {
      return mensagemVazia(
        'Ainda não existem estatísticas de marcadoras disponíveis.',
      );
    }

    final atletas = widget.equipacontroller.atletas;

    final ranking = atletas
        .map((atleta) {
          return (
            nome: atleta.nome,
            golos: controller.contarGolos(atleta.nome),
            assistencias: controller.contarAssistencias(atleta.nome),
          );
        })
        .where((item) {
          return item.golos > 0 || item.assistencias > 0;
        })
        .toList();

    ranking.sort((a, b) {
      final comparacaoGolos = b.golos.compareTo(a.golos);

      if (comparacaoGolos != 0) {
        return comparacaoGolos;
      }

      return b.assistencias.compareTo(a.assistencias);
    });

    if (ranking.isEmpty) {
      return mensagemVazia(
        'Ainda não existem golos ou assistências registados.',
      );
    }

    final melhores = ranking.take(4).toList();

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cartao,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: List.generate(melhores.length, (index) {
          final atleta = melhores[index];

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              color: index.isEven ? cartao : const Color(0xFF682027),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: index == 0 ? vermelho : Colors.white54,
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    atleta.nome,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                colunaNumero('${atleta.golos}', 'Golos'),
                const SizedBox(width: 18),
                colunaNumero('${atleta.assistencias}', 'Ass.'),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget colunaNumero(String numero, String legenda) {
    return Column(
      children: [
        Text(
          numero,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          legenda,
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
      ],
    );
  }

  Widget mensagemVazia(String mensagem) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cartao,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Text(
        mensagem,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white70, fontSize: 13),
      ),
    );
  }

  Widget construirResultados(List<Jogo> jogosRealizados) {
    if (jogosRealizados.isEmpty) {
      return mensagemVazia('Ainda não existem resultados registados.');
    }

    final ordenados = [...jogosRealizados];

    ordenados.sort((a, b) {
      final dataA = converterData(a.data);
      final dataB = converterData(b.data);

      if (dataA == null || dataB == null) return 0;

      return dataB.compareTo(dataA);
    });

    final recentes = ordenados.take(4).toList();

    return Column(
      children: recentes.map((jogo) {
        final marcados = jogo.golosMarcados!;
        final sofridos = jogo.golosSofridos!;

        final vitoria = marcados > sofridos;
        final empate = marcados == sofridos;

        final letra = vitoria
            ? 'V'
            : empate
            ? 'E'
            : 'D';

        final cor = vitoria
            ? const Color(0xFF24D45A)
            : empate
            ? const Color(0xFFFFA500)
            : const Color(0xFFFF444F);

        return Container(
          margin: const EdgeInsets.only(bottom: 9),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: cartao,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: cor.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(
                  letra,
                  style: TextStyle(
                    color: cor,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'vs ${jogo.adversario}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      jogo.data,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$marcados-$sofridos',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jogosRealizados = widget.jogoController.jogos
        .where(
          (jogo) => jogo.golosMarcados != null && jogo.golosSofridos != null,
        )
        .toList();

    final total = jogosRealizados.length;

    final vitorias = jogosRealizados
        .where((jogo) => jogo.golosMarcados! > jogo.golosSofridos!)
        .length;

    final empates = jogosRealizados
        .where((jogo) => jogo.golosMarcados == jogo.golosSofridos)
        .length;

    final derrotas = jogosRealizados
        .where((jogo) => jogo.golosMarcados! < jogo.golosSofridos!)
        .length;

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: fundo,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Estatísticas',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagens/FundoApp.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
            children: [
              const Text(
                'Estatísticas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Desempenho da equipa',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 22),

              construirClassificacao(total, vitorias, empates, derrotas),

              const SizedBox(height: 26),

              tituloSecao('MELHORES MARCADORAS'),
              construirMarcadoras(),

              const SizedBox(height: 26),

              tituloSecao('RESULTADOS RECENTES'),
              construirResultados(jogosRealizados),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
