import 'package:flutter/material.dart';

import '../controllers/equipa_controller.dart';
import '../controllers/jogo_controller.dart';
import '../controllers/acontecimento_controller.dart';

import 'equipa_screen.dart';
import 'calendario_screen.dart';
import 'estatistica_equipa_screen.dart';
import 'perfil_screen.dart';
import '../widgets/bottom_navegation.dart';

class TreinadorPrincipalScreen extends StatefulWidget {
  const TreinadorPrincipalScreen({super.key});

  @override
  State<TreinadorPrincipalScreen> createState() =>
      _TreinadorPrincipalScreenState();
}

class _TreinadorPrincipalScreenState extends State<TreinadorPrincipalScreen> {
  final Equipacontroller equipaController = Equipacontroller();
  final JogoController jogoController = JogoController();
  final AcontecimentoController acontecimentoController =
      AcontecimentoController();

  @override
  void initState() {
    super.initState();
    carregarAtletas();
  }

  // Carregar atletas do servidor
  Future<void> carregarAtletas() async {
    try {
      await equipaController.carregar();
    } catch (erro) {
      if (!mounted) return;
      mostrarMensagem('Não foi possível ligar ao servidor.');
    }
  }

  @override
  void dispose() {
    equipaController.dispose();
    jogoController.dispose();
    acontecimentoController.dispose();
    super.dispose();
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Widget cartaoEstatistica(String titulo, String valor, IconData icone) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF702126),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icone, color: Colors.white, size: 28),
            const SizedBox(height: 10),
            Text(
              valor,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget notificacao(String mensagem) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF702126),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        mensagem,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  int paginaSelecionada = 0;

  Widget construirPagina() {
    switch (paginaSelecionada) {
      case 1:
        return EquipasScreen(
          jogoController: jogoController,
          acontecimentoController: acontecimentoController,
          equipaController: equipaController,
        );
      case 2:
        return CalendarioScreen(
          jogoController: jogoController,
          acontecimentoController: acontecimentoController,
        );
      case 3:
        return EstatisticasEquipaScreen(
          jogoController: jogoController,
          acontecimentoController: acontecimentoController,
          equipacontroller: equipaController,
        );
      case 4:
        return PerfilScreen(
          jogoController: jogoController,
          acontecimentoController: acontecimentoController,
        );
      default:
        return construirInicio();
    }
  }

  Widget construirInicio() {
    return Scaffold(
      backgroundColor: const Color(0xFF200607),
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
                Center(
                  child: Image.asset(
                    'assets/imagens/logoBranco.png',
                    width: 230,
                    height: 70,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'Treinador',
                  style: TextStyle(color: Colors.white70, fontSize: 17),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Olá, Ruben',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                Row(
                  children: [
                    cartaoEstatistica(
                      'Atletas',
                      '${equipaController.atletas.length}',
                      Icons.groups_outlined,
                    ),
                    const SizedBox(width: 12),
                    cartaoEstatistica(
                      'Jogos',
                      '${jogoController.jogos.length}',
                      Icons.sports_soccer,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                const Text(
                  'Próximo Evento',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF702126),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Treino tático',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.white70,
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Terça-feira, 30 setembro',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      const Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.white70,
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Text(
                            '19:00 - Campo 1',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                mostrarMensagem('Detalhes em desenvolvimento');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD71932),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Ver detalhes'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                mostrarMensagem('Gerar QR em desenvolvimento');
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white),
                              ),
                              child: const Text('Gerar QR'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Notificações',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                notificacao('Leonor preencheu o formulário pré-treino'),
                notificacao('Ana registou a presença no treino'),
                notificacao('Caitana reportou uma lesão muscular'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF200607),
      body: construirPagina(),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: paginaSelecionada,
        onTap: (index) {
          setState(() {
            paginaSelecionada = index;
          });
        },
      ),
    );
  }
}
