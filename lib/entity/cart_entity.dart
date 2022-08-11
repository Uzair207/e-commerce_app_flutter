
import 'package:floor/floor.dart';
import 'package:shopping_app_design/entity/products_entity.dart';
import 'package:shopping_app_design/entity/user_entity.dart';
@Entity(
    tableName: 'Cart',
    foreignKeys: [
      ForeignKey(
        childColumns: ['userId'],
        parentColumns: ['userId'],
        entity: User,
        onDelete: ForeignKeyAction.cascade
    ),
      ForeignKey(
          childColumns: ['productId'],
          parentColumns: ['productId'],
          entity: Product,
        onDelete: ForeignKeyAction.cascade
      ),
    ]
)


class Cart{

  @PrimaryKey(autoGenerate: true)
  int? id;

  int? userId;

  int? productId;

  int? quantity;

  Cart({this.id, required this.userId,required this.productId,required this.quantity});
}