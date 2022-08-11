
import 'package:floor/floor.dart';

@entity
class Favourite{
  @PrimaryKey(autoGenerate: true)
  int? favId;

   int? id;

   String name;

   int? uid;

  Favourite({this.favId,this.id, required this.name, required this.uid});
}