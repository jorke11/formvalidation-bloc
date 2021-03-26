import 'dart:convert';
import 'dart:io';

import 'package:formvalidation_bloc/src/models/producto_model.dart';
import 'package:formvalidation_bloc/src/share_preferences/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class ProductoProvider {
  final String _url = "https://flutter-a70b4.firebaseio.com";
  final _prefs = new PreferenciasUsuario();

  Future<bool> crearProduct(ProductoModel producto) async {
    final url = '$_url/productos.json?auth=${_prefs.token}';

    final response = await http.post(url, body: productoModelToJson(producto));
    final decodeData = json.decode(response.body);
    return true;
  }

  Future<bool> editarProduct(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';

    final response = await http.put(url, body: productoModelToJson(producto));
    final decodeData = json.decode(response.body);
    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final url = '$_url/productos.json?auth=${_prefs.token}';

    final response = await http.get(url);
    final Map<String, dynamic> decodeData = json.decode(response.body);

    final List<ProductoModel> productos = new List();
    if (decodeData == null) return [];

    decodeData.forEach((id, producto) {
      final temp = ProductoModel.fromJson(producto);
      temp.id = id;
      productos.add(temp);
    });

    return productos;
  }

  Future<int> borrarProducto(String id) async {
    final url = '$_url/productos/$id.json?auth=${_prefs.token}';

    final resp = await http.delete(url);

    print(json.decode(resp.body));

    return 1;
  }

  Future<String> subirImage(File image) async {
    final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/dwydadyot/image/upload/?upload_preset=pr4f5m9f");
    final mimeType = mime(image.path).split("/");//image/jpeg

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url,
    );

    final file = await http.MultipartFile.fromPath("file", image.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if(resp.statusCode!=200 && resp.statusCode!=201){
      print("Algo salio mal");
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);

    print(respData);
    
    return respData["secure_url"];
  }
}
