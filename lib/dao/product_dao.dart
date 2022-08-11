
import 'package:floor/floor.dart';
import 'package:shopping_app_design/entity/products_entity.dart';

@dao
abstract class ProductDao{

  @Query('Select * from Product')
  Future<List<Product>> getAllProducts();

  @Query('Select * from Product where productId = :id')
  Future<Product?> getProductById(int id);

  @insert
  Future<void> addProduct(Product product);

  @Query('Delete from Product')
  Future<void> deleteAllProducts();

  @Query('Select * from Product where categoryId = :category')
  Future<List<Product>> getProductByCategory(int category);

  @Query('Select * from Product where productName = :pname AND categoryId = :cat')
  Future<Product?> getProductByNameAndCat(String pname,int cat);

  @Query('Delete from Product where productId = :pid')
  Future<void> deleteProductById(int pid);

}