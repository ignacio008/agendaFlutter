import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:esys_flutter_share/esys_flutter_share.dart';

class VistaImage extends StatefulWidget {
  final Future<Uint8List> saveImage;
  VistaImage(this.saveImage);

  @override
  State<VistaImage> createState() => _VistaImageState();
}

class _VistaImageState extends State<VistaImage> {
  List<String> imagePaths = [];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Dibujo Imagen"),
      content: FutureBuilder<Uint8List>(
        future: widget.saveImage,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(
              height: 50,
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox();
          }
          return InteractiveViewer(
              maxScale: 4, child: Image.memory(snapshot.data));
        },
      ),
       actions: <Widget>[
          FlatButton(
            child:
                const Text("Guardar PNG", style: (TextStyle(color: Colors.blue))),
            onPressed: () async{
              Navigator.pop(context);
              _savePNG();
              
            },
          ),
        
          FlatButton(
            child:
                const Text("Compartir", style: (TextStyle(color: Colors.black))),
            onPressed: () {
              Navigator.pop(context);
              _compartir();
            },
          ),
          
        ]
    );
  }

  void _savePNG() async{
    final bytes = await widget.saveImage;
    print(bytes);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/documento.png');
    await file.writeAsBytes(bytes);

    openFile(file);
  }
  static Future openFile(File file) async {
    print(file.path);
    final url = file.path;
    print('visto ' + url);
    await OpenFile.open(url);
  }
  

  void _compartir() async{
     final bytes = await widget.saveImage;
    print(bytes);
    // final dir = await getTemporaryDirectory();
    // final file = File('${dir.path}/documento.jpg');
    // await file.writeAsBytes(bytes);
    // final uno= file.path;
  final dibujo= Share.file("Dibujo", "Dibujo.png", bytes.buffer.asUint8List(), "dibujo/png");
   print(dibujo);
  }
}