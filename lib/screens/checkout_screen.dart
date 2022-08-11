
import 'package:flutter/material.dart';
import 'package:shopping_app_design/dao/cart_dao.dart';
import 'package:shopping_app_design/entity/cart_entity.dart';
import 'package:shopping_app_design/entity/products_entity.dart';
import 'package:shopping_app_design/entity/user_entity.dart';
import 'package:shopping_app_design/screens/product_details_screen.dart';

class CheckOutScreen extends StatefulWidget{
     CheckOutScreen(this.cartDao, this.showAppBar,this.user, {Key? key}) : super(key: key);
   final CartDao cartDao;
    bool showAppBar;
    User? user;
  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}


class _CheckOutScreenState extends State<CheckOutScreen> {
  List<Product> myCartList = [];
@override
void initState() {

  super.initState();

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white70,
      appBar: widget.showAppBar? AppBar(
        title: const Text("Your Cart",style: TextStyle(color: Colors.white,),),
        backgroundColor: Colors.black,
      ):PreferredSize(child: Container(), preferredSize: const Size(0.0,0.0)),
      body: FutureBuilder<List<Product>>(
            future: widget.cartDao.getProductsOfCartByUserId(widget.user!.userId!),
            builder: (_, data) {
              if (data.hasData) {
                myCartList = data.data!;
                if(myCartList.isEmpty) {
                  return const Center(child: Text("Your Cart is Empty",style: TextStyle(fontSize: 20,color: Colors.pink,fontWeight: FontWeight.bold),));
                } else {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: data.data!.length,
                      itemBuilder: (_, index) {



                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 15),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height/5.5,
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/shirt2.jpg",
                                            width: MediaQuery.of(context).size.width/3,
                                            height: MediaQuery.of(context).size.height/5.5,
                                            fit: BoxFit.fill,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 16,left: 18.0),
                                            child: FutureBuilder(
                                              future: widget.cartDao.getCartProductById(data.data![index].productId!),
                                              builder: (BuildContext context, AsyncSnapshot<Cart?> snapshot) {
                                                if(snapshot.hasData){
                                                  CartItem c;
                                                  if(data.data![index].discount==0){
                                                   c = CartItem("assets/images/shirt2.jpg", data.data![index].productName, snapshot.data!.quantity, data.data![index].price*snapshot.data!.quantity!);
                                                          }
                                                  else{
                                                      int discountedPrice = data.data![index].price - (data.data![index].price*data.data![index].discount)~/100;
                                                     c = CartItem("assets/images/shirt2.jpg", data.data![index].productName, snapshot.data!.quantity, discountedPrice*snapshot.data!.quantity!);
                                                  }

                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        c.title.toUpperCase(),
                                                        style: const TextStyle(
                                                            fontSize: 20,
                                                            color: Colors.deepOrangeAccent,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                      Text(
                                                        " x" + c.quantity.toString(),
                                                        style: const TextStyle(
                                                            color: Colors.grey, fontSize: 14),
                                                      ),

                                                      Text(
                                                        c.itemPrice.toString() +
                                                            "\$",
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.deepOrangeAccent,
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  );
                                                }

                                                else {
                                                  return const Text("");
                                                }

                                              },

                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/1.222,top: MediaQuery.of(context).size.height/6.7),
                                    child: IconButton(onPressed: () async {

                                      await widget.cartDao.deleteProductByUserId(widget.user!.userId!, data.data![index].productId!);

                                      const snack = SnackBar(backgroundColor: Colors.pink,content: Text('Removed From Cart'),duration: Duration(seconds: 1),);
                                      ScaffoldMessenger.of(context).showSnackBar(snack);
                                        setState(() {

                                        });

                                    }, icon: const Icon(Icons.delete,color: Colors.red,),iconSize: 30,),
                                  )


                                ],
                              ),
            ),
          ),
        );

      }
      ),
                  );
                }
        }
   else{
     return const Center(child: CircularProgressIndicator());
              }
      }),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){

      }, label: const Text("CheckOut"),backgroundColor: Colors.pink,),

    );
  }


}