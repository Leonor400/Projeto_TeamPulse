import 'package:flutter/material.dart';

import '../controllers/jogo_controller.dart';
import '../controllers/acontecimento_controller.dart';

import 'login_screen.dart';

class PerfilScreen extends StatefulWidget {
  final JogoController jogoController;
  final AcontecimentoController acontecimentoController;

  const PerfilScreen({
    super.key,
    required this.jogoController,
    required this.acontecimentoController,
  });

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  static const Color fundo = Color(0xFF200607);
  static const Color cartao = Color(0xFF702126);
  static const Color cartaoSecundario = Color(0xFF54262A);
  static const Color vermelho = Color(0xFFF20D35);

  bool notificacaoAtiva = true;
  bool lembreteAtivo = true;

  Future<void> confirmarTerminarSessao() async {
    final terminar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cartao,
          title: const Text(
            'Terminar sessão?',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Tens a certeza de que queres terminar a sessão?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Terminar sessão',
                style: TextStyle(color: vermelho),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted || terminar != true) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(perfil: 'treinador'),
      ),
      (route) => false,
    );
  }

  Widget tituloSecao(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        titulo,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget cartaoConta() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cartao,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: vermelho,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Text(
                  'RR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ruben Reboredo',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Treinador Principal',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Sub-19',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Desde agosto de 2024',
                style: TextStyle(fontSize: 11, color: Colors.white70),
              ),
              Text(
                'Época 26/27',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget cartaoEquipa() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      decoration: BoxDecoration(
        color: cartaoSecundario,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: vermelho, size: 26),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EQUIPA',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Sub-19 FF',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white70),
        ],
      ),
    );
  }

  Widget cartaoDados() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cartao,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EtiquetaDado(titulo: 'EMAIL', valor: 'ruben.RB@CFB.pt'),
          SizedBox(height: 17),
          EtiquetaDado(titulo: 'TELEFONE', valor: '+351 912 345 678'),
          SizedBox(height: 17),
          EtiquetaDado(titulo: 'LICENÇA', valor: 'UEFA B · 2849'),
        ],
      ),
    );
  }

  Widget cartaoPreferencias() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: cartao,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: vermelho,
            activeTrackColor: Colors.white,
            inactiveThumbColor: Colors.white70,
            inactiveTrackColor: Colors.white24,
            title: const Text(
              'Notificações',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              'Avisos da equipa e alterações',
              style: TextStyle(fontSize: 11, color: Colors.white70),
            ),
            value: notificacaoAtiva,
            onChanged: (valor) {
              setState(() {
                notificacaoAtiva = valor;
              });
            },
          ),
          const Divider(color: Colors.white24),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: vermelho,
            activeTrackColor: Colors.white,
            inactiveThumbColor: Colors.white70,
            inactiveTrackColor: Colors.white24,
            title: const Text(
              'Lembretes',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              'Alertas de treinos e jogos',
              style: TextStyle(fontSize: 11, color: Colors.white70),
            ),
            value: lembreteAtivo,
            onChanged: (valor) {
              setState(() {
                lembreteAtivo = valor;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget botaoTerminarSessao() {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton(
        onPressed: confirmarTerminarSessao,
        style: OutlinedButton.styleFrom(
          foregroundColor: vermelho,
          side: const BorderSide(color: vermelho),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Terminar Sessão',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CONTA PESSOAL',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Perfil',
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                cartaoConta(),
                const SizedBox(height: 12),
                cartaoEquipa(),
                const SizedBox(height: 24),

                tituloSecao('DADOS PESSOAIS'),
                cartaoDados(),
                const SizedBox(height: 24),

                tituloSecao('PREFERÊNCIAS'),
                cartaoPreferencias(),
                const SizedBox(height: 20),

                botaoTerminarSessao(),
                const SizedBox(height: 18),

                const Center(
                  child: Text(
                    'TeamPulse • versão 1.0',
                    style: TextStyle(color: Colors.white54, fontSize: 11),
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

class EtiquetaDado extends StatelessWidget {
  final String titulo;
  final String valor;

  const EtiquetaDado({super.key, required this.titulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
