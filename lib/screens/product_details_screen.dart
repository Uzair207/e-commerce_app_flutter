import 'package:flutter/material.dart';
import 'package:shopping_app_design/dao/cart_dao.dart';
import 'package:shopping_app_design/entity/cart_entity.dart';
import 'package:shopping_app_design/entity/user_entity.dart';
import 'package:shopping_app_design/screens/checkout_screen.dart';
import 'package:shopping_app_design/screens/main.dart';
List<CartItem> myCart = [];
class ProductBuyScreen extends StatefulWidget {
  ProductBuyScreen({Key? key,required this.selectedItem,this.user,required this.cartDao}) : super(key: key);
  final ItemList selectedItem;
  User? user;
  final CartDao cartDao;
  @override
  State<ProductBuyScreen> createState() => _ProductBuyScreenState();
}

class _ProductBuyScreenState extends State<ProductBuyScreen> {
  int counter = 1;
  int newPrice = 0;
  int discountedPrice=0;
  int? quantity;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => setInitialPrice());
  }

  Future<void> setInitialPrice() async {
    setState(() {
      if(widget.selectedItem.discount==0){
      newPrice = widget.selectedItem.price;
      }
      else{
        discountedPrice = widget.selectedItem.price - ((widget.selectedItem.price * widget.selectedItem.discount)/100).toInt();
        newPrice = discountedPrice;
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          title: const Center(
              child: Text(
            "Product Detail",
            style: TextStyle(color: Colors.white),
          )),
          backgroundColor: Colors.black,


          actions: [
            IconButton(
                onPressed: () {
                  setState(() {


                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CheckOutScreen(widget.cartDao,true,widget.user)),
                  );
                },
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 30,
                ))
          ],
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                width: 500,
                height: 810,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: SizedBox(
                      width: 400,
                      height: 200,
                      child: Image.asset(widget.selectedItem.imgPath,
                          fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24)),
                      child: Container(
                        height: 600,
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.selectedItem.title,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 200),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "10 Sale",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                      Text(newPrice.toString() + "\$",
                                          style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepOrangeAccent))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 30, left: 140),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        if(widget.selectedItem.discount==0){
                                        deleteProduct(
                                            widget.selectedItem.price);
                                        }
                                        else{
                                          deleteProduct(discountedPrice);
                                        }
                                      },
                                      child: const Text("-")),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          left: 13, right: 13),
                                      child: Text(
                                        counter.toString(),
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      )),
                                  ElevatedButton(
                                    onPressed: () {
                                      if(widget.selectedItem.discount==0) {
                                        addProduct(widget.selectedItem.price);
                                      }
                                      else{
                                        addProduct(discountedPrice);
                                      }
                                    },
                                    child: const Text("+"),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.deepOrange),
                                      textStyle: MaterialStateProperty.all(
                                          const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 10),
                                child: const Text("Description",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrange))),
                            const Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla "
                                "pariatur. Excepteur sint occaecat cupidatat non proident, "
                                "sunt in culpa qui officia deserunt mollit anim id est laborum.",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey)),
                            Center(
                                child: TextButton(
                                    onPressed: () {},
                                    child: const Text("View More",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepOrange)))),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              width: 400,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () async {


                                    widget.cartDao.deleteProductByUserId(widget.user!.userId!,widget.selectedItem.productId!);
                                   widget.cartDao.addCart(Cart(userId:widget.user!.userId,productId:widget.selectedItem.productId,quantity: counter));
                                    final snack = SnackBar(
                                      backgroundColor: Colors.pink,
                                      content: Text('Added to Cart'),
                                      duration: Duration(seconds: 1),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snack);

                                    setState(() {

                                    });

                                },
                                child: const Text("Add to Cart"),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.deepOrange),
                                    textStyle: MaterialStateProperty.all(
                                        const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)))),
                              ),
                            ),
                            const Text("Comments",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange))
                          ],
                        ),
                      ),
                    ),
                  )
                ]))
          ]),
        ));
  }

  void addProduct(int price) {
    setState(() {
      newPrice = newPrice + price;
      counter++;
    });
  }

  void deleteProduct(int price) {
    setState(() {
      newPrice = newPrice - price;
      if (newPrice < price) {
        newPrice = price;
      }
      counter--;
      if (counter < 1) {
        counter = 1;
      }
    });
  }
}

class CartItem{
  String imgUrl;
  String title;
  int? quantity;
  int itemPrice;
  CartItem(this.imgUrl,this.title,this.quantity,this.itemPrice);
}






