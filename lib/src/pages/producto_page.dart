import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation_bloc/src/bloc/provider.dart';
import 'package:formvalidation_bloc/src/models/producto_model.dart';
import 'package:formvalidation_bloc/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductosBloc productosBloc;

  ProductoModel product = new ProductoModel();
  bool _guardando = false;
  File photo;

  @override
  Widget build(BuildContext context) {

    productosBloc = Provider.productBloc(context);

    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;

    if (prodData != null) {
      product = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Producto"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera),
            onPressed: _tomarFoto,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  _mostrarFoto(),
                  _crearNombre(),
                  _crearPrecio(),
                  _crearDisponible(),
                  _crearBoton()
                ],
              )),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: product.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: "Producto"),
      onSaved: (value) => product.titulo = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
        initialValue: product.valor.toString(),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: "Precio"),
        onSaved: (value) => product.valor = double.parse(value),
        validator: (value) {
          if (utils.isNumeric(value)) {
            return null;
          } else {
            return 'Solo numeros';
          }
        });
  }

  Widget _crearDisponible() {
    return SwitchListTile(
        value: product.disponible,
        title: Text("Dispnible"),
        activeColor: Colors.deepPurple,
        onChanged: (value) {
          product.disponible = value;
          setState(() {});
        });
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.deepPurple,
        textColor: Colors.white,
        label: Text("Guardar"),
        icon: Icon(Icons.save),
        onPressed: (_guardando) ? null : _submit);
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() {
      _guardando = true;
    });

    if (photo != null) {
      product.fotoUrl = await productosBloc.subirFoto(photo);
    }

    if (product.id == null) {
      productosBloc.agregarProducto(product);
    } else {
      productosBloc.editarProducto(product);
    }
//  setState(() {
//       _guardando = false;
//     });

    mostrarSnackbar("Registro guardado");
    Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  _mostrarFoto() {
    if (product.fotoUrl != null) {
      return FadeInImage(
          placeholder: AssetImage("assets/loading.gif"),
          image: NetworkImage(product.fotoUrl),
          height: 300,
          fit:BoxFit.cover,
          );
    } else {
      return Image(
        image: photo != null
            ? FileImage(photo)
            : AssetImage('assets/no-image.png'),
        height: 300,
        fit: BoxFit.cover,
      );
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    photo = await ImagePicker.pickImage(source: origen);

    if (photo != null) {
      product.fotoUrl = null;
    }

    setState(() {});
  }
}
