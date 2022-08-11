

import 'package:floor/floor.dart';
import 'package:shopping_app_design/entity/favourite_entity.dart';
import 'package:shopping_app_design/entity/products_entity.dart';

@dao
abstract class FavouriteDao{

  @Query('Select * from Favourite where uid = :uid AND id = :id')
  Future<Favourite?> getFavinFavByUid(int uid,int id);

  @insert
  Future<void> insertFav(Favourite fav);

  @Query('Delete from Favourite where uid = :uid AND id = :pid')
  Future<void> deleteFav(int uid,int pid);

  @Query('Select * from Product Join Favourite on Product.productId=Favourite.id where uid = :id')
  Future<List<Product>> getFavProductsByUserId(int id);
}