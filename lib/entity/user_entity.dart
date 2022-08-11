
import 'package:floor/floor.dart';

@entity
class User{
  @PrimaryKey(autoGenerate: true)
  int? userId;

  String userName;
  String email;
  String password;

  User({this.userId,required this.userName,required this.email,required this.password});
}