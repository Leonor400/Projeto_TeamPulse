import 'package:flutter/material.dart';
import 'package:teampulsefinal1/data/atletas_iniciais.dart';
import 'package:teampulsefinal1/data/atletas_repositorio.dart';
import 'package:teampulsefinal1/models/atleta.dart';

class Equipacontroller extends ChangeNotifier {
  final AtletasRepositorio repo = AtletasRepositorio();
  final List<Atleta> _atletas = List.from(AtletasIniciais.atletas);
  List<Atleta> get atletas => List.unmodifiable(_atletas);

  // Carregar atletas da base de dados
  Future<void> carregar() async {
    final lista = await repo.listar();
    _atletas.clear();
    _atletas.addAll(lista);
    notifyListeners();
  }

  void adicionarAtletas(Atleta atleta) {
    _atletas.add(atleta);
    notifyListeners();
  }

  void removerAtleta(Atleta atleta) {
    _atletas.remove(atleta);
    notifyListeners();
  }
}
