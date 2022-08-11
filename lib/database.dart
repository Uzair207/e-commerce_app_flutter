import 'dart:async';
import 'package:floor/floor.dart';
import 'package:shopping_app_design/dao/cart_dao.dart';
import 'package:shopping_app_design/dao/category_dao.dart';
import 'package:shopping_app_design/dao/favourite_dao.dart';
import 'package:shopping_app_design/dao/product_dao.dart';
import 'package:shopping_app_design/dao/user_dao.dart';
import 'package:shopping_app_design/entity/category_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'entity/cart_entity.dart';
import 'entity/favourite_entity.dart';
import 'entity/products_entity.dart';
import 'entity/user_entity.dart';
part 'database.g.dart';

@Database(version: 1, entities:[Product,ProductCategory,User,Cart,Favourite])
abstract class AppDatabase extends FloorDatabase {
  ProductDao get productDao;

  CategoryDao get categoryDao;

  UserDao get userDao;

  CartDao get cartDao;

  FavouriteDao get favouriteDao;
}