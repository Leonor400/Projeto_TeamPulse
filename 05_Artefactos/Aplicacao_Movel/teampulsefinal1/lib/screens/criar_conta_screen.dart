import 'package:flutter/material.dart';

import 'login_screen.dart';

class CriarContaScreen extends StatefulWidget {
  const CriarContaScreen({super.key});

  @override
  State<CriarContaScreen> createState() => _CriarContaScreenState();
}

class _CriarContaScreenState extends State<CriarContaScreen> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmarPasswordController = TextEditingController();

  bool mostrarPassword = false;
  bool mostrarConfirmarPassword = false;
  bool aProcessar = false;

  String perfilSelecionado = 'Treinador';

  static const Color vermelho = Color(0xFFD71932);

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmarPasswordController.dispose();
    super.dispose();
  }

  void mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: const Color(0xFF702126),
      ),
    );
  }

  Future<void> criarConta() async {
    if (aProcessar) return;

    final nome = nomeController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmarPassword = confirmarPasswordController.text;

    if (nome.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmarPassword.isEmpty) {
      mostrarErro('Preencha todos os campos.');
      return;
    }

    final emailValido = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);

    if (!emailValido) {
      mostrarErro('Introduza um email válido.');
      return;
    }

    if (password.length < 8) {
      mostrarErro('A palavra-passe deve ter pelo menos 8 caracteres.');
      return;
    }

    if (password != confirmarPassword) {
      mostrarErro('As palavras-passe não coincidem.');
      return;
    }

    setState(() {
      aProcessar = true;
    });

    final continuar = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF54262A),
          title: const Text(
            'Formulário validado!',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Os dados de $nome foram validados.\n\n'
            'Perfil selecionado: $perfilSelecionado.\n\n'
            'Esta é uma demonstração. '
            'A conta ainda não foi guardada.\n\n'
            'Podes continuar para o login.',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Ir para o Login',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    setState(() {
      aProcessar = false;
    });

    if (continuar == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(perfil: perfilSelecionado),
        ),
      );
    }
  }

  InputDecoration decoracaoCampo({
    required String label,
    required IconData icone,
    Widget? sufixo,
  }) {
    return InputDecoration(
      labelText: label,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 10),

                Image.asset(
                  'assets/imagens/logoPrincipal.png',
                  height: 130,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 15),

                const Text(
                  'Junta-te à TeamPulse!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),

                const SizedBox(height: 30),

                TextField(
                  controller: nomeController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(color: Colors.white),
                  decoration: decoracaoCampo(
                    label: 'Nome completo',
                    icone: Icons.person_outlined,
                  ),
                ),

                const SizedBox(height: 18),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: decoracaoCampo(
                    label: 'Email',
                    icone: Icons.email_outlined,
                  ),
                ),

                const SizedBox(height: 18),

                TextField(
                  controller: passwordController,
                  obscureText: !mostrarPassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: decoracaoCampo(
                    label: 'Palavra-passe',
                    icone: Icons.lock_outlined,
                    sufixo: IconButton(
                      onPressed: () {
                        setState(() {
                          mostrarPassword = !mostrarPassword;
                        });
                      },
                      icon: Icon(
                        mostrarPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                TextField(
                  controller: confirmarPasswordController,
                  obscureText: !mostrarConfirmarPassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: decoracaoCampo(
                    label: 'Confirmar palavra-passe',
                    icone: Icons.lock_outlined,
                    sufixo: IconButton(
                      onPressed: () {
                        setState(() {
                          mostrarConfirmarPassword = !mostrarConfirmarPassword;
                        });
                      },
                      icon: Icon(
                        mostrarConfirmarPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Criar conta como:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  initialValue: perfilSelecionado,
                  dropdownColor: const Color(0xFF54262A),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Treinador',
                      child: Text('Treinador'),
                    ),
                    DropdownMenuItem(value: 'Atleta', child: Text('Atleta')),
                  ],
                  onChanged: (valor) {
                    if (valor != null) {
                      setState(() {
                        perfilSelecionado = valor;
                      });
                    }
                  },
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: aProcessar ? null : criarConta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vermelho,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    aProcessar ? 'A validar...' : 'Criar Conta',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Já tens conta? Inicia sessão',
                    style: TextStyle(color: Colors.white, fontSize: 15),
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