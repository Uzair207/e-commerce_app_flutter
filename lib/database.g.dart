// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ProductDao? _productDaoInstance;

  CategoryDao? _categoryDaoInstance;

  UserDao? _userDaoInstance;

  CartDao? _cartDaoInstance;

  FavouriteDao? _favouriteDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Product` (`productId` INTEGER PRIMARY KEY AUTOINCREMENT, `productName` TEXT NOT NULL, `price` INTEGER NOT NULL, `categoryId` INTEGER NOT NULL, `discount` INTEGER NOT NULL, FOREIGN KEY (`categoryId`) REFERENCES `ProductCategory` (`categoryId`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ProductCategory` (`categoryId` INTEGER PRIMARY KEY AUTOINCREMENT, `categoryName` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `User` (`userId` INTEGER PRIMARY KEY AUTOINCREMENT, `userName` TEXT NOT NULL, `email` TEXT NOT NULL, `password` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Cart` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userId` INTEGER, `productId` INTEGER, `quantity` INTEGER, FOREIGN KEY (`userId`) REFERENCES `User` (`userId`) ON UPDATE NO ACTION ON DELETE CASCADE, FOREIGN KEY (`productId`) REFERENCES `Product` (`productId`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Favourite` (`favId` INTEGER PRIMARY KEY AUTOINCREMENT, `id` INTEGER, `name` TEXT NOT NULL, `uid` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ProductDao get productDao {
    return _productDaoInstance ??= _$ProductDao(database, changeListener);
  }

  @override
  CategoryDao get categoryDao {
    return _categoryDaoInstance ??= _$CategoryDao(database, changeListener);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  CartDao get cartDao {
    return _cartDaoInstance ??= _$CartDao(database, changeListener);
  }

  @override
  FavouriteDao get favouriteDao {
    return _favouriteDaoInstance ??= _$FavouriteDao(database, changeListener);
  }
}

class _$ProductDao extends ProductDao {
  _$ProductDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _productInsertionAdapter = InsertionAdapter(
            database,
            'Product',
            (Product item) => <String, Object?>{
                  'productId': item.productId,
                  'productName': item.productName,
                  'price': item.price,
                  'categoryId': item.categoryId,
                  'discount': item.discount
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Product> _productInsertionAdapter;

  @override
  Future<List<Product>> getAllProducts() async {
    return _queryAdapter.queryList('Select * from Product',
        mapper: (Map<String, Object?> row) => Product(
            productId: row['productId'] as int?,
            productName: row['productName'] as String,
            price: row['price'] as int,
            categoryId: row['categoryId'] as int,
            discount: row['discount'] as int));
  }

  @override
  Future<Product?> getProductById(int id) async {
    return _queryAdapter.query('Select * from Product where productId = ?1',
        mapper: (Map<String, Object?> row) => Product(
            productId: row['productId'] as int?,
            productName: row['productName'] as String,
            price: row['price'] as int,
            categoryId: row['categoryId'] as int,
            discount: row['discount'] as int),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllProducts() async {
    await _queryAdapter.queryNoReturn('Delete from Product');
  }

  @override
  Future<List<Product>> getProductByCategory(int category) async {
    return _queryAdapter.queryList(
        'Select * from Product where categoryId = ?1',
        mapper: (Map<String, Object?> row) => Product(
            productId: row['productId'] as int?,
            productName: row['productName'] as String,
            price: row['price'] as int,
            categoryId: row['categoryId'] as int,
            discount: row['discount'] as int),
        arguments: [category]);
  }

  @override
  Future<Product?> getProductByNameAndCat(String pname, int cat) async {
    return _queryAdapter.query(
        'Select * from Product where productName = ?1 AND categoryId = ?2',
        mapper: (Map<String, Object?> row) => Product(
            productId: row['productId'] as int?,
            productName: row['productName'] as String,
            price: row['price'] as int,
            categoryId: row['categoryId'] as int,
            discount: row['discount'] as int),
        arguments: [pname, cat]);
  }

  @override
  Future<void> deleteProductById(int pid) async {
    await _queryAdapter.queryNoReturn(
        'Delete from Product where productId = ?1',
        arguments: [pid]);
  }

  @override
  Future<void> addProduct(Product product) async {
    await _productInsertionAdapter.insert(product, OnConflictStrategy.abort);
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _productCategoryInsertionAdapter = InsertionAdapter(
            database,
            'ProductCategory',
            (ProductCategory item) => <String, Object?>{
                  'categoryId': item.categoryId,
                  'categoryName': item.categoryName
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ProductCategory> _productCategoryInsertionAdapter;

  @override
  Future<List<ProductCategory>> getAllCategories() async {
    return _queryAdapter.queryList('Select * from ProductCategory',
        mapper: (Map<String, Object?> row) => ProductCategory(
            categoryId: row['categoryId'] as int?,
            categoryName: row['categoryName'] as String));
  }

  @override
  Future<ProductCategory?> getCategoryById(int id) async {
    return _queryAdapter.query(
        'Select * from ProductCategory where categoryId = ?1',
        mapper: (Map<String, Object?> row) => ProductCategory(
            categoryId: row['categoryId'] as int?,
            categoryName: row['categoryName'] as String),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllCategories() async {
    await _queryAdapter.queryNoReturn('Delete from ProductCategory');
  }

  @override
  Future<ProductCategory?> getCategoryByName(String catName) async {
    return _queryAdapter.query(
        'Select * from ProductCategory where categoryName = ?1',
        mapper: (Map<String, Object?> row) => ProductCategory(
            categoryId: row['categoryId'] as int?,
            categoryName: row['categoryName'] as String),
        arguments: [catName]);
  }

  @override
  Future<void> deleteCategoryById(int catId) async {
    await _queryAdapter.queryNoReturn(
        'Delete from ProductCategory where categoryId = ?1',
        arguments: [catId]);
  }

  @override
  Future<void> addCategory(ProductCategory productCategory) async {
    await _productCategoryInsertionAdapter.insert(
        productCategory, OnConflictStrategy.abort);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'User',
            (User item) => <String, Object?>{
                  'userId': item.userId,
                  'userName': item.userName,
                  'email': item.email,
                  'password': item.password
                }),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'User',
            ['userId'],
            (User item) => <String, Object?>{
                  'userId': item.userId,
                  'userName': item.userName,
                  'email': item.email,
                  'password': item.password
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  @override
  Future<List<User>> getAllUsers() async {
    return _queryAdapter.queryList('Select * from User',
        mapper: (Map<String, Object?> row) => User(
            userId: row['userId'] as int?,
            userName: row['userName'] as String,
            email: row['email'] as String,
            password: row['password'] as String));
  }

  @override
  Future<User?> getUserById(int userId) async {
    return _queryAdapter.query('Select * from User WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => User(
            userId: row['userId'] as int?,
            userName: row['userName'] as String,
            email: row['email'] as String,
            password: row['password'] as String),
        arguments: [userId]);
  }

  @override
  Future<void> deleteAllUsers() async {
    await _queryAdapter.queryNoReturn('Delete from User');
  }

  @override
  Future<User?> getRegisteredUser(String userName, String password) async {
    return _queryAdapter.query(
        'Select * FROM User WHERE userName = ?1 AND password = ?2 LIMIT 1',
        mapper: (Map<String, Object?> row) => User(
            userId: row['userId'] as int?,
            userName: row['userName'] as String,
            email: row['email'] as String,
            password: row['password'] as String),
        arguments: [userName, password]);
  }

  @override
  Future<void> addUser(User user) async {
    await _userInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUser(User user) async {
    await _userUpdateAdapter.update(user, OnConflictStrategy.abort);
  }
}

class _$CartDao extends CartDao {
  _$CartDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _cartInsertionAdapter = InsertionAdapter(
            database,
            'Cart',
            (Cart item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'productId': item.productId,
                  'quantity': item.quantity
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Cart> _cartInsertionAdapter;

  @override
  Future<Cart?> getCartById(int id) async {
    return _queryAdapter.query('Select * from Cart where id = ?1',
        mapper: (Map<String, Object?> row) => Cart(
            id: row['id'] as int?,
            userId: row['userId'] as int?,
            productId: row['productId'] as int?,
            quantity: row['quantity'] as int?),
        arguments: [id]);
  }

  @override
  Future<List<Cart>> getAllCarts() async {
    return _queryAdapter.queryList('Select * from Cart',
        mapper: (Map<String, Object?> row) => Cart(
            id: row['id'] as int?,
            userId: row['userId'] as int?,
            productId: row['productId'] as int?,
            quantity: row['quantity'] as int?));
  }

  @override
  Future<List<Product>> getProductsOfCartByUserId(int userId) async {
    return _queryAdapter.queryList(
        'Select * from Product Join Cart on Product.productId=Cart.productId where userId = ?1',
        mapper: (Map<String, Object?> row) => Product(productId: row['productId'] as int?, productName: row['productName'] as String, price: row['price'] as int, categoryId: row['categoryId'] as int, discount: row['discount'] as int),
        arguments: [userId]);
  }

  @override
  Future<void> deleteProductByUserId(int uid, int pid) async {
    await _queryAdapter.queryNoReturn(
        'Delete from Cart where userId = ?1 AND productId = ?2',
        arguments: [uid, pid]);
  }

  @override
  Future<Cart?> getCartProductById(int id) async {
    return _queryAdapter.query('Select * from Cart where productId = ?1',
        mapper: (Map<String, Object?> row) => Cart(
            id: row['id'] as int?,
            userId: row['userId'] as int?,
            productId: row['productId'] as int?,
            quantity: row['quantity'] as int?),
        arguments: [id]);
  }

  @override
  Future<void> addCart(Cart cart) async {
    await _cartInsertionAdapter.insert(cart, OnConflictStrategy.abort);
  }
}

class _$FavouriteDao extends FavouriteDao {
  _$FavouriteDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _favouriteInsertionAdapter = InsertionAdapter(
            database,
            'Favourite',
            (Favourite item) => <String, Object?>{
                  'favId': item.favId,
                  'id': item.id,
                  'name': item.name,
                  'uid': item.uid
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Favourite> _favouriteInsertionAdapter;

  @override
  Future<Favourite?> getFavinFavByUid(int uid, int id) async {
    return _queryAdapter.query(
        'Select * from Favourite where uid = ?1 AND id = ?2',
        mapper: (Map<String, Object?> row) => Favourite(
            favId: row['favId'] as int?,
            id: row['id'] as int?,
            name: row['name'] as String,
            uid: row['uid'] as int?),
        arguments: [uid, id]);
  }

  @override
  Future<void> deleteFav(int uid, int pid) async {
    await _queryAdapter.queryNoReturn(
        'Delete from Favourite where uid = ?1 AND id = ?2',
        arguments: [uid, pid]);
  }

  @override
  Future<List<Product>> getFavProductsByUserId(int id) async {
    return _queryAdapter.queryList(
        'Select * from Product Join Favourite on Product.productId=Favourite.id where uid = ?1',
        mapper: (Map<String, Object?> row) => Product(productId: row['productId'] as int?, productName: row['productName'] as String, price: row['price'] as int, categoryId: row['categoryId'] as int, discount: row['discount'] as int),
        arguments: [id]);
  }

  @override
  Future<void> insertFav(Favourite fav) async {
    await _favouriteInsertionAdapter.insert(fav, OnConflictStrategy.abort);
  }
}
