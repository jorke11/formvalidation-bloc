import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._();
  SharedPreferences _prefs;

  PreferenciasUsuario._();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

   get token{
    return _prefs.getString("token")??'';
  }

  set token(String value){
    _prefs.setString("token", value);
  }
  
  get ultimaPagina{
    return _prefs.getString("ultimaPagina")??'home';
  }

  set ultimaPagina(String value){
    _prefs.setString("ultimaPagina", value);
  }
}
