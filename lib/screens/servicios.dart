import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Servicio {
  final int idServicio;
  final String nombreServicio;
  final String precioServicio;
  final String frecuenciaServicio;
  final String fechaInicio;
  final String fechaFin;
  final String observaciones;

  Servicio({
    required this.idServicio,
    required this.nombreServicio,
    required this.precioServicio,
    required this.frecuenciaServicio,
    required this.fechaInicio,
    required this.fechaFin,
    required this.observaciones,
  });

  factory Servicio.fromJson(Map<String, dynamic> json) {
    return Servicio(
      idServicio: json['idServicio'],
      nombreServicio: json['nombreServicio'],
      precioServicio: json['precioServicio'],
      frecuenciaServicio: json['frecuenciaServicio'],
      fechaInicio: json['fechaInicio'],
      fechaFin: json['fechaFin'],
      observaciones: json['observaciones'],
    );
  }
}

Future<List<Servicio>> fetchPosts() async {
  final response = await http.get(Uri.parse('https://api100-z77q.onrender.com/servicios'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body) as Map<String, dynamic>;
    final List<dynamic> servicioJson=jsonData ['msg'];
    return servicioJson.map((json) => Servicio.fromJson(json)).toList();
  } else {
    throw Exception('Fallo la carga del servicio');
  }
}

class ListarServicio extends StatefulWidget {
  const ListarServicio({super.key});

  @override
  State<ListarServicio> createState() => _ListarServiciosState();
}

class _ListarServiciosState extends State<ListarServicio> {
  Future<void> editarMembresia(Servicio servicio) async {
    const String url = 'https://api100-z77q.onrender.com/servicios';

    final Map<String, dynamic> datosActualizados = {
      'idServicio': servicio.idServicio,
      'nombreServicio': servicio.nombreServicio,
      'precioServicio': servicio.precioServicio,
      'frecuenciaSericio': servicio.frecuenciaServicio,
      'fechaInicio': servicio.fechaInicio,
      'fechaFin': servicio.fechaFin,
       'observaciones': servicio.observaciones,
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
        print('Servicio editado con éxito');
        setState(() {});
      } else {
        print('Error al editar servicio: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error al realizar la solicitud: $e');
    }
  }

  static Future<void> eliminarServicio(
      int idServicio, Function actualizarListamembresias) async {
    try {
      final response = await http.delete(
        Uri.parse('https://api100-z77q.onrender.com/servicios'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'idServicio': idServicio}));

      if (response.statusCode == 200) {
        actualizarListamembresias();
        print('El servicio con ID $idServicio se eliminó correctamente.');
      } else {
        throw Exception('Falló al eliminar : ${response.statusCode}');
      }
    } catch (error) {
      print('Error al eliminar membresia: $error');
      throw error;
    }
  }

  void mostrarVentanaEdicion(BuildContext context, Servicio servicio) {
    TextEditingController idServicioController =
        TextEditingController(text: servicio.idServicio.toString());
     

    TextEditingController nombreServicioController =
        TextEditingController(text: servicio.nombreServicio);

    TextEditingController precioServicioController =
        TextEditingController(text: servicio.precioServicio);

    TextEditingController frecuenciaServicioController =
        TextEditingController(text: servicio.frecuenciaServicio);

    TextEditingController fechaInicioController =
        TextEditingController(text: servicio.fechaInicio);

    TextEditingController fechaFinController =
        TextEditingController(text: servicio.fechaFin);
    TextEditingController observacionesController =
        TextEditingController(text: servicio.observaciones);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar servicio'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nombreServicioController,
                  decoration: const InputDecoration(labelText: 'Nombre membresia'),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: precioServicioController,
                  decoration: const InputDecoration(labelText: 'Precio membresia'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: frecuenciaServicioController,
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
                  controller: observacionesController,
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
                if (nombreServicioController.text.isEmpty ||
                    precioServicioController.text.isEmpty ||
                    frecuenciaServicioController.text.isEmpty ||
                    fechaInicioController.text.isEmpty ||
                    fechaFinController.text.isEmpty ||
                    observacionesController.text.isEmpty) {
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
                  int idServicio = int.parse(idServicioController.text);

                  // Crear la instancia de Exportacion con los valores convertidos
                  Servicio servicioActtualizado = Servicio(
                    idServicio: idServicio,
                    nombreServicio: nombreServicioController.text,
                    precioServicio: precioServicioController.text,
                    frecuenciaServicio: frecuenciaServicioController.text,
                    fechaInicio: fechaInicioController.text,
                    fechaFin: fechaFinController.text,
                    observaciones: observacionesController.text
                  );
                  editarMembresia(servicioActtualizado);
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
                Text('¿Estás seguro que deseas eliminar esta servicio?'),
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
                eliminarServicio(idMembresia, actualizarLista);
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
        title: const Text('Servicio'),
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
            List<Servicio> servicio = snapshot.data as List<Servicio>;
            return ListView.builder(
              itemCount: servicio.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(servicio[index].idServicio.toString()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('nombre del membresia: ${servicio[index].nombreServicio}'),
                      Text('Precio: ${servicio[index].precioServicio}'),
                      Text('Frecuencia: ${servicio[index].frecuenciaServicio}'),
                      Text('Fecha de inicio: ${servicio[index].fechaInicio}'),
                      Text('Fecha de fin: ${servicio[index].fechaFin}'),
                      Text('iva: ${servicio[index].observaciones}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          mostrarVentanaEdicion(context, servicio[index]);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          mostrarDialogoEliminar(context, servicio[index].idServicio, () {
                            setState(() {
                              servicio.removeAt(index);
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
