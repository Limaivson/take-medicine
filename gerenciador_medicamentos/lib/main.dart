// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

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
  final List<String> _daysOfWeek = [
    'Domingo',
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado'
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = DateTime.now().weekday;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciador de Medicamentos'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _daysOfWeek.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    color: index == _selectedIndex
                        ? Colors.blue
                        : Colors.transparent,
                    child: Text(
                      _daysOfWeek[index],
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
              child: ListView(
                children: _buildMedicationList(_selectedIndex),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMedicationList(int dayIndex) {
    // Aqui você pode obter a lista de medicamentos para o dia específico
    // e construir os widgets da lista com base nos medicamentos.
    // Por enquanto, vamos apenas retornar alguns widgets de marcadores de posição.

    return List.generate(
      5,
      (index) => ListTile(
        title: Text('Medicamento $index'),
        subtitle: Text('Quantidade: ${index + 1}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            // Adicione a lógica para remover o medicamento aqui.
          },
        ),
      ),
    );
  }
}
