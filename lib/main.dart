import 'package:flutter/material.dart';
import 'package:formvalidation_bloc/src/bloc/provider.dart';
import 'package:formvalidation_bloc/src/pages/home_page.dart';
import 'package:formvalidation_bloc/src/pages/login_page.dart';
import 'package:formvalidation_bloc/src/pages/producto_page.dart';
import 'package:formvalidation_bloc/src/pages/register_page.dart';
import 'package:formvalidation_bloc/src/share_preferences/preferencias_usuario.dart';

void main() async {
  final prefs = new PreferenciasUsuario();
  WidgetsFlutterBinding.ensureInitialized();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final prefs = new PreferenciasUsuario(); 

    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: (prefs.token!=null)?'home':'login',
        routes: {
          'login': (context) => LoginPage(),
          'home': (context) => HomePage(),
          'producto': (context) => ProductoPage(),
          'registro': (context) => RegisterPage(),
        },
        theme: ThemeData(primaryColor: Colors.deepPurple),
      ),
    );
  }
}
