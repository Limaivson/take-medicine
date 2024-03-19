import 'dart:convert';
import 'package:http/http.dart' as http;

class MedicamentoService {
  static const String baseUrl = 'http://192.168.155.13:8000';

  // Método para buscar todos os medicamentos
  static Future<List<Medicamento>> getMedicamentos() async {
    final response = await http.get(Uri.parse('$baseUrl/medicamentos'));
    if (response.statusCode == 200) {
      Iterable listaMedicamentos = json.decode(response.body)['medicamentos'];
      return listaMedicamentos.map((e) => Medicamento.fromJson(e)).toList();
    } else {
      throw Exception('Falha ao carregar medicamentos');
    }
  }

  // Método para adicionar um novo medicamento
  static Future<void> adicionarMedicamento(Medicamento medicamento) async {
    final response = await http.post(
      Uri.parse('$baseUrl/medicamentos/adicionar/'),
      body: {
        'nome': medicamento.nome,
        'quantidade': medicamento.quantidade.toString(),
        'horario': medicamento.horario.toString(),
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Falha ao adicionar medicamento');
    }
  }

  // Método para remover um medicamento
  static Future<void> removerMedicamento(int medicamentoId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/medicamentos/remover/$medicamentoId/'),
    );
    if (response.statusCode != 200) {
      throw Exception('Falha ao remover medicamento');
    }
  }
  
  static Future<void> updateMeducamentoStatus(int medicamentoId, bool tomado) async {
    final response = await http.put(
      Uri.parse('$baseUrl/medicamentos/atualizar/$medicamentoId/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'tomado': tomado,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao atualizar o status do medicamento');
    }
  }
}

class Medicamento {
  final int id;
  final String nome;
  final int quantidade;
  final String horario;
  bool tomado;

  Medicamento({
    required this.id,
    required this.nome,
    required this.quantidade,
    required this.horario,
    required this.tomado,
  });

  factory Medicamento.fromJson(Map<String, dynamic> json) {
    return Medicamento(
      id: json['id'],
      nome: json['nome'],
      quantidade: json['quantidade'],
      horario: json['horario'],
      tomado: json['tomado'],
    );
  }

  
}
