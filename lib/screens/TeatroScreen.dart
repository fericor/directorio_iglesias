import 'package:flutter/material.dart';

class TeatroScreen extends StatefulWidget {
  const TeatroScreen({super.key});

  @override
  _TeatroScreenState createState() => _TeatroScreenState();
}

class _TeatroScreenState extends State<TeatroScreen> {
  // Estado de las sillas (true = seleccionada, false = libre)
  List<bool> sillas = List.generate(50, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Selecciona tu silla")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Escenario",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8, // Número de sillas por fila
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: sillas.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      sillas[index] = !sillas[index];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: sillas[index] ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        "S${index + 1}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
