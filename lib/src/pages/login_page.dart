import 'package:flutter/material.dart';
import 'package:formvalidation_bloc/src/bloc/provider.dart';
import 'package:formvalidation_bloc/src/providers/usuario_provider.dart';
import 'package:formvalidation_bloc/src/utils/utils.dart' as utils;

class LoginPage extends StatelessWidget {

  final usuarioProvider = new UsuarioProvider();
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      body: Stack(
        children: <Widget>[_crearFondo(context), _loginForm(context)],
      ),
    );
  }

  Widget _crearFondo(context) {
    final size = MediaQuery.of(context).size;

    final fondoMorado = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(63, 63, 156, 1),
        Color.fromRGBO(90, 70, 178, 1),
      ])),
    );

    final circulo = Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color.fromRGBO(255, 255, 255, .05)),
    );

    return Stack(children: <Widget>[
      fondoMorado,
      Positioned(
        child: circulo,
        top: 90,
        left: 30,
      ),
      Positioned(
        child: circulo,
        top: -40,
        left: -30,
      ),
      Positioned(
        child: circulo,
        bottom: -50,
        right: -10,
      ),
      Positioned(
        child: circulo,
        bottom: 120,
        right: 20,
      ),
      Positioned(
        child: circulo,
        bottom: -50,
        left: -20,
      ),
      Container(
        padding: EdgeInsets.only(top: 80),
        child: Column(
          children: <Widget>[
            Icon(
              Icons.person_pin_circle,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(
              height: 10,
              width: double.infinity,
            ),
            Text(
              "Jorge Pinedo",
              style: TextStyle(color: Colors.white, fontSize: 25),
            )
          ],
        ),
      )
    ]);
  }

  Widget _loginForm(context) {
    final bloc = Provider.of(context);

    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
              child: Container(
            height: 180,
          )),
          Container(
            width: size.width * .85,
            margin: EdgeInsets.symmetric(vertical: 30),
            padding: EdgeInsets.symmetric(vertical: 50),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3,
                      offset: Offset(0, 5),
                      spreadRadius: 3),
                ]),
            child: Column(
              children: <Widget>[
                Text(
                  "Ingreso",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 60,
                ),
                _crearEmail(bloc),
                SizedBox(
                  height: 20,
                ),
                _crearPassword(bloc),
                SizedBox(
                  height: 20,
                ),
                _crearBoton(context, bloc),
              ],
            ),
          ),
          FlatButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, "registro"),
              child: Text("Crear una nueva cuenta")),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.emailStream,
        builder: (context, AsyncSnapshot snap) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.alternate_email,
                    color: Colors.purple,
                  ),
                  hintText: "test@text.com",
                  labelText: "Email",
                  counterText: snap.data,
                  errorText: snap.error
                  ),
              onChanged: bloc.changeEmail,
            ),
          );
        });
  }

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.passwordStream,
        builder: (context, AsyncSnapshot snap) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.lock_outline,
                    color: Colors.purple,
                  ),
                  hintText: "********",
                  labelText: "Clave",
                  counterText: snap.data,
                  errorText: snap.error),
              onChanged: bloc.changePassword,
            ),
          );
        });
  }

  Widget _crearBoton(context, LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.formValidStream,
        builder: (context, AsyncSnapshot snap) {
          return RaisedButton(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text("Ingresar"),
            ),
            onPressed: snap.hasData ? () => _login(context, bloc) : null,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            elevation: 0,
            color: Colors.deepPurpleAccent,
            textColor: Colors.white,
          );
        });
  }

  _login(context, LoginBloc bloc) async{
    
    Map info = await usuarioProvider.login(bloc.email, bloc.password);

    if(info["ok"]){
      Navigator.pushReplacementNamed(context, "home");
    }else{
      utils.mostrarAlerta(context, info["mensaje"]);
      
    }

    
  }
}
