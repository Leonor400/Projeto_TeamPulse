import 'package:flutter/material.dart';

import '../models/jogo.dart';
import '../controllers/jogo_controller.dart';
import '../controllers/acontecimento_controller.dart';
import 'adicionar_acontecimentos_screen.dart';
import 'adicionar_jogo_screen.dart';

class SelecionarJogoScreen extends StatefulWidget {
  final JogoController jogoController;
  final AcontecimentoController acontecimentoController;

  const SelecionarJogoScreen({
    super.key,
    required this.jogoController,
    required this.acontecimentoController,
  });

  @override
  State<SelecionarJogoScreen> createState() => _SelecionarJogoScreenState();
}

class _SelecionarJogoScreenState extends State<SelecionarJogoScreen> {
  // Abrir o formulário para adicionar um jogo
  Future<void> adicionarJogo() async {
    final guardado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AdicionarJogoScreen(jogoController: widget.jogoController),
      ),
    );

    if (!mounted) return;

    if (guardado == true) {
      setState(() {
        // Atualiza a lista de jogos no ecrã
      });
    }
  }

  // Abrir o formulário de acontecimentos
  Future<void> adicionarAcontecimento(Jogo jogo) async {
    final guardado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AdicionarAcontecimentoScreen(
          jogo: jogo,
          acontecimentoController: widget.acontecimentoController,
        ),
      ),
    );

    if (!mounted) return;

    if (guardado == true) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Jogo> jogos = widget.jogoController.jogos;

    return Scaffold(
      backgroundColor: const Color(0xFF200607),

      appBar: AppBar(
        title: const Text('Selecionar Jogo'),
        backgroundColor: const Color(0xFF800020),
        foregroundColor: Colors.white,
      ),

      // Botão para adicionar jogos
      floatingActionButton: FloatingActionButton.extended(
        onPressed: adicionarJogo,
        backgroundColor: const Color(0xFFE50922),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar Jogo'),
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

        child: jogos.isEmpty
            // Mensagem quando não existem jogos
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Ainda não existem jogos registados.\n'
                    'É necessário adicionar um jogo antes de '
                    'registar acontecimentos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              )
            // Lista de jogos registados
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: jogos.length,
                itemBuilder: (context, index) {
                  final jogo = jogos[index];

                  return Card(
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
                        '${jogo.data} | ${jogo.hora}',
                        style: const TextStyle(color: Colors.white70),
                      ),

                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),

                      onTap: () {
                        adicionarAcontecimento(jogo);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
