import 'package:flutter/material.dart';
import 'package:shopping_app_design/dao/cart_dao.dart';
import 'package:shopping_app_design/dao/category_dao.dart';
import 'package:shopping_app_design/dao/favourite_dao.dart';
import 'package:shopping_app_design/dao/product_dao.dart';
import 'package:shopping_app_design/dao/user_dao.dart';
import 'package:shopping_app_design/entity/category_entity.dart';
import 'package:shopping_app_design/entity/favourite_entity.dart';
import 'package:shopping_app_design/entity/products_entity.dart';
import 'package:shopping_app_design/entity/user_entity.dart';
import 'package:shopping_app_design/screens/buy.dart';
import 'package:shopping_app_design/screens/checkout_screen.dart';
import 'package:shopping_app_design/screens/edit_profile_screen.dart';
import 'package:shopping_app_design/screens/product_details_screen.dart';

import 'login_screen.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage(
      {Key? key,
      required this.title,
      required this.productDao,
      required this.categoryDao,
      required this.userDao,
      required this.myCatList,
      required this.cartDao,
      required this.favDao,
      this.user})
      : super(key: key);
  final String title;
  final ProductDao productDao;
  final CategoryDao categoryDao;
  final UserDao userDao;
  final CartDao cartDao;
  final FavouriteDao favDao;
  User? user;
  List<String> myCatList;
  String selectedCat = "";
  bool isTapped = false;
  bool showAppBar = false;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  var itemList = [
    "PullOver",
    "Mango",
    const Icon(Icons.add_shopping_cart),
    "51\$"
  ];
  int currentIndex = 0;
  List<Product> productsWithCat = [];
  List<Product> productsList = [];
  List<Product> favouritesList = [];
  int selectedCatId = 0;

  @override
  void initState() {
    _tabController =
        TabController(length: widget.myCatList.length + 1, vsync: this);
    // TODO: implement initState
    super.initState();
  }

  Future<List<Product>> getProductsByCategory(int id) async {
    List<Product> productsWithCat = [];
    final result = await widget.productDao.getProductByCategory(id);
    for (int i = 0; i < result.length; i++) {
      productsWithCat.add(result.elementAt(i));
    }
    return productsWithCat;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabController!.length,
      child: WillPopScope(
        onWillPop: () async {
          const snack = SnackBar(
            backgroundColor: Colors.deepOrange,
            content: Text('You are on Home Screen'),
            duration: Duration(seconds: 1),
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white70,
          appBar: currentIndex != 3 && currentIndex == 0
              ? AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: Text(
                    widget.title.toUpperCase() +
                        " " +
                        widget.user!.userName.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(right: 9),
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyBuyScreen(
                                          title: widget.title,
                                          productDao: widget.productDao,
                                          categoryDao: widget.categoryDao,
                                          userDao: widget.userDao,
                                          cartDao: widget.cartDao,
                                          favDao: widget.favDao,
                                          myCatList: widget.myCatList,
                                          user: widget.user,
                                        )));
                          },
                          icon: const Icon(
                            Icons.grid_view,
                            color: Colors.black,
                          )),
                    )
                  ],
                  backgroundColor: Colors.white,
                  bottom: TabBar(
                    indicatorColor: Colors.white,
                    controller: _tabController,
                    isScrollable: true,
                    tabs: [
                      Tab(
                        child: ElevatedButton(
                          child: const Text(
                            "All",
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black),
                              textStyle: MaterialStateProperty.all(
                                  const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20)))),
                          onPressed: () {
                            widget.isTapped = true;
                            setState(() {});
                          },
                        ),
                      ),
                      for (int i = 0; i < widget.myCatList.length; i++)
                        Tab(
                          child: ElevatedButton(
                            onPressed: () async {
                              widget.isTapped = false;
                              widget.selectedCat = widget.myCatList[i];
                              final selectedCatIdRes = await widget.categoryDao
                                  .getCategoryByName(widget.selectedCat);
                              selectedCatId = selectedCatIdRes!.categoryId!;
                              setState(() {});
                            },
                            child: Text(widget.myCatList[i]),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black),
                                textStyle: MaterialStateProperty.all(
                                    const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)))),
                          ),
                        ),
                    ],
                  ),
                )
              : currentIndex == 3
                  ? AppBar(
                      toolbarHeight: 90,
                      backgroundColor: Colors.white,
                      title: const Text(
                        "Your Profile Info",
                        style: TextStyle(color: Colors.black54, fontSize: 30),
                      ),
                    )
                  : PreferredSize(
                      child: Container(), preferredSize: const Size(0.0, 0.0)),
          body: getStackedScreens(),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            selectedFontSize: 15,
            selectedItemColor: Colors.deepOrange,
            type: BottomNavigationBarType.fixed,
            iconSize: 30,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: 'Favourites'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag), label: 'Bag'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
            ],
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget getStackedScreens() {
    return IndexedStack(
      index: currentIndex,
      children: [
        FutureBuilder<List<Product>>(
            future: widget.selectedCat.isEmpty || widget.isTapped
                ? widget.productDao.getAllProducts()
                : getProductsByCategory(selectedCatId),
            builder: (_, data) {
              if (data.hasData) {
                productsList = data.data!;
                if (productsList.isEmpty) {
                  return const Center(
                      child: Text(
                    "No Products",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ));
                } else {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        itemCount: data.data!.length,
                        itemBuilder: (_, index) {
                          return FutureBuilder<ProductCategory?>(
                              future: widget.categoryDao.getCategoryById(
                                  data.data![index].categoryId),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  ItemList product;
                                  product = ItemList(
                                      "assets/images/shirt2.jpg",
                                      data.data![index].productName,
                                      snapshot.data!.categoryName,
                                      "assets/images/star.jpg",
                                      data.data![index].price,
                                      data.data![index].discount,
                                      data.data![index].productId);
                                  int discountedPrice = product.price -
                                      (product.price * product.discount) ~/ 100;

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 13),
                                    child: Stack(children: [
                                      GestureDetector(
                                        onTap: () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        ProductBuyScreen(
                                                          selectedItem: product,
                                                          user: widget.user,
                                                          cartDao:
                                                              widget.cartDao,
                                                        ))),
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              5.7,
                                          child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3.2,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              5.7,
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          12),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          12)),
                                                          child: Image.asset(
                                                            product.imgPath,
                                                            fit: BoxFit.fill,
                                                          ))),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 14, left: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 6),
                                                          child: Text(
                                                            product.title
                                                                .toUpperCase(),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 6),
                                                          child: Text(
                                                            product.subTitle
                                                                .toUpperCase(),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .grey),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 8),
                                                          child: Container(
                                                              child: Row(
                                                            children: [
                                                              Image(
                                                                image: AssetImage(
                                                                    product
                                                                        .iconPath),
                                                                height: 40,
                                                              ),
                                                              const Text(
                                                                "(10)",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        10),
                                                              )
                                                            ],
                                                          )),
                                                        ),
                                                        product.discount == 0
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            6),
                                                                child: Text(
                                                                  product.price
                                                                          .toString() +
                                                                      "\$",
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              )
                                                            : Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            6),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      product.price
                                                                              .toString() +
                                                                          "\$",
                                                                      style: const TextStyle(
                                                                          decoration: TextDecoration
                                                                              .lineThrough,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        discountedPrice.toString() +
                                                                            "\$",
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.red,
                                                                            fontSize: 12),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                                      FutureBuilder(
                                          future: checkFav(product),
                                          builder: (_, snapshot) {
                                            if (snapshot.hasData) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    top: MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        6.8,
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        1.248),
                                                child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            boxShadow: [
                                                          BoxShadow(
                                                              blurRadius: 10,
                                                              color:
                                                                  Colors.grey,
                                                              spreadRadius: 0.3)
                                                        ]),
                                                    child: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        radius: 20,
                                                        child: IconButton(
                                                          iconSize: 20,
                                                          onPressed: () async {
                                                            var item = snapshot
                                                                    .data
                                                                as Favourite;
                                                            await widget.favDao
                                                                .deleteFav(
                                                                    item.uid!,
                                                                    item.id!);

                                                            const snackBar =
                                                                SnackBar(
                                                              backgroundColor:
                                                                  Colors.pink,
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          1),
                                                              content: Text(
                                                                  'Removed From Favourites!'),
                                                            );

                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    snackBar);

                                                            setState(() {});
                                                          },
                                                          icon: const Icon(
                                                              Icons.favorite),
                                                          color: Colors.red,
                                                        ))),
                                              );
                                            } else {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        1.248,
                                                    top: MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        6.8),
                                                child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            boxShadow: [
                                                          BoxShadow(
                                                              blurRadius: 10,
                                                              color:
                                                                  Colors.grey,
                                                              spreadRadius: 0.3)
                                                        ]),
                                                    child: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        radius: 20,
                                                        child: IconButton(
                                                          iconSize: 20,
                                                          onPressed: () async {
                                                            Favourite
                                                                favourite =
                                                                Favourite(
                                                                    id: product
                                                                        .productId,
                                                                    name: product
                                                                        .title,
                                                                    uid: widget
                                                                        .user!
                                                                        .userId);
                                                            await widget.favDao
                                                                .insertFav(
                                                                    favourite);

                                                            const snackBar =
                                                                SnackBar(
                                                              content: Text(
                                                                  'Added as Favourite'),
                                                              backgroundColor:
                                                                  Colors.pink,
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          1),
                                                            );

                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    snackBar);

                                                            setState(() {});
                                                          },
                                                          icon: const Icon(
                                                              Icons.favorite),
                                                          color: Colors.grey,
                                                        ))),
                                              );
                                            }
                                          }),
                                    ]),
                                  );
                                } else {
                                  return const Center(child: Text(""));
                                }
                              });
                        }),
                  );
                }
              } else if (data.hasError) {
                return const Text("An Error Occurred");
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
        FutureBuilder<List<Product>>(
            future: widget.favDao.getFavProductsByUserId(widget.user!.userId!),
            builder: (_, data) {
              if (data.hasData) {
                favouritesList = data.data!;
                if (favouritesList.isEmpty) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.favorite,
                        size: 30,
                        color: Colors.pink,
                      ),
                      Text(
                        "No Products",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.pink,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "added",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.pink,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "as",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.pink,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Favourite",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.pink,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ));
                } else {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        itemCount: data.data!.length,
                        itemBuilder: (_, index) {
                          int discountedPrice = data.data![index].price -
                              (data.data![index].price *
                                      data.data![index].discount) ~/
                                  100;

                          return SingleChildScrollView(
                            child: FutureBuilder<ProductCategory?>(
                                future: widget.categoryDao.getCategoryById(
                                    data.data![index].categoryId),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    ItemList product;
                                    product = ItemList(
                                        "assets/images/shirt2.jpg",
                                        data.data![index].productName,
                                        snapshot.data!.categoryName,
                                        "assets/images/star.jpg",
                                        data.data![index].price,
                                        data.data![index].discount,
                                        data.data![index].productId);
                                    return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 14,
                                            bottom: 10),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            child: Stack(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      5.3,
                                                  child: Card(
                                                      child: Row(children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2),
                                                      child: Image.asset(
                                                        "assets/images/shirt2.jpg",
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            5.3,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 18,
                                                                left: 18.0),
                                                        child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                data
                                                                    .data![
                                                                        index]
                                                                    .productName
                                                                    .toUpperCase(),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .deepOrange,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                snapshot.data!
                                                                    .categoryName
                                                                    .toUpperCase(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                              data.data![index]
                                                                          .discount ==
                                                                      0
                                                                  ? Text(
                                                                      data.data![index]
                                                                              .price
                                                                              .toString() +
                                                                          "\$",
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .red,
                                                                          fontSize:
                                                                              16),
                                                                    )
                                                                  : Row(
                                                                      children: [
                                                                        Text(
                                                                          data.data![index].price.toString() +
                                                                              "\$",
                                                                          style: const TextStyle(
                                                                              decoration: TextDecoration.lineThrough,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black,
                                                                              fontSize: 16),
                                                                        ),
                                                                        Container(
                                                                          margin:
                                                                              const EdgeInsets.only(left: 5),
                                                                          child:
                                                                              Text(
                                                                            discountedPrice.toString() +
                                                                                "\$",
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.red,
                                                                                fontSize: 16),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                            ]))
                                                  ])),
                                                ),
                                                FutureBuilder(
                                                    future: checkFav(product),
                                                    builder: (_, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return Padding(
                                                          padding: EdgeInsets.only(
                                                              left: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  1.222,
                                                              top: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  6.2),
                                                          child: Container(
                                                              decoration: const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        blurRadius:
                                                                            10,
                                                                        color: Colors
                                                                            .grey,
                                                                        spreadRadius:
                                                                            0.3)
                                                                  ]),
                                                              child:
                                                                  CircleAvatar(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      radius:
                                                                          20,
                                                                      child:
                                                                          IconButton(
                                                                        iconSize:
                                                                            20,
                                                                        onPressed:
                                                                            () async {
                                                                          var item =
                                                                              snapshot.data as Favourite;
                                                                          await widget.favDao.deleteFav(
                                                                              item.uid!,
                                                                              item.id!);

                                                                          const snackBar =
                                                                              SnackBar(
                                                                            backgroundColor:
                                                                                Colors.pink,
                                                                            duration:
                                                                                Duration(seconds: 1),
                                                                            content:
                                                                                Text('Removed From Favourites!'),
                                                                          );

                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(snackBar);

                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        icon: const Icon(
                                                                            Icons.favorite),
                                                                        color: Colors
                                                                            .red,
                                                                      ))),
                                                        );
                                                      } else {
                                                        return Padding(
                                                          padding: EdgeInsets.only(
                                                              left: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  1.222,
                                                              top: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  6),
                                                          child: Container(
                                                              decoration: const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        blurRadius:
                                                                            10,
                                                                        color: Colors
                                                                            .grey,
                                                                        spreadRadius:
                                                                            0.3)
                                                                  ]),
                                                              child:
                                                                  CircleAvatar(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      radius:
                                                                          20,
                                                                      child:
                                                                          IconButton(
                                                                        iconSize:
                                                                            20,
                                                                        onPressed:
                                                                            () async {
                                                                          Favourite favourite = Favourite(
                                                                              id: product.productId,
                                                                              name: product.title,
                                                                              uid: widget.user!.userId);
                                                                          await widget
                                                                              .favDao
                                                                              .insertFav(favourite);

                                                                          const snackBar =
                                                                              SnackBar(
                                                                            content:
                                                                                Text('Added as Favourite'),
                                                                            backgroundColor:
                                                                                Colors.pink,
                                                                            duration:
                                                                                Duration(seconds: 1),
                                                                          );

                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(snackBar);

                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        icon: const Icon(
                                                                            Icons.favorite),
                                                                        color: Colors
                                                                            .grey,
                                                                      ))),
                                                        );
                                                      }
                                                    }),
                                              ],
                                            )));
                                  } else {
                                    return Text("");
                                  }
                                }),
                          );
                        }),
                  );
                }
              } else if (data.hasError) {
                return const Text("Error");
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        CheckOutScreen(widget.cartDao, widget.showAppBar, widget.user),
        FutureBuilder<User?>(
            future: widget.userDao.getUserById(widget.user!.userId!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 13,
                        right: MediaQuery.of(context).size.width / 13,
                        top: MediaQuery.of(context).size.height / 13,
                        bottom: MediaQuery.of(context).size.height / 13),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 1.7,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 60, right: 10, bottom: 40, left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Name: ${snapshot.data!.userName.toUpperCase()}",
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Email: ${snapshot.data!.email}",
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Column(
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        setState(() {});
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditProfile(snapshot.data,
                                                        widget.userDao)));
                                      },
                                      label: const Text("Update Profile"),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.black),
                                          textStyle: MaterialStateProperty.all(
                                              const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)))),
                                      icon: const Icon(Icons.edit),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen()),
                                            (Route<dynamic> route) => false);
                                      },
                                      label: const Text("Log Out"),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.black),
                                          textStyle: MaterialStateProperty.all(
                                              const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)))),
                                      icon: const Icon(Icons.logout),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return const Text("User info here");
              }
            }),
      ],
    );
  }

  Future<Favourite?> checkFav(ItemList product) async {
    return await widget.favDao
        .getFavinFavByUid(widget.user!.userId!, product.productId!);
  }
}

class ItemList {
  String imgPath;
  String title;
  String subTitle;
  String iconPath;
  int price;
  int discount;
  int? productId;

  ItemList(this.imgPath, this.title, this.subTitle, this.iconPath, this.price,
      this.discount, this.productId);
}
