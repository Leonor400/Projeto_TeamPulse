import 'package:flutter/material.dart';

import 'atleta_equipa_screen.dart';
import '../controllers/jogo_controller.dart';
import '../controllers/acontecimento_controller.dart';
import 'calendario_screen.dart';
import '../data/atletas_iniciais.dart';
import 'estatisticas_atleta_screen.dart';
import 'perfil_atleta_screen.dart';
import '../widgets/bottom_navegation.dart';

class AtletaPrincipalScreen extends StatefulWidget {
  const AtletaPrincipalScreen({super.key});

  @override
  State<AtletaPrincipalScreen> createState() => _AtletaPrincipalScreenState();
}

class _AtletaPrincipalScreenState extends State<AtletaPrincipalScreen> {
  static const Color fundo = Color(0xFF200607);
  static const Color cartao = Color(0xFF702126);
  static const Color vermelho = Color(0xFFE50922);

  int paginaSelecionada = 0;
  final JogoController jogoController = JogoController();
  final AcontecimentoController acontecimentoController =
      AcontecimentoController();

  @override
  void dispose() {
    jogoController.dispose();
    acontecimentoController.dispose();
    super.dispose();
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Widget cartaoEstatistica(String valor, String descricao) {
    return Expanded(
      child: Container(
        height: 108,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: cartao,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              valor,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              descricao,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget cartaoNotificacao(IconData icone, String mensagem) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cartao,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icone, color: Colors.white, size: 23),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              mensagem,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
    );
  }

  Widget paginaInicio() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LOGÓTIPO E NOTIFICAÇÕES
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/imagens/logoBranco.png',
                width: 190,
                height: 70,
                fit: BoxFit.contain,
              ),
            ],
          ),

          const SizedBox(height: 30),

          // SAUDAÇÃO
          const Text(
            'Atleta',
            style: TextStyle(color: Colors.white70, fontSize: 17),
          ),
          const SizedBox(height: 5),
          const Text(
            'Olá, Atleta',
            style: TextStyle(
              color: Colors.white,
              fontSize: 29,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 25),

          // ESTATÍSTICAS
          Row(
            children: [
              cartaoEstatistica('—', 'Presenças'),
              const SizedBox(width: 10),
              cartaoEstatistica('0', 'Golos'),
              const SizedBox(width: 10),
              cartaoEstatistica('0', 'Jogos\nEsta época'),
            ],
          ),

          const SizedBox(height: 30),

          // PRÓXIMO EVENTO
          const Text(
            'Próximo Evento',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cartao,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Treino tático',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Em breve',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                const Text(
                  'Próximo treino',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                const Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.white70, size: 19),
                    SizedBox(width: 9),
                    Text(
                      '19:00 - Campo 1',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            paginaSelecionada = 2;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: vermelho,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Ver detalhes'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          mostrarMensagem(
                            'Leitura de QR Code em desenvolvimento',
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white70),
                        ),
                        child: const Text('Ler QR Code'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // NOTIFICAÇÕES
          const Text(
            'Notificações',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          cartaoNotificacao(
            Icons.assignment_outlined,
            'Preencher formulário pré-treino',
          ),

          cartaoNotificacao(
            Icons.notifications_outlined,
            'Consulta os avisos da tua equipa',
          ),
        ],
      ),
    );
  }

  // ECRÃ TEMPORÁRIO PARA AS PÁGINAS
  // QUE VAMOS DESENVOLVER A SEGUIR
  Widget paginaTemporaria(String titulo, IconData icone) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, color: Colors.white, size: 75),
            const SizedBox(height: 20),
            Text(
              titulo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Página em desenvolvimento',
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget construirPagina() {
    switch (paginaSelecionada) {
      case 0:
        return paginaInicio();

      case 1:
        return const AtletaEquipaScreen();

      case 2:
        return CalendarioScreen(
          jogoController: jogoController,
          acontecimentoController: acontecimentoController,
          modoAtleta: true,
        );

      case 3:
        return EstatisticasAtletaScreen(
          atleta: AtletasIniciais.atletas.first,
          jogoController: jogoController,
          acontecimentoController: acontecimentoController,
          modoAtleta: true,
        );

      case 4:
        return PerfilAtletaScreen(atleta: AtletasIniciais.atletas.first);

      default:
        return paginaInicio();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagens/FundoApp.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(child: construirPagina()),
      ),
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
