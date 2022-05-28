import 'package:flutter/cupertino.dart' show BuildContext, ModalRoute;

//This is to get argument sent to any view. It is generic
extension GetArgument on BuildContext {
  //return value of any data type
  T? getArgument<T>() {
    final modalRoute = ModalRoute.of(this);
    if (modalRoute != null) {
      //get all arguments
      final args = modalRoute.settings.arguments;
      if (args != null && args is T) {
        //i.e is of data type T
        return args as T;
      }
    }
    return null;
  }
}
