import 'package:flutter/material.dart';

import '../models/atleta.dart';
import '../controllers/jogo_controller.dart';
import '../controllers/acontecimento_controller.dart';
import 'selecionar_jogo_screen.dart';

class EstatisticasAtletaScreen extends StatelessWidget {
  final Atleta atleta;
  final JogoController jogoController;
  final AcontecimentoController acontecimentoController;
  final bool modoAtleta;

  const EstatisticasAtletaScreen({
    super.key,
    required this.atleta,
    required this.jogoController,
    required this.acontecimentoController,
    this.modoAtleta = false,
  });

  BoxDecoration _decoracaoCartao() {
    return BoxDecoration(
      color: const Color(0xFF702126),
      borderRadius: BorderRadius.circular(15),
    );
  }

  Widget _cartaoEstatistica(String titulo, String valor, IconData icone) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: _decoracaoCartao(),
        child: Column(
          children: [
            Icon(icone, color: Colors.white70, size: 26),
            const SizedBox(height: 10),
            Text(
              valor,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nomeAtleta = atleta.nome;

    // Acontecimentos registados
    final acontecimentos = acontecimentoController.acontecimentos;

    // Estatísticas da atleta
    final jogos = jogoController.contarJogos(nomeAtleta, acontecimentos);

    final minutos = jogoController.contarMinutos(nomeAtleta, acontecimentos);

    final golos = acontecimentoController.contarGolos(nomeAtleta);

    final assistencias = acontecimentoController.contarAssistencias(nomeAtleta);

    // Histórico de jogos
    final historico = jogoController.historicoAtleta(
      nomeAtleta,
      acontecimentos,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF200607),
      appBar: AppBar(
        backgroundColor: const Color(0xFF300B0E),
        foregroundColor: Colors.white,
        title: const Text('Estatísticas da Atleta'),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cartão de identificação da atleta
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: _decoracaoCartao(),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundColor: Color(0xFF40191C),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              atleta.nome,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '#${atleta.numero} · ${atleta.posicao}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              atleta.disponivel ? 'Disponível' : 'Lesionada',
                              style: TextStyle(
                                color: atleta.disponivel
                                    ? Colors.greenAccent
                                    : Colors.orangeAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Título das estatísticas
                const Text(
                  'Estatísticas da Época',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                // Jogos e minutos
                Row(
                  children: [
                    _cartaoEstatistica(
                      'Jogos',
                      jogos.toString(),
                      Icons.sports_soccer,
                    ),
                    const SizedBox(width: 12),
                    _cartaoEstatistica(
                      'Minutos',
                      minutos.toString(),
                      Icons.timer_outlined,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Golos e assistências
                Row(
                  children: [
                    _cartaoEstatistica(
                      'Golos',
                      golos.toString(),
                      Icons.sports_score,
                    ),
                    const SizedBox(width: 12),
                    _cartaoEstatistica(
                      'Assistências',
                      assistencias.toString(),
                      Icons.assistant_outlined,
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // Assiduidade
                const Text(
                  'Assiduidade aos Treinos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: _decoracaoCartao(),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Presenças',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            '0%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      LinearProgressIndicator(
                        value: 0,
                        minHeight: 10,
                        backgroundColor: Color(0xFF40191C),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFE50922),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '0 presenças em 0 treinos',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Histórico de Jogos
                const Text(
                  'Histórico de Jogos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                if (historico.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: _decoracaoCartao(),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.event_note_outlined,
                          color: Colors.white70,
                          size: 35,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Ainda não existem jogos registados.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  )
                else
                  ...historico.map(
                    (jogo) => Card(
                      color: const Color(0xFF702126),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const Icon(
                          Icons.sports_soccer,
                          color: Colors.white,
                        ),
                        title: Text(
                          jogo.emCasa
                              ? 'CFB vs ${jogo.adversario}'
                              : '${jogo.adversario} vs CFB',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${jogo.data} | ${jogo.local}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: Text(
                          jogo.golosMarcados != null &&
                                  jogo.golosSofridos != null
                              ? jogo.emCasa
                                    ? '${jogo.golosMarcados} - ${jogo.golosSofridos}'
                                    : '${jogo.golosSofridos} - ${jogo.golosMarcados}'
                              : 'Sem resultado',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 25),
                // Apenas o treinador pode adicionar ou corrigir estatísticas
                if (!modoAtleta)
                  // Botão original
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelecionarJogoScreen(
                              jogoController: jogoController,
                              acontecimentoController: acontecimentoController,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Adicionar / Corrigir Estatísticas'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE50922),
                        foregroundColor: Colors.white,
                      ),
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
