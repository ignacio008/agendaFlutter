import 'package:flutter/material.dart';
import 'package:z08_agenda/drawer/draw_d.dart';
import 'package:z08_agenda/note/menu_note.dart';

class home1 extends StatefulWidget {
  home1({Key key}) : super(key: key);

  @override
  State<home1> createState() => _home1State();
}

class _home1State extends State<home1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:const Text("Agenda"),
        bottomOpacity: 0.0,
        elevation: 0.0,
         backgroundColor: Colors.blue[700],
      ),
      body: SizedBox(
        width:MediaQuery.of(context).size.width,
        height:MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
             FlatButton(
                      onPressed: () async{
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>DrawD(
     )));
                        },
                     padding: const EdgeInsets.only(left:20,top:17, right:20, bottom:17),
                      child: const Text("Crear Dibujo"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color:Colors.blue, width:2.0),
                      ),
                      ),

                      const SizedBox(height:20),
                 FlatButton(
                      onPressed: () async{
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>MenuNote(
     )));
                        },
                     padding: const EdgeInsets.only(left:40,top:17, right:40, bottom:17),
                      child: const Text("Nota"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color:Colors.blue, width:2.0),
                      ),
                      ),
          ],
        ),
      ),
    );
  }
}