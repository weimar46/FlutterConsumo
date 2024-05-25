import 'package:consumoflutterarreglado/screens/Productos.dart';
import 'package:consumoflutterarreglado/screens/RegistrarMembresia.dart';
import 'package:consumoflutterarreglado/screens/RegistrarProducto.dart';
import 'package:consumoflutterarreglado/screens/RegistrarServicio.dart';
import 'package:consumoflutterarreglado/screens/inicioSesion.dart';
import 'package:consumoflutterarreglado/screens/membresias.dart';
import 'package:consumoflutterarreglado/screens/servicios.dart';
import 'package:flutter/material.dart';


class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key});

  void cerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Cerrar Sesión?'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                ); // Navegar a la pantalla de inicio de sesión y eliminar las demás rutas del historial
              },
              child: const Text('Cerrar Sesión'),
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
        title: const Text(
          'Servicios',
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 50),
        ),
        backgroundColor: const Color.fromARGB(255, 212, 212, 212),
        actions: [
          IconButton(
            onPressed: () {
              cerrarSesion(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Menú Servicios'),
            leading: Icon(
              Icons.menu_book,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          ListTile(
            title: const Text('Crear Servicio'),
            leading: const Icon(
              Icons.arrow_right_outlined,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Registrar ()),
              );
            },
          ),
          ListTile(
            title: const Text('Crear Membresia'),
            leading: const Icon(
              Icons.arrow_right_outlined,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegistrarMembresias()),
              );
            },
          ),
          ListTile(
            title: const Text('Crear producto'),
            leading: const Icon(
              Icons.arrow_right_outlined,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegistrarProducto()),
              );
            },
          ),
          ListTile(
            title: const Text('Visualizar Servicios'),
            leading: const Icon(
              Icons.arrow_right_outlined,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ListarServicio()),
              );
            },
          ),
          ListTile(
            title: const Text('Visualizar Productos'),
            leading: const Icon(
              Icons.arrow_right_outlined,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ListarProductos()),
              );
            },
          ),
          ListTile(
            title: const Text('Visualizar Membresia'),
            leading: const Icon(
              Icons.arrow_right_outlined,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ListarMembresias()),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Color.fromARGB(255, 46, 47, 48),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Gym system empresa dedicada a prestar el mejor servicio',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
