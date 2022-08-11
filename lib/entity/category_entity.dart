import 'package:floor/floor.dart';
@entity
class ProductCategory{
  @PrimaryKey(autoGenerate: true)
  int? categoryId;
  String categoryName;

  ProductCategory({this.categoryId, required this.categoryName});
}