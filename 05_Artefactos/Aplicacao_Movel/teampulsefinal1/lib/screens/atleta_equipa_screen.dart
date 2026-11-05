import 'package:flutter/material.dart';

import '../models/atleta.dart';
import '../controllers/equipa_controller.dart';

class AtletaEquipaScreen extends StatefulWidget {
  const AtletaEquipaScreen({super.key});

  @override
  State<AtletaEquipaScreen> createState() => _AtletaEquipaScreenState();
}

class _AtletaEquipaScreenState extends State<AtletaEquipaScreen> {
  final Equipacontroller equipaController = Equipacontroller();

  String filtroSelecionado = 'Todos';
  String textoPesquisa = '';

  @override
  void dispose() {
    equipaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Atleta> atletas = equipaController.atletas;

    final atletasFiltradas = atletas.where((atleta) {
      final correspondePesquisa = atleta.nome.toLowerCase().contains(
        textoPesquisa.toLowerCase(),
      );

      final correspondeFiltro =
          filtroSelecionado == 'Todos' ||
          (filtroSelecionado == 'Disponíveis' && atleta.disponivel) ||
          (filtroSelecionado == 'Lesionadas' && !atleta.disponivel);

      return correspondePesquisa && correspondeFiltro;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
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

              TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (valor) {
                  setState(() {
                    textoPesquisa = valor;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Pesquisar colega...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF702126),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    botaoFiltro('Todos', atletas.length),
                    botaoFiltro(
                      'Disponíveis',
                      atletas.where((a) => a.disponivel).length,
                    ),
                    botaoFiltro(
                      'Lesionadas',
                      atletas.where((a) => !a.disponivel).length,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Expanded(
          child: atletasFiltradas.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhuma atleta encontrada.',
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: atletasFiltradas.length,
                  itemBuilder: (context, index) {
                    final atleta = atletasFiltradas[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF702126),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFF200607),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${atleta.numero}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  atleta.nome,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  atleta.posicao,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.circle,
                            size: 11,
                            color: atleta.disponivel
                                ? Colors.greenAccent
                                : Colors.redAccent,
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget botaoFiltro(String titulo, int quantidade) {
    final selecionado = filtroSelecionado == titulo;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text('$titulo ($quantidade)'),
        selected: selecionado,
        onSelected: (_) {
          setState(() {
            filtroSelecionado = titulo;
          });
        },
        selectedColor: const Color(0xFFE50922),
        backgroundColor: const Color(0xFF301416),
        labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
        side: BorderSide.none,
        showCheckmark: false,
      ),
    );
  }
}