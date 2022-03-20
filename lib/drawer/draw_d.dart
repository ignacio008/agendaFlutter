import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:ui' as ui;

import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:z08_agenda/drawer/select_sticker_d.dart';
import 'package:z08_agenda/drawer/vista_dibujo.dart';
import 'package:z08_agenda/firebase/fetch_data.dart';
import 'package:z08_agenda/model/model_sticker.dart';


class DrawD extends StatefulWidget {
  DrawD({Key key}) : super(key: key);

  @override
  State<DrawD> createState() => _DrawDState();
}

class _DrawDState extends State<DrawD> {
  List<ModelSticker>iconmodellistSticker=[];
  File _imagen;
  static const Color red = Color(0xFFFF0000);
  FocusNode textFocusNode = FocusNode();
   PainterController controller;
  ui.Image backgroundImage;
  Paint shapePaint = Paint()
    ..strokeWidth = 5
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  
  void getTopSticker()async{
    iconmodellistSticker = await FetchData().getTopSticker();
    var tamano= iconmodellistSticker.length;
    print("EL TAMAÑO DE LA LISTA ES: ${tamano}");   
  }
  
  @override
  void initState() {
    super.initState();
    getTopSticker();
    controller = PainterController(
        settings: PainterSettings(
            text: TextSettings(
              focusNode: textFocusNode,
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold, color: red, fontSize: 18),
            ),
            freeStyle: const FreeStyleSettings(
              color: red,
              strokeWidth: 5,
            ),
            shape: ShapeSettings(
              paint: shapePaint,
            ),
            scale: const ScaleSettings(
              enabled: true,
              minScale: 1,
              maxScale: 5,
            )));
    
