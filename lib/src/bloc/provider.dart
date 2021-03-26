import 'package:flutter/material.dart';
import 'package:formvalidation_bloc/src/bloc/login_block.dart';
import 'package:formvalidation_bloc/src/bloc/productos_bloc.dart';
export 'package:formvalidation_bloc/src/bloc/productos_bloc.dart';
export 'package:formvalidation_bloc/src/bloc/login_block.dart';

class Provider extends InheritedWidget {

  final loginBloc = LoginBloc();
  final _productosBloc = ProductosBloc();

  static Provider _instancia;

  factory Provider({Key key, Widget child}){
    if(_instancia==null){
      _instancia = new Provider._(key:key,child:child);
    }
    return _instancia;
  }



  Provider._({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider)
        .loginBloc;
  }
  
  static ProductosBloc productBloc(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider)
        ._productosBloc;
  }


}
