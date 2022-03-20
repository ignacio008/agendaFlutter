import 'package:flutter/material.dart';
import 'package:z08_agenda/model/model_note.dart';
import 'package:z08_agenda/note/view_note_update.dart';

class ViewNote extends StatefulWidget {
  ModelNote iconModelList;
  ViewNote(this.iconModelList);

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
   double _widthe=280;
  double _height=400;
 

 
  double zoomIn() {  
      if(_widthe==280){
        setState(() {
          _widthe=340;
          _height=650;
         
        });
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ViewNoteUpdate(widget.iconModelList
       )));
      }else{
        setState(() {
         _widthe=280;
         _height=500;
        });
        
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:const Text("Ver Nota"),
        bottomOpacity: 0.0,
        elevation: 0.0,
         backgroundColor: Colors.blue[700],
      ),
      body:SizedBox(
        width:MediaQuery.of(context).size.width,
        height:MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            
            Row(
              children: [
                  SizedBox(width:30),
                  Text("${widget.iconModelList.titleHtml}",style:const TextStyle(fontSize:40, color:Colors.blue, fontWeight:FontWeight.bold)),
              ],
            ),
             const SizedBox(height:30),
            GestureDetector(
               onTap: (){
                zoomIn();
                print(widget.iconModelList.titleHtml);
              },
              child: AnimatedContainer(
                duration:const Duration(milliseconds:400),
                width:_widthe,
                padding: const EdgeInsets.all(15),
                        height:_height,
                        decoration: BoxDecoration(
                          color:Colors.blue[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                  child: Text("${widget.iconModelList.descriptionHtml}"),
              ),
            ),
        ]),
      ),
    );
  }
}