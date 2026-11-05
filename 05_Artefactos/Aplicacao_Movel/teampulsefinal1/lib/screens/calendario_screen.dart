import 'package:flutter/material.dart';

import '../models/jogo.dart';
import '../controllers/jogo_controller.dart';
import '../controllers/acontecimento_controller.dart';

import 'adicionar_jogo_screen.dart';
import 'adicionar_acontecimentos_screen.dart';
import 'acontecimentos_jogo_screen.dart';

class CalendarioScreen extends StatefulWidget {
  final JogoController jogoController;
  final AcontecimentoController acontecimentoController;
  final bool modoAtleta;

  const CalendarioScreen({
    super.key,
    required this.jogoController,
    required this.acontecimentoController,
    this.modoAtleta = false,
  });

  @override
  State<CalendarioScreen> createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  late DateTime mesAtual;
  late DateTime diaSelecionado;

  final List<String> meses = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  List<Jogo> get jogos => widget.jogoController.jogos;

  @override
  void initState() {
    super.initState();

    final agora = DateTime.now();
    mesAtual = DateTime(agora.year, agora.month);
    diaSelecionado = DateTime(agora.year, agora.month, agora.day);

    widget.jogoController.addListener(atualizarCalendario);
  }

  @override
  void dispose() {
    widget.jogoController.removeListener(atualizarCalendario);
    super.dispose();
  }

  void atualizarCalendario() {
    if (mounted) {
      setState(() {});
    }
  }

  String formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return '$dia/$mes/${data.year}';
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

  bool mesmoDia(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool temJogo(DateTime data) {
    return jogos.any((jogo) {
      final dataJogo = converterData(jogo.data);
      return dataJogo != null && mesmoDia(dataJogo, data);
    });
  }

  void mudarMes(int quantidade) {
    setState(() {
      mesAtual = DateTime(mesAtual.year, mesAtual.month + quantidade);

      diaSelecionado = DateTime(mesAtual.year, mesAtual.month, 1);
    });
  }

  Future<void> adicionarJogo() async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AdicionarJogoScreen(jogoController: widget.jogoController),
      ),
    );

    if (!mounted) return;

    if (resultado == true) {
      if (jogos.isNotEmpty) {
        final data = converterData(jogos.last.data);

        if (data != null) {
          setState(() {
            mesAtual = DateTime(data.year, data.month);
            diaSelecionado = data;
          });
        }
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Jogo criado com sucesso!')));
    }
  }

  Future<void> abrirJogo(Jogo jogo) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AcontecimentosJogoScreen(
          jogo: jogo,
          acontecimentoController: widget.acontecimentoController,
          modoAtleta: widget.modoAtleta,
        ),
      ),
    );
  }

  Widget construirCalendario() {
    final primeiroDia = DateTime(mesAtual.year, mesAtual.month, 1);

    final diasNoMes = DateTime(mesAtual.year, mesAtual.month + 1, 0).day;

    final diasAntes = primeiroDia.weekday - 1;
    final totalCelulas = ((diasAntes + diasNoMes + 6) ~/ 7) * 7;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF702126),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => mudarMes(-1),
                icon: const Icon(Icons.chevron_left, color: Colors.white),
              ),
              Column(
                children: [
                  Text(
                    meses[mesAtual.month - 1],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${mesAtual.year}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => mudarMes(1),
                icon: const Icon(Icons.chevron_right, color: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: ['S', 'T', 'Q', 'Q', 'S', 'S', 'D']
                .map(
                  (dia) => Expanded(
                    child: Center(
                      child: Text(
                        dia,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 10),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalCelulas,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final numeroDia = index - diasAntes + 1;

              if (numeroDia < 1 || numeroDia > diasNoMes) {
                return const SizedBox();
              }

              final data = DateTime(mesAtual.year, mesAtual.month, numeroDia);

              final selecionado = mesmoDia(data, diaSelecionado);

              final existeJogo = temJogo(data);

              return InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  setState(() {
                    diaSelecionado = data;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: selecionado
                        ? const Color(0xFFE50922)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$numeroDia',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: selecionado
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (existeJogo)
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 15),

          const Row(
            children: [
              Icon(Icons.circle, color: Color(0xFFE50922), size: 10),
              SizedBox(width: 5),
              Text('Jogo', style: TextStyle(color: Colors.white70)),
              SizedBox(width: 20),
              Icon(Icons.circle, color: Colors.pinkAccent, size: 10),
              SizedBox(width: 5),
              Text('Treino', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget construirJogosDoDia() {
    final jogosDoDia = jogos.where((jogo) {
      final data = converterData(jogo.data);

      return data != null && mesmoDia(data, diaSelecionado);
    }).toList();

    if (jogosDoDia.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF702126),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Text(
          'Não existem jogos registados neste dia.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return Column(
      children: jogosDoDia.map((jogo) {
        return InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => abrirJogo(jogo),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF702126),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(Icons.sports_soccer, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jogo.emCasa
                            ? 'CBF — ${jogo.adversario}'
                            : '${jogo.adversario} — CBF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${jogo.hora} · ${jogo.local}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        jogo.data,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      if (jogo.golosMarcados != null &&
                          jogo.golosSofridos != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            'Resultado: ${jogo.golosMarcados} - ${jogo.golosSofridos}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white70),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF200607),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagens/FundoApp.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/imagens/logoPrincipal.png',
                      width: 100,
                      height: 70,
                    ),
                    if (!widget.modoAtleta)
                      IconButton(
                        onPressed: adicionarJogo,
                        icon: const Icon(
                          Icons.add_circle,
                          color: Colors.red,
                          size: 32,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                const Text(
                  'Calendário',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '${jogos.length} jogos registados',
                  style: const TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView(
                    children: [
                      construirCalendario(),

                      const SizedBox(height: 25),

                      Text(
                        '${diaSelecionado.day} DE '
                        '${meses[diaSelecionado.month - 1].toUpperCase()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      construirJogosDoDia(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
