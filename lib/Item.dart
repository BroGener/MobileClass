

import 'package:floor/floor.dart';

@entity
class Item {
  static int ID = 1; //static class variable for handing out IDs, must be greater than what's in the database


  //this is a constructor where id is first parameter
  //quantity is the second
  //name is the third
  Item(this.id, this.quantity, this.name){
    if(this.id > ID)
    {
      ID = this.id + 1;
    }
  }



  @primaryKey
  final int id ;

  String name;

  int quantity;

}