import 'package:flutter/material.dart';
import 'package:z08_agenda/firebase/fetch_data.dart';
import 'package:z08_agenda/model/model_note.dart';
import 'package:z08_agenda/note/create_note.dart';
import 'package:z08_agenda/note/view_note.dart';

class MenuNote extends StatefulWidget {
  MenuNote({Key key}) : super(key: key);

  @override
  State<MenuNote> createState() => _MenuNoteState();
}

class _MenuNoteState extends State<MenuNote> {
  List<ModelNote> iconModelList=[];
  

 void getlista(String idusuario)async{
    iconModelList=await FetchData().getTopNoteMia(idusuario);
    print('Tengo ${iconModelList.length} cards');
    setState(() {
      
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    getlista("1");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:const Text("Nota"),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateNote(
      )));
                        },
                     padding: const EdgeInsets.only(left:20,top:17, right:20, bottom:17),
                      child: const Text("Crear Nota"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color:Colors.blue, width:2.0),
                      ),
                      ),

                      const SizedBox(height:20),
                 FlatButton(
                      onPressed: () async{
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewNote(iconModelList.isEmpty?const CircularProgressIndicator(): iconModelList[0]
     )));
                        },
                     padding: const EdgeInsets.only(left:27,top:17, right:27, bottom:17),
                      child: const Text("Ver Nota"),
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