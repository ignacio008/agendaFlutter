

class ModelSticker{

  String idSticker;
  String imageSticker;
  DateTime createdAtSticker;
  DateTime updateAtSticker;

  ModelSticker({this.idSticker,this.imageSticker,this.createdAtSticker,this.updateAtSticker});

   List  <ModelSticker> getSticker(dynamic miInfo){
      List<ModelSticker>iconmodelLits=[];

      
for(var datos in miInfo){
      final idSticker_ = datos.data()['idSticker'];
      final imageSticker_ = datos.data()['imageSticker'];
     
      final createdAtSticker_ = datos.data()['createdAtSticker']?? null;
      final updateAtSticker_ = datos.data()['updateAtSticker']?? null;;


     
     

      ModelSticker servicemodel = ModelSticker(
        idSticker:idSticker_,
        imageSticker: imageSticker_,
        createdAtSticker: createdAtSticker_== null ? null :createdAtSticker_.toDate(),
        updateAtSticker: updateAtSticker_== null ? null :updateAtSticker_.toDate(),
        
      
      );
 iconmodelLits.add(servicemodel);
}
      return iconmodelLits;
     }

      Map<String, dynamic> toJsonBody(idSticker,imageSticker,createdAtSticker) =>
          {
            'idSticker': idSticker,
            'imageSticker': imageSticker,
            'createdAtSticker': createdAtSticker,
            
          };

}