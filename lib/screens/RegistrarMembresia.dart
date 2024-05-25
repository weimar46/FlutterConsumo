import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Http {
  static String url = "https://api100-z77q.onrender.com/membresia";
  static postUsarios(Map usuario) async {
    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {'content-Type': 'application/json'},
        body: json.encode(usuario),
      );
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        print(data);
      } else {
        print('falla en la insersion');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

class RegistrarMembresias extends StatefulWidget {
  const RegistrarMembresias({super.key});

  @override
  State<RegistrarMembresias> createState() => _RegistrarState();
}

TextEditingController idMembresia = TextEditingController();
TextEditingController nombreMembresia = TextEditingController();
TextEditingController precioMembresia = TextEditingController();
TextEditingController frecuenciaMembresia = TextEditingController();
TextEditingController fechaInicio = TextEditingController();
TextEditingController fechaFin = TextEditingController();
TextEditingController iva = TextEditingController();

class _RegistrarState extends State<RegistrarMembresias> {
  // Estados para controlar el color del borde de cada campo de texto
  Color idMembresiaBorderColor= Colors.grey;
  Color nombreMembresiaBorderColor = Colors.grey;
  Color precioMembresiaBorderColor = Colors.grey;
  Color frecuenciaMembresiaBorderColor = Colors.grey;
  Color fechaInicioBorderColor = Colors.grey;
  Color fechaFinBorderColor = Colors.grey;
  Color ivaBorderColor = Colors.grey;
 
  // Función de validación para permitir solo caracteres alfabéticos
  bool onlyAlphabet(String value) {
    final RegExp regex = RegExp(r'^[a-zA-Z\s]+$');
    return regex.hasMatch(value);
  }

  // Función de validación para permitir solo números
  bool onlyNumbers(String value) {
    final RegExp regex = RegExp(r'^[0-9]+$');
    return regex.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membresias'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: idMembresia,
              decoration: InputDecoration(
                hintText: 'idMembresia',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: idMembresiaBorderColor),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  idMembresiaBorderColor =
                      onlyNumbers(value) ? Colors.green : Colors.red;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nombreMembresia,
              decoration: InputDecoration(
                hintText: 'nombreMembresia',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: nombreMembresiaBorderColor),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  nombreMembresiaBorderColor =
                      onlyAlphabet(value) ? Colors.green : Colors.red;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: precioMembresia,
              decoration: InputDecoration(
                hintText: 'precioMembresia',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: precioMembresiaBorderColor),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  precioMembresiaBorderColor =
                      onlyNumbers(value) ? Colors.green : Colors.red;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: frecuenciaMembresia,
              decoration: InputDecoration(
                hintText: 'frecuenciaMembresia',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: frecuenciaMembresiaBorderColor),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  frecuenciaMembresiaBorderColor =
                      onlyNumbers(value) ? Colors.green : Colors.red;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: fechaInicio,
              decoration: InputDecoration(
                hintText: 'fechaInicio',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: fechaInicioBorderColor),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  fechaFinBorderColor =
                      onlyNumbers(value) ? Colors.green : Colors.red;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: fechaFin,
              decoration: InputDecoration(
                hintText: 'fechaFin',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: fechaFinBorderColor),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  fechaFinBorderColor =
                      onlyNumbers(value) ? Colors.green : Colors.red;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: iva,
              decoration: InputDecoration(
                hintText: 'iva',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ivaBorderColor),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  precioMembresiaBorderColor =
                      onlyNumbers(value) ? Colors.green : Colors.red;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                var usuario = {
                  "idMembresia": idMembresia.text,
                  "nombreMembresia": nombreMembresia.text,
                  "precioMembresia": precioMembresia.text,
                  "frecuenciaMembresia":frecuenciaMembresia.text,
                  "fechaInicio": fechaInicio.text,
                  "fechaFin":fechaFin.text,
                  "iva":iva.text,
                };
                print(usuario);
                Http.postUsarios(usuario);
              },
              icon: const Icon(Icons.maps_ugc_sharp),
              label: const Text('Registrar'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 68, 193, 255)),
            ),
          ],
        ),
      ),
    );
  }
}