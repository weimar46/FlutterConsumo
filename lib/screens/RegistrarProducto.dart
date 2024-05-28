import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Http {
  static String url = "https://api100-z77q.onrender.com/producto";

  static postProducto(Map producto) async {
    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {'content-Type': 'application/json'},
        body: json.encode(producto),
      );
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        print(data);
      } else {
        print('Fallo en la inserción');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

class RegistrarProducto extends StatefulWidget {
  const RegistrarProducto({Key? key}) : super(key: key);

  @override
  State<RegistrarProducto> createState() => _RegistrarProductoState();
}

class _RegistrarProductoState extends State<RegistrarProducto> {
  TextEditingController idProducto = TextEditingController();
  TextEditingController nombreProducto = TextEditingController();
  TextEditingController foto = TextEditingController();
  TextEditingController stock = TextEditingController();
  TextEditingController precioEnPesos = TextEditingController();
  TextEditingController precioEnDolares = TextEditingController();

  Color idProductoBorderColor = Colors.grey;
  Color nombreProductoBorderColor = Colors.grey;
  Color fotoBorderColor = Colors.grey;
  Color stockBorderColor = Colors.grey;
  Color precioEnPesosBorderColor = Colors.grey;
  Color precioEnDolaresBorderColor = Colors.grey;

  bool onlyNumbers(String value) {
    final RegExp regex = RegExp(r'^[0-9]+$');
    return regex.hasMatch(value);
  }

  @override
  void initState() {
    super.initState();
    // Llamada a la API para obtener el precio actual del dólar
    obtenerPrecioDolar().then((dolar) {
      setState(() {
        precioEnDolares.text = dolar.toString();
      });
    }).catchError((error) {
      print('Error obteniendo el precio del dólar: $error');
    });
  }

  Future<double> obtenerPrecioDolar() async {
    try {
      final response = await http.get(Uri.parse("https://www.datos.gov.co/resource/mcec-87by.json"));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Suponiendo que el precio del dólar esté en la primera entrada del JSON
        return double.parse(data[0]['valor']);
      } else {
        throw Exception('Error al cargar los datos');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Producto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: idProducto,
              decoration: InputDecoration(
                hintText: 'ID Producto',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: idProductoBorderColor),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  idProductoBorderColor =
                      onlyNumbers(value) ? Colors.green : Colors.red;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nombreProducto,
              decoration: InputDecoration(
                hintText: 'Nombre Producto',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: nombreProductoBorderColor),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: foto,
              decoration: InputDecoration(
                hintText: 'URL de la Foto',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: fotoBorderColor),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: stock,
              decoration: InputDecoration(
                hintText: 'Stock',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: stockBorderColor),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  stockBorderColor =
                      onlyNumbers(value) ? Colors.green : Colors.red;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: precioEnPesos,
              decoration: InputDecoration(
                hintText: 'Precio en Pesos',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: precioEnPesosBorderColor),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  precioEnPesosBorderColor =
                      onlyNumbers(value) ? Colors.green : Colors.red;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: precioEnDolares,
              enabled: false,
              decoration: InputDecoration(
                hintText: 'Precio en Dólares',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: precioEnDolaresBorderColor),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Confirmar Registro"),
                      content: Text("¿Está seguro de que desea registrar este producto?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancelar"),
                        ),
                        TextButton(
                          onPressed: () {
                            var producto = {
                              "idProducto": idProducto.text,
                              "nombreProducto": nombreProducto.text,
                              "Foto": foto.text,
                              "stock": stock.text,
                              "precioEnPesos": precioEnPesos.text,
                              "precioEnDolares": precioEnDolares.text,
                            };
                            print(producto);
                            Http.postProducto(producto);
                            Navigator.of(context).pop();
                          },
                          child: Text("Registrar"),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Registrar Producto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 68, 193, 255),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: RegistrarProducto(),
  ));
}
