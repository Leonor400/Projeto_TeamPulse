import 'package:flutter/material.dart';

import '../models/acontecimento.dart';
import '../models/jogo.dart';
import '../controllers/acontecimento_controller.dart';
import '../data/atletas_iniciais.dart';

class AdicionarAcontecimentoScreen extends StatefulWidget {
  final Jogo jogo;
  final AcontecimentoController acontecimentoController;

  const AdicionarAcontecimentoScreen({
    super.key,
    required this.jogo,
    required this.acontecimentoController,
  });

  @override
  State<AdicionarAcontecimentoScreen> createState() =>
      _AdicionarAcontecimentoScreenState();
}

class _AdicionarAcontecimentoScreenState
    extends State<AdicionarAcontecimentoScreen> {
  final formKey = GlobalKey<FormState>();

  final minutoController = TextEditingController();
  final descricaoController = TextEditingController();

  String tipoSelecionado = 'Golo';
  String? atletaSelecionada;
  String? atletaEntraSelecionada;

  static const Color corCampo = Color(0xFF702126);
  static const Color corBotao = Color(0xFFE50922);

  final List<String> tipos = [
    'Golo',
    'Assistência',
    'Cartão amarelo',
    'Cartão vermelho',
    'Substituição',
  ];

  @override
  void dispose() {
    minutoController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  void mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensagem)));
  }

  void guardarAcontecimento() {
    if (!formKey.currentState!.validate()) return;

    final minuto = int.parse(minutoController.text.trim());

    if (widget.jogo.minutoFim != null && minuto > widget.jogo.minutoFim!) {
      mostrarErro('O minuto ultrapassa o fim do jogo.');
      return;
    }

    final acontecimento = Acontecimento(
      tipo: tipoSelecionado,
      minuto: minuto,
      atleta: atletaSelecionada!,
      descricao: descricaoController.text.trim(),
      atletaEntra: tipoSelecionado == 'Substituição'
          ? atletaEntraSelecionada
          : null,
      jogoId: widget.jogo.id,
    );

    widget.acontecimentoController.adicionarAcontecimento(acontecimento);

    Navigator.pop(context, true);
  }

  InputDecoration decoracao(String titulo, IconData icone) {
    return InputDecoration(
      labelText: titulo,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icone, color: Colors.white70),
      filled: true,
      fillColor: corCampo,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      errorStyle: const TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nomes =
        AtletasIniciais.atletas
            .map((atleta) => atleta.nome.trim())
            .where((nome) => nome.isNotEmpty)
            .toSet()
            .toList()
          ..sort();

    return Scaffold(
      backgroundColor: const Color(0xFF200607),
      appBar: AppBar(
        title: const Text('Adicionar Acontecimento'),
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
                    'Novo Acontecimento',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Jogo: CFB vs ${widget.jogo.adversario}',
                    style: const TextStyle(color: Colors.white70, fontSize: 15),
                  ),

                  const SizedBox(height: 25),

                  DropdownButtonFormField<String>(
                    initialValue: tipoSelecionado,
                    dropdownColor: corCampo,
                    isExpanded: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: decoracao(
                      'Tipo de acontecimento',
                      Icons.sports_soccer,
                    ),
                    items: tipos.map((tipo) {
                      return DropdownMenuItem(value: tipo, child: Text(tipo));
                    }).toList(),
                    onChanged: (valor) {
                      if (valor != null) {
                        setState(() {
                          tipoSelecionado = valor;
                          atletaSelecionada = null;
                          atletaEntraSelecionada = null;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    key: ValueKey('jogadora-$tipoSelecionado'),
                    initialValue: atletaSelecionada,
                    isExpanded: true,
                    dropdownColor: corCampo,
                    style: const TextStyle(color: Colors.white),
                    decoration: decoracao(
                      tipoSelecionado == 'Substituição'
                          ? 'Jogadora que sai'
                          : 'Jogadora',
                      Icons.person_outline,
                    ),
                    items: nomes.map((nome) {
                      return DropdownMenuItem(
                        value: nome,
                        child: Text(nome, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (valor) {
                      setState(() {
                        atletaSelecionada = valor;

                        if (atletaEntraSelecionada == valor) {
                          atletaEntraSelecionada = null;
                        }
                      });
                    },
                    validator: (valor) {
                      if (valor == null) {
                        return 'Seleciona uma jogadora.';
                      }
                      return null;
                    },
                  ),

                  if (tipoSelecionado == 'Substituição') ...[
                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      key: ValueKey('entra-$atletaSelecionada'),
                      initialValue: atletaEntraSelecionada,
                      isExpanded: true,
                      dropdownColor: corCampo,
                      style: const TextStyle(color: Colors.white),
                      decoration: decoracao(
                        'Jogadora que entra',
                        Icons.person_add_alt_1,
                      ),
                      items: nomes
                          .where((nome) => nome != atletaSelecionada)
                          .map((nome) {
                            return DropdownMenuItem(
                              value: nome,
                              child: Text(
                                nome,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          })
                          .toList(),
                      onChanged: (valor) {
                        setState(() {
                          atletaEntraSelecionada = valor;
                        });
                      },
                      validator: (valor) {
                        if (valor == null) {
                          return 'Seleciona quem entra.';
                        }
                        return null;
                      },
                    ),
                  ],

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: minutoController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: decoracao(
                      'Minuto do acontecimento',
                      Icons.timer_outlined,
                    ),
                    validator: (valor) {
                      final minuto = int.tryParse(valor?.trim() ?? '');

                      if (minuto == null || minuto < 0 || minuto > 130) {
                        return 'Introduz um minuto entre 0 e 130.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: descricaoController,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.white),
                    decoration: decoracao(
                      'Descrição (opcional)',
                      Icons.notes_outlined,
                    ),
                  ),

                  const SizedBox(height: 35),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: guardarAcontecimento,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Guardar Acontecimento'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: corBotao,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
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
}