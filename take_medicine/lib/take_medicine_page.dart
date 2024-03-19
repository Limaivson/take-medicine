// ignore_for_file: library_private_types_in_public_api
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:take_medicine/medicine_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Medicamentos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MedicationManager(),
    );
  }
}

class MedicationManager extends StatefulWidget {
  const MedicationManager({super.key});

  @override
  _MedicationManagerState createState() => _MedicationManagerState();
}

class _MedicationManagerState extends State<MedicationManager> {
  late int _selectedIndex; // Dia atual selecionado
  late String currentDay; // Dia atual selecionado
  final List<String> _daysOfWeek = [
    'Domingo',
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado'
  ];

  List<Medicamento> _medicamentos = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = DateTime.now().weekday;
    currentDay = _daysOfWeek[_selectedIndex];
    _carregarMedicamentos(); // Carregar medicamentos ao iniciar a tela
  }

  Future<void> _carregarMedicamentos() async {
    try {
      List<Medicamento> medicamentos = await MedicamentoService.getMedicamentos();
      setState(() {
        _medicamentos = medicamentos;
      });
    } catch (e) {
      print('Erro ao carregar medicamentos: $e');
      // Trate o erro de acordo com sua lógica
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciador de Medicamentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navegar para a tela de adicionar medicamento
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdicionarMedicamentoScreen()),
              ).then((value) {
                // Atualizar a lista de medicamentos após adicionar um novo medicamento
                if (value != null && value) {
                  _carregarMedicamentos();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 1,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = DateTime.now().weekday;
                      currentDay = _daysOfWeek[_selectedIndex];
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    color: 
                         Colors.blue,
                    child: Text(
                      currentDay,
                      style: TextStyle(
                        color: index == _selectedIndex
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: _medicamentos.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(), // Mostra um indicador de carregamento enquanto os medicamentos são carregados
                    )
                  : ListView.builder(
                      itemCount: _medicamentos.length,
                      itemBuilder: (context, index) {
                        Medicamento medicamento = _medicamentos[index];
                        return ListTile(
                          title: Text(medicamento.nome),
                          subtitle: Text('Quantidade: ${medicamento.quantidade}, Horário: ${medicamento.horario}'),
                          trailing: IconButton(
                            icon: Icon(medicamento.tomado ? Icons.check_circle : Icons.radio_button_unchecked),
                            onPressed: () async {
                              String tomou;
                              if (medicamento.tomado){
                                tomou = await popup(context, 'Deseja desmarcar o medicamento como tomado?');
                              }
                              else{
                                if (medicamento.quantidade>1){
                                  tomou = await popup(context, 'Lu realmente tomou os ${medicamento.quantidade} medicamentos?');
                                }
                                else{
                                  tomou = await popup(context, 'Lu realmente tomou o medicamento?');
                                }
                              }
                              // Marcar o medicamento como tomado
                              setState(() {
                                if (tomou == 'Sim'){
                                  medicamento.tomado = !medicamento.tomado;
                                  MedicamentoService.updateMeducamentoStatus(medicamento.id, medicamento.tomado);
                                }
                              });
                            },
                          ),
                          onTap: () {
                            // Exibir detalhes do medicamento
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DetalhesMedicamentoScreen(medicamento: medicamento)),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<String> popup(BuildContext context, String message) async {
  Completer<String> c = Completer();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Aviso'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              c.complete('Sim');
              Navigator.of(context).pop();
            },
            child: const Text('Sim'),
          ),
            TextButton(
              onPressed: () {
                c.complete('Não');
                Navigator.of(context).pop();
              },
              child: const Text('Não'),
          ),
        ],
      );
    },
  );
  return c.future;
}

class AdicionarMedicamentoScreen extends StatelessWidget {
  const AdicionarMedicamentoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Medicamento'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Adicione o código para adicionar medicamento aqui
            // Após adicionar o medicamento, você pode fechar esta tela e atualizar a lista de medicamentos na tela anterior
            Navigator.pop(context, true);
          },
          child: const Text('Adicionar Medicamento'),
        ),
      ),
    );
  }
}

class DetalhesMedicamentoScreen extends StatelessWidget {
  final Medicamento medicamento;

  const DetalhesMedicamentoScreen({super.key, required this.medicamento});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Medicamento'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nome: ${medicamento.nome}'),
            Text('Quantidade: ${medicamento.quantidade}'),
            Text('Horário: ${medicamento.horario}'),
            // Adicione mais detalhes do medicamento conforme necessário
          ],
        ),
      ),
    );
  }
}