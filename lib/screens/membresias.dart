import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Membresia {
  final int idMembresia;
  final String nombreMembresia;
  final String precioMembresia;
  final String frecuenciaMembresia;
  final String fechaInicio;
  final String fechaFin;
  final String iva;

  Membresia({
    required this.idMembresia,
    required this.nombreMembresia,
    required this.precioMembresia,
    required this.frecuenciaMembresia,
    required this.fechaInicio,
    required this.fechaFin,
    required this.iva,
  });

  factory Membresia.fromJson(Map<String, dynamic> json) {
    return Membresia(
      idMembresia: json['idMembresia'],
      nombreMembresia: json['nombreMembresia'],
      precioMembresia: json['precioMembresia'],
      frecuenciaMembresia: json['frecuenciaMembresia'],
      fechaInicio: json['fechaInicio'],
      fechaFin: json['fechaFin'],
      iva: json['iva'],
    );
  }
}

Future<List<Membresia>> fetchPosts() async {
  final response = await http.get(Uri.parse('https://api100-z77q.onrender.com/membresia'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body) as Map<String, dynamic>;
    final List<dynamic> membresiaJson=jsonData ['msg'];
    return membresiaJson.map((json) => Membresia.fromJson(json)).toList();
  } else {
    throw Exception('Fallo la carga del servicio');
  }
}

class ListarMembresias extends StatefulWidget {
  const ListarMembresias({Key? key}) : super(key: key);

  @override
  State<ListarMembresias> createState() => _ListarServiciosState();
}

class _ListarServiciosState extends State<ListarMembresias> {
  Future<void> editarMembresia(Membresia membresia) async {
    const String url = 'https://api100-z77q.onrender.com/membresia';

    final Map<String, dynamic> datosActualizados = {
      'idMembresia': membresia.idMembresia,
      'nombreMembresia': membresia.nombreMembresia,
      'precioMembresia': membresia.precioMembresia,
      'frecuenciaMembresia': membresia.frecuenciaMembresia,
      'fechaInicio': membresia.fechaInicio,
      'fechaFin': membresia.fechaFin,
       'iva': membresia.iva,
    };

    print('datos actualizados');
    print(datosActualizados);

    final String cuerpoJson = jsonEncode(datosActualizados);

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: cuerpoJson,
      );

      if (response.statusCode == 200) {
        print('Membresia editado con éxito');
        setState(() {});
      } else {
        print('Error al editar membresia: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error al realizar la solicitud: $e');
    }
  }

  static Future<void> eliminarmembresia(
      int idMembresia, Function actualizarListamembresias) async {
    try {
      final response = await http.delete(
        Uri.parse('https://api100-z77q.onrender.com/membresia'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'idMembresia': idMembresia}));

      if (response.statusCode == 200) {
        actualizarListamembresias();
        print('El membresia con ID $idMembresia se eliminó correctamente.');
      } else {
        throw Exception('Falló al eliminar : ${response.statusCode}');
      }
    } catch (error) {
      print('Error al eliminar membresia: $error');
      throw error;
    }
  }

  void mostrarVentanaEdicion(BuildContext context, Membresia membresia) {
    TextEditingController idMembresiaController =
        TextEditingController(text: membresia.idMembresia.toString());
     

    TextEditingController nombremembresiaController =
        TextEditingController(text: membresia.nombreMembresia);

    TextEditingController precioMembresiaController =
        TextEditingController(text: membresia.precioMembresia);

    TextEditingController frecuenciaMembresiaController =
        TextEditingController(text: membresia.frecuenciaMembresia);

    TextEditingController fechaInicioController =
        TextEditingController(text: membresia.fechaInicio);

    TextEditingController fechaFinController =
        TextEditingController(text: membresia.fechaFin);
    TextEditingController ivaController =
        TextEditingController(text: membresia.iva);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar membresia'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nombremembresiaController,
                  decoration: const InputDecoration(labelText: 'Nombre membresia'),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: precioMembresiaController,
                  decoration: const InputDecoration(labelText: 'Precio membresia'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: frecuenciaMembresiaController,
                  decoration: const InputDecoration(labelText: 'Frecuencia del membresia'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: fechaInicioController,
                  decoration: const InputDecoration(labelText: 'Fecha Inicio'),
                ),
                TextField(
                  controller: fechaFinController,
                  decoration: const InputDecoration(labelText: 'Fecha fin'),
                ),
                TextField(
                  controller: ivaController,
                  decoration: const InputDecoration(labelText: 'iva'),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Validar que los campos no estén vacíos
                if (nombremembresiaController.text.isEmpty ||
                    precioMembresiaController.text.isEmpty ||
                    frecuenciaMembresiaController.text.isEmpty ||
                    fechaInicioController.text.isEmpty ||
                    fechaFinController.text.isEmpty ||
                    ivaController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Campos Vacíos'),
                        content: const Text('Por favor completa todos los campos.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Convertir los valores de texto a tipos numéricos
                  int idMembresia = int.parse(idMembresiaController.text);

                  // Crear la instancia de Exportacion con los valores convertidos
                  Membresia membresiaActualizado = Membresia(
                    idMembresia: idMembresia,
                    nombreMembresia: nombremembresiaController.text,
                    precioMembresia: precioMembresiaController.text,
                    frecuenciaMembresia: frecuenciaMembresiaController.text,
                    fechaInicio: fechaInicioController.text,
                    fechaFin: fechaFinController.text,
                    iva: ivaController.text
                  );
                  editarMembresia(membresiaActualizado);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> mostrarDialogoEliminar(BuildContext context, int idMembresia, Function actualizarLista) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro que deseas eliminar esta membresía?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                eliminarmembresia(idMembresia, actualizarLista);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membresias'),
      ),
      body: FutureBuilder(
        future: fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Membresia> membresias = snapshot.data as List<Membresia>;
            return ListView.builder(
              itemCount: membresias.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(membresias[index].idMembresia.toString()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('nombre del membresia: ${membresias[index].nombreMembresia}'),
                      Text('Precio: ${membresias[index].precioMembresia}'),
                      Text('Frecuencia: ${membresias[index].frecuenciaMembresia}'),
                      Text('Fecha de inicio: ${membresias[index].fechaInicio}'),
                      Text('Fecha de fin: ${membresias[index].fechaFin}'),
                      Text('iva: ${membresias[index].iva}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          mostrarVentanaEdicion(context, membresias[index]);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          mostrarDialogoEliminar(context, membresias[index].idMembresia, () {
                            setState(() {
                              membresias.removeAt(index);
                            });
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
