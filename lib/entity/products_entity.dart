
import 'package:floor/floor.dart';
import 'package:shopping_app_design/entity/category_entity.dart';


@Entity(
    tableName: 'Product',
    foreignKeys: [
      ForeignKey(
          childColumns: ['categoryId'],
          parentColumns: ['categoryId'],
          entity: ProductCategory,
          onDelete: ForeignKeyAction.cascade
      ),
    ]
)

class Product{
  @PrimaryKey(autoGenerate: true)
  int? productId;

  String productName;
  int price;
  int categoryId;
  int discount;

  Product({this.productId, required this.productName, required this.price, required this.categoryId, required this.discount});
}