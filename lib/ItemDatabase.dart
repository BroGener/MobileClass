import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import  'ItemDAO.dart';
import 'Item.dart';

part 'ItemDatabase.g.dart';

//version: 1, entities are what is inserted and retrieved,must match DAO class

@Database(version: 1, entities: [Item])  // Item must have @entity
abstract class ItemDatabase extends FloorDatabase{
//only one getter variable:
  ItemDAO get myDAO; //ItemDAO is the class type, myDao is the variable name, get means no =

}