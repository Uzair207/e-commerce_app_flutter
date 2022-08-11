
import 'package:floor/floor.dart';
import 'package:shopping_app_design/entity/category_entity.dart';

@dao
abstract class CategoryDao {

  @Query('Select * from ProductCategory')
  Future<List<ProductCategory>> getAllCategories();

  @Query('Select * from ProductCategory where categoryId = :id')
  Future<ProductCategory?> getCategoryById(int id);

  @insert
  Future<void> addCategory(ProductCategory productCategory);

  @Query('Delete from ProductCategory')
  Future<void> deleteAllCategories();

  @Query('Select * from ProductCategory where categoryName = :catName')
  Future<ProductCategory?> getCategoryByName(String catName);

  @Query('Delete from ProductCategory where categoryId = :catId')
  Future<void> deleteCategoryById(int catId);
}