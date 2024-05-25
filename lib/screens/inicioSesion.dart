import 'dart:convert';
import 'package:consumoflutterarreglado/screens/menuScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formLogin = GlobalKey<FormState>();
  String nombreUsuario = '';
  String password = '';

  Future<void> acceder(String nombreUsuario, String password) async {
    final String apiUrl = 'https://bdgymflutter.onrender.com/cliente';
    
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['msg'] as List<dynamic>;
        for (var cliente in data) {
          if (cliente['documentoCliente'].toString() == nombreUsuario &&
              cliente['password'] == password) {
            final route = MaterialPageRoute(
              builder: (context) => const MenuScreen(),
            );
            Navigator.push(context, route);
            return;
          }
        }
      }
      _mostrarDialogoError();
    } catch (e) {
      _mostrarDialogoError();
    }
  }

  void _mostrarDialogoError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error de autenticación'),
          content: const Text('Nombre de usuario o contraseña incorrectos'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro GymSytem',
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255), fontSize: 30),
        ),
        backgroundColor: const Color.fromARGB(255, 39, 74, 105),
      ),
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Form(
            key: _formLogin,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Nombre de usuario",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor ingrese su usuario";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    nombreUsuario = value!;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Contraseña",
                  ),
                  validator: (value) {
                    if (value == null || value.length < 4) {
                      return "Por favor ingrese una contraseña válida";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value!;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formLogin.currentState!.validate()) {
                      _formLogin.currentState!.save();
                      acceder(nombreUsuario, password);
                    }
                  },
                  child: const Text(
                    'Acceder',
                    style: TextStyle(
                        color: Color.fromARGB(
                            255, 39, 74, 105) // Color blanco para el texto
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 39, 74, 105),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                // Acción para recuperar contraseña
              },
              child: const Text(
                'Recuperar contraseña',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
            const SizedBox(width: 20),
            TextButton(
              onPressed: () {
                // Acción para crear cuenta
              },
              child: const Text(
                'Crear cuenta',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
