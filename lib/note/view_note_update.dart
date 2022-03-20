import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:z08_agenda/firebase/query.dart';
import 'package:z08_agenda/home.dart';
import 'package:z08_agenda/model/model_note.dart';

class ViewNoteUpdate extends StatefulWidget {
   ModelNote iconModelList;
  ViewNoteUpdate(this.iconModelList);

  @override
  State<ViewNoteUpdate> createState() => _ViewNoteUpdateState();
}

class _ViewNoteUpdateState extends State<ViewNoteUpdate> {
  
  String errorHtml="Por favor escriba la nota";
  FToast fToast;
  String result = '';
  final HtmlEditorController controller = HtmlEditorController();
  TextEditingController _textEditingControllerTitulo = TextEditingController(); 
  TextEditingController _textEditingControllerDescription = TextEditingController();
   @override
  void initState() {
    // TODO: implement initState
     fToast = FToast();
    fToast.init(context);
     
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset : false,
      appBar:AppBar(
        title:const Text("Mi Nota"),
        bottomOpacity: 0.0,
        elevation: 0.0,
         backgroundColor: Colors.blue[700],
         actions: [
                  IconButton(
                      icon: const Icon(
                        Icons.share,
                      ),
                      onPressed: (){
                        _sharePdf(controller);
                      }
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.download_sharp,
                      ),
                      onPressed: (){
                        dowLoadPdf(controller);
                      }
                    ),
        ],
      ),