    textFocusNode.addListener(onFocus);
   
  }
   void fondoImagen() async {  
    final image = 
    await FileImage(_imagen).image;
    setState(() {
      backgroundImage = image;
      controller.background = image.backgroundDrawable;
    });
  }

  /// Updates UI when the focus changes
  void onFocus() {
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: ValueListenableBuilder<PainterControllerValue>(
              valueListenable: controller,
              child: const Text("Dibujo"),
              builder: (context, _, child) {
                return AppBar(
                  title: child,
                  actions: [
                    IconButton(
                      icon: const Icon(
                        PhosphorIcons.trash,
                      ),
                      onPressed: controller.selectedObjectDrawable == null
                          ? null
                          : removeSelectedDrawable,
                    ),
                    IconButton(
                      icon: const Icon(
                        PhosphorIcons.arrowClockwise,
                      ),
                      onPressed: controller.canRedo ? redo : null,
                    ),
                    IconButton(
                      icon: const Icon(
                        PhosphorIcons.arrowCounterClockwise,
                      ),
                      onPressed: controller.canUndo ? undo : null,
                    ),
                  ],
              bottomOpacity: 0.0,
              elevation: 0.0,
              backgroundColor: Colors.blue[700],
                );
              }),
          
        ),
      body:SizedBox(
          width:MediaQuery.of(context).size.width,
          height:MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           GestureDetector(
                                      onTap:(){
                                        print("subiendo imagen${_imagen}");
                                        _imagen!=null?Container():
                                         mostrarOpciones(context);
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width*0.88,
                                        height:MediaQuery.of(context).size.height*0.7,
                                        child: subirImagen(),
                                         decoration: BoxDecoration(
                                          color: Colors.grey[800],
                                          borderRadius:BorderRadius.circular(10),
                                         
                                        ),
                                        
                                      ),
                                    ),

                              const SizedBox(height:20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                      ],
                                    ),

                                     

        ],),
        ),
       floatingActionButton: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        FloatingActionButton.extended(
          onPressed: () {
            //changeColor(Colors.red);
            saveImg();
          },
          icon: Icon(Icons.save),
          label: Text('Guardar'),
          backgroundColor: Colors.red,
        ),
      ]),

        
        bottomNavigationBar:  ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, _, __) => Container(
            padding: EdgeInsets.all(10),
            color:Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    PhosphorIcons.eraser,
                    color: controller.freeStyleMode == FreeStyleMode.erase
                        ? Theme.of(context).accentColor
                        : Colors.white,
                  ),
                  onPressed: toggleFreeStyleErase,
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: controller.freeStyleMode == FreeStyleMode.draw
                        ? Theme.of(context).accentColor
                        : Colors.white,
                  ),
                  onPressed: toggleFreeStyleDraw,
                ),
                // Add text
                IconButton(
                  icon: Icon(
                    PhosphorIcons.textT,
                    color: textFocusNode.hasFocus
                        ? Theme.of(context).accentColor
                        : Colors.white,
                  ),
                  onPressed: addText,
                ),
                IconButton(
                  icon: const Icon(
                    PhosphorIcons.sticker,
                    color:Colors.white
                  ),
                  onPressed: addStickers,
                ),
                if (controller.shapeFactory == null)
                  PopupMenuButton<ShapeFactory>(
                    tooltip: "Add shape",
                    itemBuilder: (context) => <ShapeFactory, String>{
                      LineFactory(): "Linea",
                      ArrowFactory(): "Flecha",
                      DoubleArrowFactory(): "Doble Flecha",
                      RectangleFactory(): "Rectangulo",
                      OvalFactory(): "Circulo",
                    }
                        .entries
                        .map((e) => PopupMenuItem(
                            value: e.key,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  getShapeIcon(e.key),
                                  color: Colors.black,
                                ),
                                Text(" ${e.value}")
                              ],
                            )))
                        .toList(),
                    onSelected: selectShape,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        getShapeIcon(controller.shapeFactory),
                        color: controller.shapeFactory != null
                            ? Theme.of(context).accentColor
                            : Colors.white,
                      ),
                    ),
                  )
                else
                  IconButton(
                    icon: Icon(
                      getShapeIcon(controller.shapeFactory),
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () => selectShape(null),
                  ),
              ],
            ),
          ),
        ));
    
    
  }


  
  void mostrarOpciones(BuildContext context){
      showDialog(context: context, builder: (context) {
        return SimpleDialog(
          children: <Widget>[
            ListTile(
              title: const Text("Camara"),
              leading: Icon(Icons.camera_alt),
              onTap: (){
                 Navigator.pop(context);
                  getImage(ImageSource.camera);
              },
            ),
            ListTile(
              title: const Text("Gallery"),
              leading: const Icon(Icons.image),
              onTap: (){
                Navigator.pop(context);
                  getImage(ImageSource.gallery);
              },
            ),

          ],
        );
      });
    }
    void getImage(ImageSource tipp_Imagen) async{
       final picker = ImagePicker();  
      var imageses = await picker.getImage(source: tipp_Imagen);
        setState(() {
          _imagen=File(imageses.path);
        });
        fondoImagen();
  }



















  
   Widget subirImagen() {
     if(_imagen==null){
        return Column(
         mainAxisAlignment: MainAxisAlignment.center,
          children:const [
             Text("Seleccione un fondo",style:TextStyle(color:Colors.white, fontSize:20) ),
             Icon(Icons.camera_alt, size:130, color:Colors.white),
          ],
        );
      }else{
        return Stack(
        children: [
          if (backgroundImage != null)
            Positioned.fill(
              child: Center(
                child: AspectRatio(
                  aspectRatio:
                      backgroundImage.width / backgroundImage.height,
                  child: FlutterPainter(
                    controller: controller,
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, _, __) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 400,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                        color: Colors.black,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (controller.freeStyleMode !=
                              FreeStyleMode.none) ...[
                            const Divider(),
                            const Text("Trazo estilos",style:TextStyle(color:Colors.white)),
                            
                            Row(
                              children: [
                                const Expanded(
                                    flex: 1, child: Text("Tamaño de plumon",style:TextStyle(color:Colors.white))),
                                Expanded(
                                  flex: 3,
                                  child: Slider.adaptive(
                                      min: 2,
                                      max: 25,
                                      value: controller.freeStyleStrokeWidth,
                                      onChanged: setFreeStyleStrokeWidth),
                                ),
                              ],
                            ),
                            if (controller.freeStyleMode ==
                                FreeStyleMode.draw)
                              Row(
                                children: [
                                  const Expanded(
                                      flex: 1, child: Text("Color",style:TextStyle(color:Colors.white))),
                                 
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(
                                        min: 0,
                                        max: 359.99,
                                        value: HSVColor.fromColor(
                                                controller.freeStyleColor)
                                            .hue,
                                        activeColor:
                                            controller.freeStyleColor,
                                        onChanged: setFreeStyleColor),
                                  ),
                                ],
                              ),
                          ],
                          if (textFocusNode.hasFocus) ...[
                            const Divider(),
                            const Text("Editor de text",style:TextStyle(color:Colors.white)),
                           
                            Row(
                              children: [
                                const Expanded(
                                    flex: 1, child: Text("Tamaño letras",style:TextStyle(color:Colors.white))),
                                Expanded(
                                  flex: 3,
                                  child: Slider.adaptive(
                                      min: 8,
                                      max: 96,
                                      value:
                                          controller.textStyle.fontSize ?? 14,
                                      onChanged: setTextFontSize),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(flex: 1, child: Text("Color",style:TextStyle(color:Colors.white))),
                                Expanded(
                                  flex: 3,
                                  child: Slider.adaptive(
                                      min: 0,
                                      max: 359.99,
                                      value: HSVColor.fromColor(
                                              controller.textStyle.color ??
                                                  red)
                                          .hue,
                                      activeColor: controller.textStyle.color,
                                      onChanged: setTextColor),
                                ),
                              ],
                            ),
                          ],
                          if (controller.shapeFactory != null) ...[
                            const Divider(),
                            const Text("Shape Settings"),
                            Row(
                              children: [
                                const Expanded(
                                    flex: 1, child: Text("Tamaño de plumon",style:TextStyle(color:Colors.white))),
                                Expanded(
                                  flex: 3,
                                  child: Slider.adaptive(
                                      min: 2,
                                      max: 25,
                                      value: controller
                                              .shapePaint?.strokeWidth ??
                                          shapePaint.strokeWidth,
                                      onChanged: (value) =>
                                          setShapeFactoryPaint(
                                              (controller.shapePaint ??
                                                      shapePaint)
                                                  .copyWith(
                                            strokeWidth: value,
                                          ))),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(flex: 1, child: Text("Color",style:TextStyle(color:Colors.white))),
                                Expanded(
                                  flex: 3,
                                  child: Slider.adaptive(
                                      min: 0,
                                      max: 359.99,
                                      value: HSVColor.fromColor(
                                              (controller.shapePaint ??
                                                      shapePaint)
                                                  .color)
                                          .hue,
                                      activeColor: (controller.shapePaint ??
                                              shapePaint)
                                          .color,
                                      onChanged: (hue) =>
                                          setShapeFactoryPaint(
                                              (controller.shapePaint ??
                                                      shapePaint)
                                                  .copyWith(
                                            color: HSVColor.fromAHSV(
                                                    1, hue, 1, 1)
                                                .toColor(),
                                          ))),
                                ),
                              ],
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        );
      }
  }
  















  void setFreeStyleStrokeWidth(double value) {
    controller.freeStyleStrokeWidth = value;
  }
  void setFreeStyleColor(double hue) {
    controller.freeStyleColor = HSVColor.fromAHSV(1, hue, 1, 1).toColor();
  }
  void setTextFontSize(double size) {
    // Set state is just to update the current UI, the [FlutterPainter] UI updates without it
    setState(() {
      controller.textSettings = controller.textSettings.copyWith(
          textStyle:
              controller.textSettings.textStyle.copyWith(fontSize: size));
    });
  }
   void setTextColor(double hue) {
    controller.textStyle = controller.textStyle
        .copyWith(color: HSVColor.fromAHSV(1, hue, 1, 1).toColor());
  }
  void setShapeFactoryPaint(Paint paint) {
    // Set state is just to update the current UI, the [FlutterPainter] UI updates without it
    setState(() {
      controller.shapePaint = paint;
    });
  }





  void toggleFreeStyleErase() {
    controller.freeStyleMode = controller.freeStyleMode != FreeStyleMode.erase
        ? FreeStyleMode.erase
        : FreeStyleMode.none;
  }
  void toggleFreeStyleDraw() {
    controller.freeStyleMode = controller.freeStyleMode != FreeStyleMode.draw
        ? FreeStyleMode.draw
        : FreeStyleMode.none;
  }
  void addText() {
    if (controller.freeStyleMode != FreeStyleMode.none) {
      controller.freeStyleMode = FreeStyleMode.none;
    }
    controller.addText();
  }

  void addStickers()async{
    showDialog<String>(
        context: context,
        builder: (context) =>  SelectStickerD(
            iconmodellistSticker ,context, controller
            ));
    
  }





  static IconData getShapeIcon(ShapeFactory shapeFactory) {
    if (shapeFactory is LineFactory) return PhosphorIcons.lineSegment;
    if (shapeFactory is ArrowFactory) return PhosphorIcons.arrowUpRight;
    if (shapeFactory is DoubleArrowFactory) {
      return PhosphorIcons.arrowsHorizontal;
    }
    if (shapeFactory is RectangleFactory) return PhosphorIcons.rectangle;
    if (shapeFactory is OvalFactory) return PhosphorIcons.circle;
    return PhosphorIcons.polygon;
  }


   void selectShape(ShapeFactory factory) {
    controller.shapeFactory = factory;
  }


  void removeSelectedDrawable() {
    final selectedDrawable = controller.selectedObjectDrawable;
    if (selectedDrawable != null) controller.removeDrawable(selectedDrawable);
  }
  void flipSelectedImageDrawable() {
    final imageDrawable = controller.selectedObjectDrawable;
    if (imageDrawable is! ImageDrawable) return;
     
  }
  void undo() {
    controller.undo();
  }

  void redo() {
    controller.redo();
  }

  void saveImg() {
     if (backgroundImage == null) return;
    final backgroundImageSize = Size(
        backgroundImage.width.toDouble(), backgroundImage.height.toDouble());

    final saveImage = controller
        .renderImage(backgroundImageSize)
        .then<Uint8List>((ui.Image image) => image.pngBytes);

      showDialog(
        context: context,
        builder: (context) => VistaImage( saveImage));

  }



}