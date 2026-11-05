import 'package:flutter/material.dart';

import 'criar_conta_screen.dart';
import 'treinador_principal_screen.dart';
import 'atleta_principal_screen.dart';
import 'Welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  final String perfil;

  const LoginScreen({super.key, required this.perfil});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool mostrarPassword = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Iniciar sessão
  void iniciarSessao() {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha o email e a palavra-passe.')),
      );
      return;
    }

    if (widget.perfil == 'Treinador') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TreinadorPrincipalScreen()),
      );
    } else if (widget.perfil == 'Atleta') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AtletaPrincipalScreen()),
      );
    }
  }

  // Voltar à página inicial
  void voltarInicio() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      (route) => false,
    );
  }

  // Mostrar ou esconder palavra-passe
  void alternarPassword() {
    setState(() {
      mostrarPassword = !mostrarPassword;
    });
  }

  // Decoração dos campos
  InputDecoration decoracaoCampo({
    required String titulo,
    required IconData icone,
    Widget? sufixo,
  }) {
    return InputDecoration(
      labelText: titulo,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icone, color: Colors.white70),
      suffixIcon: sufixo,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white, width: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logótipo
                    Image.asset(
                      'assets/imagens/logoPrincipal.png',
                      width: 230,
                      height: 180,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 15),

                    // Título
                    const Text(
                      'Bem-Vindo!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Inicie sessão para continuar como '
                      '${widget.perfil.toLowerCase()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Email
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: decoracaoCampo(
                        titulo: 'Email',
                        icone: Icons.email_outlined,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Palavra-passe
                    TextField(
                      controller: passwordController,
                      obscureText: !mostrarPassword,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: decoracaoCampo(
                        titulo: 'Palavra-passe',
                        icone: Icons.lock_outline,
                        sufixo: IconButton(
                          icon: Icon(
                            mostrarPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white70,
                          ),
                          onPressed: alternarPassword,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Recuperar palavra-passe
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Recuperação de palavra-passe '
                              'em desenvolvimento',
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Esqueceu-se da palavra-passe?',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),

                    // Criar conta
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CriarContaScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Ainda não tem conta? Criar Conta',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Botão Entrar
                    ElevatedButton(
                      onPressed: iniciarSessao,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD71932),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Entrar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Botão Voltar
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: voltarInicio,
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: const Text(
                          'Voltar',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}