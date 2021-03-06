import 'dart:io';

import 'package:formvalidation_bloc/src/models/producto_model.dart';
import 'package:formvalidation_bloc/src/providers/productos_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductosBloc {
  final _productosController = new BehaviorSubject<List<ProductoModel>>();
  final _cargandoController = new BehaviorSubject<bool>();

  final _productosProvider = new ProductoProvider();

  Stream<List<ProductoModel>> get productoStream => _productosController.stream;
  Stream<bool> get cargando => _cargandoController.stream;

  cargarProductos() async {
    final productos = await _productosProvider.cargarProductos();
    _productosController.sink.add(productos);
  }

  agregarProducto(ProductoModel producto) async {
    _cargandoController.sink.add(true);
    await _productosProvider.crearProduct(producto);
    _cargandoController.sink.add(false);
  }

  Future<String> subirFoto(File foto) async {
    _cargandoController.sink.add(true);
    final fotoUrl = await _productosProvider.subirImage(foto);
    _cargandoController.sink.add(false);
    return fotoUrl;
  }

  editarProducto(ProductoModel producto) async {
    _cargandoController.sink.add(true);
    await _productosProvider.editarProduct(producto);
    _cargandoController.sink.add(false);
  }

  borrarProducto(String id) async {
    await _productosProvider.borrarProducto(id);
  }

  dispose() {
    _productosController?.close();
    _cargandoController?.close();
  }
}
