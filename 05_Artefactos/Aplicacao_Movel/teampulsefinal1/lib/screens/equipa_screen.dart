import 'package:flutter/material.dart';

import '../models/atleta.dart';
import '../controllers/equipa_controller.dart';
import '../controllers/jogo_controller.dart';
import '../controllers/acontecimento_controller.dart';
import '../widgets/atleta_card.dart';

import 'adicionar_atleta_screen.dart';
import 'estatisticas_atleta_screen.dart';
import 'calendario_screen.dart';
import 'estatistica_equipa_screen.dart';
import 'perfil_screen.dart';

class EquipasScreen extends StatefulWidget {
  final Equipacontroller equipaController;
  final JogoController jogoController;
  final AcontecimentoController acontecimentoController;

  const EquipasScreen({
    super.key,
    required this.equipaController,
    required this.jogoController,
    required this.acontecimentoController,
  });

  @override
  State<EquipasScreen> createState() => _EquipasScreenState();
}

class _EquipasScreenState extends State<EquipasScreen> {
  String filtroSelecionado = 'Todos';
  bool mostrarPesquisa = false;
  String textoPesquisa = '';

  List<Atleta> get atletas => widget.equipaController.atletas;

  @override
  void initState() {
    super.initState();
    widget.equipaController.addListener(atualizarEcra);
  }

  void atualizarEcra() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.equipaController.removeListener(atualizarEcra);
    super.dispose();
  }

  Future<void> adicionarAtleta() async {
    final novaAtleta = await Navigator.push<Atleta>(
      context,
      MaterialPageRoute(builder: (context) => const AdicionarAtletaScreen()),
    );

    if (!mounted || novaAtleta == null) return;

    widget.equipaController.adicionarAtletas(novaAtleta);

    setState(() {
      filtroSelecionado = 'Todos';
      textoPesquisa = '';
      mostrarPesquisa = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Atleta adicionada com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final atletasFiltradas = atletas.where((atleta) {
      final correspondePesquisa = atleta.nome.toLowerCase().contains(
        textoPesquisa.trim().toLowerCase(),
      );

      final correspondeFiltro =
          filtroSelecionado == 'Todos' ||
          (filtroSelecionado == 'Disponíveis' && atleta.disponivel) ||
          (filtroSelecionado == 'Lesionadas' && !atleta.disponivel);

      return correspondePesquisa && correspondeFiltro;
    }).toList();

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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/imagens/logoBranco.png',
                      width: 200,
                      height: 70,
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              mostrarPesquisa = !mostrarPesquisa;
                              textoPesquisa = '';
                            });
                          },
                          icon: Icon(
                            mostrarPesquisa ? Icons.close : Icons.search,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: adicionarAtleta,
                          icon: const Icon(
                            Icons.add_circle,
                            color: Colors.red,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                if (mostrarPesquisa)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      onChanged: (valor) {
                        setState(() {
                          textoPesquisa = valor;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Pesquisar atleta...',
                        hintStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white70,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF702126),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 10),

                const Text(
                  'Equipa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '${atletas.length} Atletas Registadas',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),

                const SizedBox(height: 20),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _botaoFiltro('Todos', atletas.length),
                      _botaoFiltro(
                        'Disponíveis',
                        atletas.where((a) => a.disponivel).length,
                      ),
                      _botaoFiltro(
                        'Lesionadas',
                        atletas.where((a) => !a.disponivel).length,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: atletasFiltradas.isEmpty
                      ? const Center(
                          child: Text(
                            'Nenhuma atleta encontrada.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: atletasFiltradas.length,
                          itemBuilder: (context, index) {
                            final atleta = atletasFiltradas[index];

                            return AtletaCard(
                              atleta: atleta,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EstatisticasAtletaScreen(
                                          atleta: atleta,
                                          jogoController: widget.jogoController,
                                          acontecimentoController:
                                              widget.acontecimentoController,
                                        ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _botaoFiltro(String titulo, int quantidade) {
    final selecionado = filtroSelecionado == titulo;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text('$titulo ($quantidade)'),
        selected: selecionado,
        onSelected: (_) {
          setState(() {
            filtroSelecionado = titulo;
          });
        },
        selectedColor: const Color(0xFFE50922),
        backgroundColor: const Color(0xFF30090D),
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide.none,
        showCheckmark: false,
      ),
    );
  }
}