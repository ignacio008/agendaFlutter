class ModelNote{
  String idNote;
  String html;
  String imagenNote;
  DateTime createdAtNote;
  DateTime updateAtNote;
  String titleHtml;
  String descriptionHtml;

  ModelNote({this.idNote,this.html,this.imagenNote, this.createdAtNote,this.updateAtNote,this.titleHtml,this.descriptionHtml  });


  List  <ModelNote> getSticker(dynamic miInfo){
      List<ModelNote>iconmodelLits=[];

      
for(var datos in miInfo){
      final idNote_ = datos.data()['idNote'];
      final html_ = datos.data()['html'];
      final imagenNote_ = datos.data()['imagenNote'];
     
      final createdAtNote_ = datos.data()['createdAtNote']?? null;
      final updateAtNote_ = datos.data()['updateAtNote']?? null;;
      
      final titleHtml_ = datos.data()['titleHtml'];
      final descriptionHtml_ = datos.data()['descriptionHtml'];

      ModelNote servicemodel = ModelNote(
        idNote:idNote_,
        html:html_,
        imagenNote: imagenNote_,
        createdAtNote: createdAtNote_== null ? null :createdAtNote_.toDate(),
        updateAtNote: updateAtNote_== null ? null :updateAtNote_.toDate(),
        titleHtml:titleHtml_,
        descriptionHtml:descriptionHtml_,
        
      
      );
 iconmodelLits.add(servicemodel);
}
      return iconmodelLits;
     }

      Map<String, dynamic> toJsonBodyCrearNote(idNote,html,createdAtNote,titleHtml,descriptionHtml) =>
          {
            'idNote': idNote,
            'html': html,
            'createdAtNote': createdAtNote,
            'titleHtml':titleHtml,
            'descriptionHtml':descriptionHtml,
            
          };
           Map<String, dynamic> toJsonBodyUpdate(idNote,html,updateAtNote,titleHtml,descriptionHtml) =>
          {
            'idNote': idNote,
            'html': html,
            'updateAtNote': updateAtNote,
            'titleHtml':titleHtml,
            'descriptionHtml':descriptionHtml,
            
          };
}