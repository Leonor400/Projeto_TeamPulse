import 'package:flutter/material.dart';

import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(flex: 1),

                Image.asset(
                  'assets/imagens/logoPrincipal.png',
                  width: 250,
                  height: 190,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 10),

                const Text(
                  'Gestão Desportiva\npara treinadores e atletas',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),

                const Spacer(flex: 2),

                const Text(
                  'Entrar como',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // Cartão Treinador
                _cartaoPerfil(
                  context,
                  'Treinador',
                  'Gerir equipas, treinos e atletas',
                  'assets/imagens/treinador.png',
                ),

                const SizedBox(height: 20),

                // Cartão Atleta
                _cartaoPerfil(
                  context,
                  'Atleta',
                  'Consultar treinos, presença e desempenho',
                  'assets/imagens/atleta.png',
                ),

                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cartaoPerfil(
    BuildContext context,
    String titulo,
    String descricao,
    String imagem,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen(perfil: titulo)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF702126).withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(imagem, width: 90, height: 90, fit: BoxFit.contain),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    descricao,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
