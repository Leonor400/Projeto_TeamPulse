import 'package:flutter/material.dart';

import '../models/atleta.dart';
import 'login_screen.dart';

class PerfilAtletaScreen extends StatefulWidget {
  final Atleta atleta;

  const PerfilAtletaScreen({super.key, required this.atleta});

  @override
  State<PerfilAtletaScreen> createState() => _PerfilAtletaScreenState();
}

class _PerfilAtletaScreenState extends State<PerfilAtletaScreen> {
  bool notificacoes = true;

  static const Color corFundo = Color(0xFF200607);
  static const Color corCartao = Color(0xFF702126);
  static const Color corVermelha = Color(0xFFE50922);

  Widget linhaInformacao(IconData icone, String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icone, color: Colors.white70, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  valor,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cartao({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: corCartao,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  void terminarSessao() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(perfil: 'Atleta'),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final atleta = widget.atleta;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/imagens/logoBranco.png',
            width: 190,
            height: 65,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: 22),

          const Text(
            'Perfil',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // IDENTIFICAÇÃO
          cartao(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF40191C),
                  child: Icon(Icons.person, size: 45, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  atleta.nome,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'N.º ${atleta.numero} • ${atleta.posicao}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 10),
                Text(
                  atleta.disponivel ? '● Disponível' : '● Indisponível',
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

          const SizedBox(height: 25),

          const Text(
            'Informações da Atleta',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          cartao(
            child: Column(
              children: [
                linhaInformacao(
                  Icons.cake_outlined,
                  'Idade',
                  '${atleta.idade} anos',
                ),
                const Divider(color: Colors.white24),
                linhaInformacao(Icons.sports_soccer, 'Posição', atleta.posicao),
                const Divider(color: Colors.white24),
                linhaInformacao(
                  Icons.directions_run,
                  'Pé dominante',
                  atleta.peDominante,
                ),
                const Divider(color: Colors.white24),
                linhaInformacao(Icons.groups_outlined, 'Equipa', 'Sub-19 FF'),
              ],
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Definições',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          cartao(
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
              ),
              title: const Text(
                'Notificações',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Preferência de notificações',
                style: TextStyle(color: Colors.white70),
              ),
              value: notificacoes,
              activeThumbColor: corVermelha,
              onChanged: (valor) {
                setState(() {
                  notificacoes = valor;
                });
              },
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: terminarSessao,
              icon: const Icon(Icons.logout),
              label: const Text('Terminar Sessão'),
              style: ElevatedButton.styleFrom(
                backgroundColor: corVermelha,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
