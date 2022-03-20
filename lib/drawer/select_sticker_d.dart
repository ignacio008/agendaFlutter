import 'package:flutter/material.dart';

import 'package:flutter_painter/flutter_painter.dart';
import 'package:z08_agenda/model/model_sticker.dart';

class SelectStickerD extends StatefulWidget {
  List<ModelSticker> iconmodelSticker;
  BuildContext context;
  PainterController controller;
  SelectStickerD(this.iconmodelSticker,this.context, this.controller);

  @override
  State<SelectStickerD> createState() => _SelectStickerDState();
}

class _SelectStickerDState extends State<SelectStickerD> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select sticker"),
      content: widget.iconmodelSticker.isEmpty
          ? const Text("No images")
          : FractionallySizedBox(
              heightFactor: 0.5,
              child: SingleChildScrollView(
                child: Wrap(
                  children: [
                    for (final imageLink in widget.iconmodelSticker)
                      InkWell(
                        onTap: () async{
                          widget.controller.addImage(
               await NetworkImage(imageLink.imageSticker).image, const Size(100, 100));
                           Navigator.pop(widget.context );
                        
                        },
                        child: FractionallySizedBox(
                          widthFactor: 1 / 4,
                          child: Image.network(imageLink.imageSticker,
                          
                          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent loadingProgress) {
                     if (loadingProgress == null) {
              return child;
            }
            return Center(
              child: Container(
                width:MediaQuery.of(context).size.width*0.2,
                height:MediaQuery.of(context).size.height*0.08,
                 decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),               
              ),
                child: Transform.scale(
                  scale:0.5,
                  child: CircularProgressIndicator(
                     valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                     strokeWidth:6.0,
                  ),
                ),
              ),
            );
                  },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(widget.context),
        )
      ],
    );
  }
}