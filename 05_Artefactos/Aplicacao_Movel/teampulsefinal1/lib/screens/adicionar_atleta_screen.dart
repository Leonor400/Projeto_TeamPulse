import 'package:flutter/material.dart';

import '../models/atleta.dart';

class AdicionarAtletaScreen extends StatefulWidget {
  const AdicionarAtletaScreen({super.key});

  @override
  State<AdicionarAtletaScreen> createState() => _AdicionarAtletaScreenState();
}

class _AdicionarAtletaScreenState extends State<AdicionarAtletaScreen> {
  final formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final numeroController = TextEditingController();
  final idadeController = TextEditingController();

  String posicao = 'Defesa';
  String peDominante = 'Direito';
  bool disponivel = true;

  @override
  void dispose() {
    nomeController.dispose();
    numeroController.dispose();
    idadeController.dispose();
    super.dispose();
  }

  void guardarAtleta() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final novaAtleta = Atleta(
      nome: nomeController.text.trim(),
      numero: int.parse(numeroController.text.trim()),
      idade: int.parse(idadeController.text.trim()),
      posicao: posicao,
      peDominante: peDominante,
      disponivel: disponivel,
    );

    Navigator.pop(context, novaAtleta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF200607),
      appBar: AppBar(
        title: const Text('Adicionar Atleta'),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nova Atleta',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  TextFormField(
                    controller: nomeController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _decoracao(
                      'Nome completo',
                      Icons.person_outline,
                    ),
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return 'Introduz o nome da atleta';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: numeroController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: _decoracao('Número da camisola', Icons.numbers),
                    validator: (valor) {
                      final numero = int.tryParse(valor?.trim() ?? '');

                      if (numero == null || numero <= 0) {
                        return 'Introduz um número válido';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: idadeController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: _decoracao('Idade', Icons.cake_outlined),
                    validator: (valor) {
                      final idade = int.tryParse(valor?.trim() ?? '');

                      if (idade == null || idade <= 0 || idade > 120) {
                        return 'Introduz uma idade válida';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    initialValue: posicao,
                    dropdownColor: const Color(0xFF702126),
                    style: const TextStyle(color: Colors.white),
                    decoration: _decoracao('Posição', Icons.sports_soccer),
                    items: const [
                      DropdownMenuItem(
                        value: 'Guarda-redes',
                        child: Text('Guarda-redes'),
                      ),
                      DropdownMenuItem(value: 'Defesa', child: Text('Defesa')),
                      DropdownMenuItem(value: 'Médio', child: Text('Médio')),
                      DropdownMenuItem(
                        value: 'Avançada',
                        child: Text('Avançada'),
                      ),
                    ],
                    onChanged: (valor) {
                      if (valor != null) {
                        setState(() {
                          posicao = valor;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    initialValue: peDominante,
                    dropdownColor: const Color(0xFF702126),
                    style: const TextStyle(color: Colors.white),
                    decoration: _decoracao(
                      'Pé dominante',
                      Icons.directions_run,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Direito',
                        child: Text('Direito'),
                      ),
                      DropdownMenuItem(
                        value: 'Esquerdo',
                        child: Text('Esquerdo'),
                      ),
                      DropdownMenuItem(value: 'Ambos', child: Text('Ambos')),
                    ],
                    onChanged: (valor) {
                      if (valor != null) {
                        setState(() {
                          peDominante = valor;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  SwitchListTile(
                    title: const Text(
                      'Atleta disponível',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      disponivel ? 'Disponível' : 'Lesionada',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    value: disponivel,
                    activeThumbColor: const Color(0xFFE50922),
                    onChanged: (valor) {
                      setState(() {
                        disponivel = valor;
                      });
                    },
                  ),

                  const SizedBox(height: 35),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: guardarAtleta,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE50922),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Guardar Atleta',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoracao(String titulo, IconData icone) {
    return InputDecoration(
      labelText: titulo,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icone, color: Colors.white70),
      filled: true,
      fillColor: const Color(0xFF702126),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      errorStyle: const TextStyle(color: Colors.white),
    );
  }
}