import 'package:flutter/material.dart';

import '../models/jogo.dart';
import '../controllers/jogo_controller.dart';

class AdicionarJogoScreen extends StatefulWidget {
  final JogoController jogoController;

  const AdicionarJogoScreen({super.key, required this.jogoController});

  @override
  State<AdicionarJogoScreen> createState() => _AdicionarJogoScreenState();
}

class _AdicionarJogoScreenState extends State<AdicionarJogoScreen> {
  final _formKey = GlobalKey<FormState>();

  final adversarioController = TextEditingController();
  final dataController = TextEditingController();
  final horaController = TextEditingController();
  final localController = TextEditingController();

  bool emCasa = true;

  @override
  void dispose() {
    adversarioController.dispose();
    dataController.dispose();
    horaController.dispose();
    localController.dispose();
    super.dispose();
  }

  Future<void> escolherData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (data != null) {
      dataController.text =
          '${data.day.toString().padLeft(2, '0')}/'
          '${data.month.toString().padLeft(2, '0')}/'
          '${data.year}';
    }
  }

  Future<void> escolherHora() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (hora != null) {
      horaController.text =
          '${hora.hour.toString().padLeft(2, '0')}:'
          '${hora.minute.toString().padLeft(2, '0')}';
    }
  }

  void guardarJogo() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final jogo = Jogo(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      adversario: adversarioController.text.trim(),
      data: dataController.text.trim(),
      hora: horaController.text.trim(),
      local: localController.text.trim(),
      emCasa: emCasa,
      golosMarcados: null,
      golosSofridos: null,
    );

    widget.jogoController.adicionarJogo(jogo);

    Navigator.pop(context, true);
  }

  InputDecoration decoracaoCampo(String titulo) {
    return InputDecoration(
      labelText: titulo,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xFF702126),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF200607),
      appBar: AppBar(
        title: const Text('Adicionar Jogo'),
        backgroundColor: const Color(0xFF800020),
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
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dados do Jogo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  TextFormField(
                    controller: adversarioController,
                    style: const TextStyle(color: Colors.white),
                    decoration: decoracaoCampo('Adversário'),
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return 'Indica o adversário';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: dataController,
                    readOnly: true,
                    onTap: escolherData,
                    style: const TextStyle(color: Colors.white),
                    decoration: decoracaoCampo('Data').copyWith(
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                    ),
                    validator: (valor) {
                      if (valor == null || valor.isEmpty) {
                        return 'Seleciona uma data';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: horaController,
                    readOnly: true,
                    onTap: escolherHora,
                    style: const TextStyle(color: Colors.white),
                    decoration: decoracaoCampo('Hora').copyWith(
                      suffixIcon: const Icon(
                        Icons.access_time,
                        color: Colors.white,
                      ),
                    ),
                    validator: (valor) {
                      if (valor == null || valor.isEmpty) {
                        return 'Seleciona uma hora';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: localController,
                    style: const TextStyle(color: Colors.white),
                    decoration: decoracaoCampo('Local'),
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return 'Indica o local';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 25),

                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF702126),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SwitchListTile(
                      title: const Text(
                        'Jogo em casa',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        emCasa ? 'Casa' : 'Fora',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      value: emCasa,
                      activeThumbColor: const Color(0xFFE50922),
                      onChanged: (valor) {
                        setState(() {
                          emCasa = valor;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 35),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: guardarJogo,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Guardar Jogo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE50922),
                        foregroundColor: Colors.white,
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
}