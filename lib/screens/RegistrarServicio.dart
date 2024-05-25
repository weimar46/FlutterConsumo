import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Http {
  static String url = "https://api100-z77q.onrender.com/servicios";
  static postUsuarios(Map usuario) async {
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
        print('Falla en la inserción');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

class Registrar extends StatefulWidget {
  const Registrar({super.key,});

  @override
  State<Registrar> createState() => _RegistrarState();
}

class _RegistrarState extends State<Registrar> {
  TextEditingController idServicio = TextEditingController();
  TextEditingController nombreServicio = TextEditingController();
  TextEditingController precioServicio = TextEditingController();
  TextEditingController frecuenciaServicio = TextEditingController();
  TextEditingController fechaInicio = TextEditingController();
  TextEditingController fechaFin = TextEditingController();
  TextEditingController observaciones = TextEditingController();

  Color idServicioBorderColor = Colors.grey;
  Color nombreServicioBorderColor = Colors.grey;
  Color precioServicioBorderColor = Colors.grey;
  Color frecuenciaServicioBorderColor = Colors.grey;
  Color fechaInicioBorderColor = Colors.grey;
  Color fechaFinBorderColor = Colors.grey;
  Color observacionesBorderColor = Colors.grey;

  bool onlyAlphabet(String value) {
    final RegExp regex = RegExp(r'^[a-zA-Z\s]+$');
    return regex.hasMatch(value);
  }

  bool onlyNumbers(String value) {
    final RegExp regex = RegExp(r'^[0-9]+$');
    return regex.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: idServicio,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'idServicio',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: idServicioBorderColor),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  idServicioBorderColor = value.isNotEmpty ? Colors.green : Colors.red;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nombreServicio,
              decoration: InputDecoration(
                hintText: 'nombreServicio',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: nombreServicioBorderColor),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  nombreServicioBorderColor = value.isNotEmpty ? Colors.green : Colors.red;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: precioServicio,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'precioServicio',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: precioServicioBorderColor),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  precioServicioBorderColor = value.isNotEmpty ? Colors.green : Colors.red;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: frecuenciaServicio,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'frecuenciaServicio',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: frecuenciaServicioBorderColor),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  frecuenciaServicioBorderColor = value.isNotEmpty ? Colors.green : Colors.red;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: fechaInicio,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                hintText: 'fechaInicio',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: fechaInicioBorderColor),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  fechaInicioBorderColor = value.isNotEmpty ? Colors.green : Colors.red;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: fechaFin,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                hintText: 'fechaFin',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: fechaFinBorderColor),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  fechaFinBorderColor = value.isNotEmpty ? Colors.green : Colors.red;
                });
              },
            ),
             const SizedBox(height: 20),
            TextField(
              controller: observaciones,
              decoration: InputDecoration(
                hintText: 'observaciones',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: observacionesBorderColor),
                ),
              ),
              onChanged: (value) {
                setState(() {
                 observacionesBorderColor = value.isNotEmpty ? Colors.green : Colors.red;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                if (idServicio.text.isNotEmpty &&
                    nombreServicio.text.isNotEmpty &&
                    precioServicio.text.isNotEmpty &&
                    frecuenciaServicio.text.isNotEmpty &&
                    fechaInicio.text.isNotEmpty &&
                    fechaFin.text.isNotEmpty &&
                     observaciones.text.isNotEmpty
                  ) {
                  var usuario = {
                    "idServicio": idServicio.text,
                    "nombreServicio": nombreServicio.text,
                    "precioServicio": precioServicio.text,
                    "frecuenciaServicio": frecuenciaServicio.text,
                    "fechaInicio": fechaInicio.text,
                    "fechaFin": fechaFin.text,
                      "observaciones": observaciones.text
                  };
                  print(usuario);
                  Http.postUsuarios(usuario);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error de validación'),
                        content: const Text('Por favor, asegúrate de llenar todos los campos y que la fecha de inicio sea anterior a la fecha de fin.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
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

void main() {
  runApp(const MaterialApp(
    home: Registrar(),
  ));
}
