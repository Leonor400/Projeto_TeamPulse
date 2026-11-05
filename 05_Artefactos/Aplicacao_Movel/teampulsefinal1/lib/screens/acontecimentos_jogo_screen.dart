import 'package:flutter/material.dart';

import '../models/jogo.dart';
import '../models/acontecimento.dart';
import '../controllers/acontecimento_controller.dart';
import 'adicionar_acontecimentos_screen.dart';

class AcontecimentosJogoScreen extends StatefulWidget {
  final Jogo jogo;
  final AcontecimentoController acontecimentoController;
  final bool modoAtleta;

  const AcontecimentosJogoScreen({
    super.key,
    required this.jogo,
    required this.acontecimentoController,
    this.modoAtleta = false,
  });

  @override
  State<AcontecimentosJogoScreen> createState() =>
      _AcontecimentosJogoScreenState();
}

class _AcontecimentosJogoScreenState extends State<AcontecimentosJogoScreen> {
  static const Color corCartao = Color(0xFF702126);
  static const Color corVermelha = Color(0xFFE50922);

  @override
  void initState() {
    super.initState();
    widget.acontecimentoController.addListener(atualizar);
  }

  @override
  void dispose() {
    widget.acontecimentoController.removeListener(atualizar);
    super.dispose();
  }

  void atualizar() {
    if (mounted) {
      setState(() {});
    }
  }

  List<Acontecimento> get acontecimentos {
    final lista = widget.acontecimentoController.acontecimentosDoJogo(
      widget.jogo.id,
    );

    lista.sort((a, b) => a.minuto.compareTo(b.minuto));

    return lista;
  }

  Future<void> adicionarAcontecimento() async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AdicionarAcontecimentoScreen(
          jogo: widget.jogo,
          acontecimentoController: widget.acontecimentoController,
        ),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  IconData iconeAcontecimento(String tipo) {
    switch (tipo) {
      case 'Golo':
        return Icons.sports_soccer;
      case 'Assistência':
        return Icons.handshake_outlined;
      case 'Cartão amarelo':
        return Icons.style_outlined;
      case 'Cartão vermelho':
        return Icons.style;
      case 'Substituição':
        return Icons.swap_horiz;
      default:
        return Icons.event_note;
    }
  }

  Widget construirAcontecimento(Acontecimento acontecimento) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: corCartao,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            iconeAcontecimento(acontecimento.tipo),
            color: Colors.white,
            size: 27,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  acontecimento.tipo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  acontecimento.tipo == 'Substituição'
                      ? '${acontecimento.atleta} sai\n'
                            '${acontecimento.atletaEntra ?? ""} entra'
                      : acontecimento.atleta,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                if (acontecimento.descricao.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    acontecimento.descricao,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
          Text(
            "${acontecimento.minuto}'",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lista = acontecimentos;

    return Scaffold(
      backgroundColor: const Color(0xFF200607),
      appBar: AppBar(
        title: const Text('Acontecimentos do Jogo'),
        backgroundColor: const Color(0xFF300B0E),
        foregroundColor: Colors.white,
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
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: corCartao,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.sports_soccer,
                      color: Colors.white,
                      size: 38,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'CFB vs ${widget.jogo.adversario}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.jogo.data,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Acontecimentos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              if (lista.isEmpty)
                Container(
                  padding: const EdgeInsets.all(35),
                  decoration: BoxDecoration(
                    color: corCartao,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.event_note, color: Colors.white70, size: 45),
                      SizedBox(height: 15),
                      Text(
                        'Ainda não existem acontecimentos registados.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                )
              else
                ...lista.map(construirAcontecimento),

              if (!widget.modoAtleta) ...[
                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: adicionarAcontecimento,
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar Acontecimento'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: corVermelha,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
