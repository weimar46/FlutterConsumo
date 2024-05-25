import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Producto {
  final int idProducto;
  final String nombreProducto;
  final String foto;
  final int stock;
  final double precioEnPesos;
  final double precioEnDolares;

  Producto({
    required this.idProducto,
    required this.nombreProducto,
    required this.foto,
    required this.stock,
    required this.precioEnPesos,
    required this.precioEnDolares,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProducto: json['idProducto'],
      nombreProducto: json['nombreProducto'],
      foto: json['Foto'],
      stock: json['stock'],
      precioEnPesos: json['precioEnPesos'].toDouble(),
      precioEnDolares: json['precioEnDolares'].toDouble(),
    );
  }
}

Future<List<Producto>> fetchProductos() async {
  final response = await http.get(Uri.parse('https://api100-z77q.onrender.com/producto'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body) as Map<String, dynamic>;
    final List<dynamic> productoJson = jsonData['msg'];
    return productoJson.map((json) => Producto.fromJson(json)).toList();
  } else {
    throw Exception('Fallo la carga del servicio');
  }
}

Future<void> editarProducto(Producto producto) async {
  const String url = 'https://api100-z77q.onrender.com/producto';

  final Map<String, dynamic> datosActualizados = {
    'idProducto': producto.idProducto,
    'nombreProducto': producto.nombreProducto,
    'Foto': producto.foto,
    'stock': producto.stock,
    'precioEnPesos': producto.precioEnPesos,
    'precioEnDolares': producto.precioEnDolares,
  };

  print('Datos actualizados:');
  print(datosActualizados);

  final String cuerpoJson = jsonEncode(datosActualizados);

  try {
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: cuerpoJson,
    );

    if (response.statusCode == 200) {
      print('Producto editado con éxito');
    } else {
      print('Error al editar producto: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error al realizar la solicitud: $e');
  }
}

Future<void> eliminarProducto(int idProducto) async {
  try {
    final response = await http.delete(
      Uri.parse('https://api100-z77q.onrender.com/producto'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'idProducto': idProducto}),
    );

    if (response.statusCode == 200) {
      print('El producto con ID $idProducto se eliminó correctamente.');
    } else {
      throw Exception('Falló al eliminar: ${response.statusCode}');
    }
  } catch (error) {
    print('Error al eliminar producto: $error');
    throw error;
  }
}

class ListarProductos extends StatefulWidget {
  const ListarProductos({Key? key}) : super(key: key);

  @override
  State<ListarProductos> createState() => _ListarProductosState();
}

class _ListarProductosState extends State<ListarProductos> {
  void mostrarVentanaEdicion(BuildContext context, Producto producto) {
    TextEditingController idProductoController =
        TextEditingController(text: producto.idProducto.toString());
    TextEditingController nombreProductoController =
        TextEditingController(text: producto.nombreProducto);
    TextEditingController fotoController =
        TextEditingController(text: producto.foto);
    TextEditingController stockController =
        TextEditingController(text: producto.stock.toString());
    TextEditingController precioEnPesosController =
        TextEditingController(text: producto.precioEnPesos.toString());
    TextEditingController precioEnDolaresController =
        TextEditingController(text: producto.precioEnDolares.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Producto'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nombreProductoController,
                  decoration: const InputDecoration(labelText: 'Nombre Producto'),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: fotoController,
                  decoration: const InputDecoration(labelText: 'Foto'),
                  keyboardType: TextInputType.url,
                ),
                TextField(
                  controller: stockController,
                  decoration: const InputDecoration(labelText: 'Stock'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: precioEnPesosController,
                  decoration: const InputDecoration(labelText: 'Precio en Pesos'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: precioEnDolaresController,
                  enabled: false,
                  decoration: const InputDecoration(labelText: 'Precio en Dólares'),
                  keyboardType: TextInputType.number,
                ),
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
                if (nombreProductoController.text.isEmpty ||
                    fotoController.text.isEmpty ||
                    stockController.text.isEmpty ||
                    precioEnPesosController.text.isEmpty ||
                    precioEnDolaresController.text.isEmpty) {
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
                  // Crear la instancia de Producto con los valores convertidos
                  Producto productoActualizado = Producto(
                    idProducto: int.parse(idProductoController.text),
                    nombreProducto: nombreProductoController.text,
                    foto: fotoController.text,
                    stock: int.parse(stockController.text),
                    precioEnPesos: double.parse(precioEnPesosController.text),
                    precioEnDolares: double.parse(precioEnDolaresController.text),
                  );
                  editarProducto(productoActualizado);
                  Navigator.of(context).pop();
                  setState(() {});
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> mostrarDialogoEliminar(BuildContext context, int idProducto) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro que deseas eliminar este producto?'),
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
                eliminarProducto(idProducto);
                Navigator.of(context).pop();
                setState(() {});
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
        title: const Text('Productos'),
      ),
      body: FutureBuilder(
        future: fetchProductos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Producto> productos = snapshot.data as List<Producto>;
            return ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(productos[index].idProducto.toString()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nombre del Producto: ${productos[index].nombreProducto}'),
                      Text('Foto: ${productos[index].foto}'),
                      Text('Stock: ${productos[index].stock}'),
                      Text('Precio en Pesos: ${productos[index].precioEnPesos}'),
                      Text('Precio en Dólares: ${productos[index].precioEnDolares}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          mostrarVentanaEdicion(context, productos[index]);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          mostrarDialogoEliminar(context, productos[index].idProducto);
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
