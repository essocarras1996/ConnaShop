import 'package:cannonshop/Constantes/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class AppDesactive extends StatefulWidget {
  const AppDesactive({Key? key}) : super(key: key);

  @override
  State<AppDesactive> createState() => _AppDesactiveState();
}

class _AppDesactiveState extends State<AppDesactive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text('Aplicación desactivada por el desarrollador, por favor actualize a la última versión. Si actualizó debe contar con internet en su teléfono, cierre y abra la aplicación hasta que pueda acceder a la aplicación, para cualquier duda consulte nuestro grupo de ayuda en telegram.',
            style: TextStyle(fontFamily: 'Ubuntu',fontSize: 18, fontWeight: FontWeight.bold, color: colorDominante),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
