import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/atleta.dart';

class AtletasRepositorio {
  // Endereço do servidor (emulador Android)
  static const String urlServidor = 'http://10.0.2.2:3000';

  // Obter atletas do servidor
  Future<List<Atleta>> listar() async {
    final resposta = await http.get(Uri.parse('$urlServidor/api/atletas'));
    final linhas = jsonDecode(resposta.body) as List;
    return linhas.map((linha) => Atleta.fromMap(linha)).toList();
  }
}
