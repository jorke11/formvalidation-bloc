import 'package:flutter/material.dart';
import 'package:formvalidation_bloc/src/bloc/provider.dart';
import 'package:formvalidation_bloc/src/models/producto_model.dart';
import 'package:formvalidation_bloc/src/providers/productos_provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productosBlock = Provider.productBloc(context);
    productosBlock.cargarProductos();

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: _crearListado(productosBlock),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado(ProductosBloc productosBloc) {
    return StreamBuilder(
        stream: productosBloc.productoStream,
        builder: (context, AsyncSnapshot<List<ProductoModel>> snapshot) {
          if (snapshot.hasData) {
            final productos = snapshot.data;
            return ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, i) => _crearItem(context, productos[i],productosBloc));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  _crearBoton(context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.pushNamed(context, "producto"));
  }

  Widget _crearItem(context, ProductoModel producto,ProductosBloc productosBloc) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direccion) {
          productosBloc.borrarProducto(producto.id);
        },
        child: Card(
          child: Column(
            children: <Widget>[
              (producto.fotoUrl == null)
                  ? Image(image: AssetImage("assets/no-image.png"))
                  : FadeInImage(
                      placeholder: AssetImage("assets/loading.gif"),
                      image: NetworkImage(producto.fotoUrl),
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              ListTile(
                title: Text('${producto.titulo}'),
                subtitle: Text('${producto.id}'),
                onTap: () => Navigator.pushNamed(context, "producto",
                    arguments: producto),
              ),
            ],
          ),
        ));
  }
}
