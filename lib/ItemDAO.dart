import 'package:floor/floor.dart';
import 'Item.dart';


@dao
abstract class ItemDAO{
//all these functions must be asynchronous, must return Future< >:

  @Query('SELECT * FROM Item') //a Item() constructor is called here:
  Future< List< Item > > getAllItems();

  @insert
  Future<int> insertItem(Item i);

  @delete
  Future<void> deleteItem(Item i);

  @update
  Future<void> updateItem(Item i);
}