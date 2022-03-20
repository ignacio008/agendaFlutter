import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class SingleItem extends StatefulWidget
{
  Function addItem,removeItem;

  SingleItem(this.addItem,this.removeItem);

  @override
  State<StatefulWidget> createState() => _SingleItemState();

}

class _SingleItemState extends State<SingleItem>
{
    
    
  int _counter = 0;
  @override
  Widget build(BuildContext context) {
    
    

    return Row(mainAxisAlignment: MainAxisAlignment.center,children: [
      Text(_counter.toString()),
      CupertinoButton(child: Text("+"), onPressed: (){
     
        print("+++");
        setState(() {
    
    
          _counter++;
        });
      }),
      CupertinoButton(child: Text("Add"), onPressed: (){
    
    
        print("Add");
        setState(() {
    
    
         widget.addItem();
        });
      }),
      CupertinoButton(child: Text("Remove"), onPressed: (){
    
    
        print("remove");
        setState(() {
    
    
          widget.removeItem(widget);
        });
      }),
    ],);
  }
  
}