      body:SingleChildScrollView(
        child:Column(
          children:[
            HtmlEditor(
                    controller: controller,
                    hint: "Escribe aqui...",
                    initialText:widget.iconModelList.html,
                    options: const HtmlEditorOptions(
                      height: 320,
                    ),
                   toolbar: const [
                     
                    Style(),
                    Font(buttons: [FontButtons.bold, FontButtons.underline, FontButtons.italic]),
                     ColorBar(buttons:[  ColorButtons.backcolor, ColorButtons.forecolor]),            
                  Insert(buttons:[InsertButtons.hr,InsertButtons.table]),
                   FontSetting(),
],
                  ),
                  const SizedBox(height:30),
                  FlatButton(
               color:Colors.blue,
                 onPressed: () async {
                  // _sendHtml(controller,context);
                    showFormulario(controller,context);
                    controller.insertHtml(widget.iconModelList.html);
                  },
           padding: const EdgeInsets.only(left:20,top:17, right:20, bottom:17),
            child: const Text("Guardar", style:TextStyle(color:Colors.white)),            
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),    
            ),
            ),
          ],
        ),
      ),
    );
  }
  void showFormulario(HtmlEditorController controller, BuildContext context){
            showDialog(context: context, builder: (BuildContext context){
              return AlertDialog(
                  title: const Text("Por favor llene el siguiente formulario"),
                  content: Container(
                    height: 150,
                    color:Colors.white,
                    child: Column(
                      children: [
                           TextFormField(
                            controller: _textEditingControllerTitulo,
                                          decoration:  InputDecoration(
                                            prefixIcon: const Padding(
                                          padding: EdgeInsets.all(0.0),
                                          child: Icon(
                                            Icons.title,
                                            color: Colors.grey,
                                          ), // icon is 48px widget.
                                        ),
                                            labelText: widget.iconModelList.titleHtml),
                                            ),

                  const SizedBox(height:20),
                  TextFormField(
                            controller: _textEditingControllerDescription,
                                          decoration:  InputDecoration(
                                            prefixIcon: const Padding(
                                          padding: EdgeInsets.all(0.0),
                                          child: Icon(
                                            Icons.calendar_today_outlined,
                                            color: Colors.grey,
                                          ), // icon is 48px widget.
                                        ),
                                            labelText: widget.iconModelList.titleHtml),
                                            ),
                      ],
                    )),
                  actions: <Widget>[
            
                    FlatButton(
                      child: const Text("Cancelar", style: (TextStyle(color: Colors.blue))),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: const Text("Guardar"),
                      onPressed: (){
                           _actualizarHtml(controller,context);
                      },
                    ),
                  ],
              );
                    },
              barrierDismissible: false);
                            }

      
  void _actualizarHtml(HtmlEditorController controller, BuildContext context)async {

    FocusScope.of(context).requestFocus(FocusNode());
    String idNote="1";
    String notaCreada="Se ha creado tu nota";
    DateTime hoy= DateTime.now();
    String error="error";
  String titulo =_textEditingControllerTitulo.text.trim();
  String descripcion =_textEditingControllerDescription.text.trim();
    String erorTitulo="Por favor escriba un titulo de la nota";
    String erorDescritpcion="Por favor escriba una breve descripcion";


      final txt = await controller.getText();
                    setState(() {
                      result = txt;
                      print(txt);
                    });

      
 bool erroguardar=await QuerysService().actualizarInfoNote(reference: "note", id:idNote, collectionValues:ModelNote().toJsonBodyUpdate(
        idNote,
        txt.isEmpty?widget.iconModelList.html:txt,
        hoy,
        titulo.isEmpty?widget.iconModelList.titleHtml:titulo,
        descripcion.isEmpty?widget.iconModelList.descriptionHtml:descripcion,
        
        ),);
  if(erroguardar){
      showToasterror(error);
      }else{
           fToast.showToast(
           toastDuration: Duration(seconds: 3),
           gravity: ToastGravity.CENTER,
        child: customizedLeadingIconWidget,
          );
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>home1())); 
      }
  }
  void showToasterror(mensaje) {
    Fluttertoast.showToast(
        msg: mensaje,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 14.0,
    );
  }
  Widget customizedLeadingIconWidget = 
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        width: 400,
        height:230,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.teal[700],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.check_circle, // Set your own leading icon!
              color: Colors.white,
              size:140,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text("Nota guardada", style:TextStyle(color: Colors.white)),
          ],
        ),
      );

  
  void dowLoadPdf(HtmlEditorController controller) async{
      final txt = await controller.getText();
                        setState(() {
                          result = txt;
                          print(txt);
                        });
      if(txt.isEmpty){
        showToasterror(errorHtml);
        return;
      }
      final htmlContent = """
    <!DOCTYPE html>
    <html>
      <head>
        <style>
        table, th, td {
          border: 1px solid black;
          border-collapse: collapse;
        }
        th, td, p {
          padding: 5px;
          text-align: left;
        }
        </style>
      </head>
      <body>
      <br>
     """ +txt+
      """
      </body>
    </html>
    """;
    String generatedPdfFilePath;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final targetPath = appDocDir.path;
    final targetFileName = "example-pdf";
    final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(htmlContent, targetPath, targetFileName);
    generatedPdfFilePath = generatedPdfFile.path;
    final file=File('${generatedPdfFile.path}'); 
    openFile(file);
    print(htmlContent);
    print(file);

  }
  static Future openFile(File file) async {
    print(file.path);
    final url = file.path;
    print('visto ' + url);
    await OpenFile.open(url);
  }
   void _sharePdf(HtmlEditorController controller) async{
      final txt = await controller.getText();
                        setState(() {
                          result = txt;
                          print(txt);
                        });
      if(txt.isEmpty){
        showToasterror(errorHtml);
        return;
      }
      final htmlContent = """
    <!DOCTYPE html>
    <html>
      <head>
        <style>
        table, th, td {
          border: 1px solid black;
          border-collapse: collapse;
        }
        th, td, p {
          padding: 5px;
          text-align: left;
        }
        </style>
      </head>
      <body>
      <br>
     """ +txt+
      """
      </body>
    </html>
    """;
    String generatedPdfFilePath;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final targetPath = appDocDir.path;
    final targetFileName = "example-pdf";

    final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(htmlContent, targetPath, targetFileName);
    generatedPdfFilePath = generatedPdfFile.path;

     Uint8List uint8list = Uint8List.fromList(File(generatedPdfFile.path).readAsBytesSync());
  final nota= Share.file("Dibujo", "Nota.pdf", uint8list.buffer.asUint8List(), "nota/pdf");
   print(nota);
   print(uint8list);
  }
}