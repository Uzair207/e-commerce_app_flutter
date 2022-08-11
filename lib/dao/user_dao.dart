





import 'package:floor/floor.dart';
import 'package:shopping_app_design/entity/user_entity.dart';

@dao
abstract class UserDao {

  @Query('Select * from User')
  Future<List<User>> getAllUsers();

  @Query('Select * from User WHERE userId = :userId')
  Future<User?> getUserById(int userId);

  @insert
  Future<void> addUser(User user);

  @Query('Delete from User')
  Future<void> deleteAllUsers();

  @Query('Select * FROM User WHERE userName = :userName AND password = :password LIMIT 1')
  Future<User?> getRegisteredUser(String userName,String password);

  @update
  Future<void> updateUser(User user);
}