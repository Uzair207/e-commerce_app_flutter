
import 'package:floor/floor.dart';
import 'package:shopping_app_design/entity/cart_entity.dart';
import 'package:shopping_app_design/entity/products_entity.dart';

@dao
abstract class CartDao {


  @Query('Select * from Cart where id = :id')
  Future<Cart?> getCartById(int id);

  @insert
  Future<void> addCart(Cart cart);

  @Query('Select * from Cart')
  Future<List<Cart>> getAllCarts();

  @Query('Select * from Product Join Cart on Product.productId=Cart.productId where userId = :userId')
  Future<List<Product>> getProductsOfCartByUserId(int userId);

  @Query('Delete from Cart where userId = :uid AND productId = :pid')
  Future<void> deleteProductByUserId(int uid,int pid);

  @Query('Select * from Cart where productId = :id')
  Future<Cart?> getCartProductById(int id);

}