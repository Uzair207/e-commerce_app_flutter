
   import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app_design/dao/category_dao.dart';
import 'package:shopping_app_design/dao/product_dao.dart';
import 'package:shopping_app_design/entity/category_entity.dart';
import 'package:shopping_app_design/entity/products_entity.dart';

class ViewProductScreen extends StatefulWidget{
  ViewProductScreen(this.productDao,this.categoryDao);
  final ProductDao productDao;
  final CategoryDao categoryDao;

  @override
  State<ViewProductScreen> createState() => _ViewProductScreenState();
}

class _ViewProductScreenState extends State<ViewProductScreen> {
  List<Product> productList = [];
  List<ProductCategory> catList = [];
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("View Product"),
        backgroundColor: Colors.black54,
     ),
     body: SingleChildScrollView(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.start,
         children: [
           Padding(
             padding: const EdgeInsets.only(left: 25,top: 15),
             child: SizedBox(
                 height: MediaQuery.of(context).size.height/16,width: MediaQuery.of(context).size.width,
                 child: Text("List of Products: ",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
           ),
           Padding(
             padding: const EdgeInsets.only(left: 8,right: 8),
             child: SizedBox(
               height: MediaQuery.of(context).size.height/3,width: MediaQuery.of(context).size.width,
               child: FutureBuilder<List<Product>>(
                 future: widget.productDao.getAllProducts(),
                 builder: (_, snapshot) {
                   if(snapshot.hasData){
                     productList = snapshot.data!;
                     if(productList.isEmpty){
                       return Center(child: CircularProgressIndicator(),);
                     }
                     else{
                   return ListView.builder(itemCount: snapshot.data!.length,itemBuilder: (context,index){
                     return Padding(
                       padding: const EdgeInsets.all(8),
                       child: Stack(
                         children: [
                           Card(child: ListTile(title: Text("${index+1}. "+snapshot.data![index].productName.toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold),),
                              subtitle: FutureBuilder<ProductCategory?>(
                                future: widget.categoryDao.getCategoryById(snapshot.data![index].categoryId),
                                builder: (context, snapshot) {
                                  if(snapshot.hasData){
                                  return Text("Category: "+snapshot.data!.categoryName.toUpperCase());
                                }
                                  else{
                                    return Center(child: CircularProgressIndicator());
                                  }
                                }
                              ),
                              trailing: Text(snapshot.data![index].price.toString()+"\$",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold),),
                           ),
                           ),
                           Padding(
                             padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/17,left:  MediaQuery.of(context).size.width/1.2),
                             child: IconButton(onPressed: () async {

                               await widget.productDao.deleteProductById(snapshot.data![index].productId!);
                               setState(() {

                               });

                               final snack = SnackBar(backgroundColor: Colors.pink,content: Text('Product Removed'),duration: Duration(seconds: 1),);
                               ScaffoldMessenger.of(context).showSnackBar(snack);

                             }, icon: Icon(Icons.delete,color: Colors.red,)),
                           )
                         ],
                       ),
                     );}

                   );}
                   }
                   else {
                     return Center(child: CircularProgressIndicator());
                   }
                 }
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(left: 25,top: 15),
             child: SizedBox(
               height: MediaQuery.of(context).size.height/16,width: MediaQuery.of(context).size.width,child: Text("List of Categories: ",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),),
           ),
           Padding(
             padding: const EdgeInsets.only(left: 8,right: 8),
             child: SizedBox(
               height: MediaQuery.of(context).size.height/3,width: MediaQuery.of(context).size.width,
               child: FutureBuilder<List<ProductCategory>>(
                   future: widget.categoryDao.getAllCategories(),
                   builder: (_, snapshot) {
                     if(snapshot.hasData){
                       catList = snapshot.data!;
                       if(catList.isEmpty){
                         return Center(child: CircularProgressIndicator());
                       }
                       else{
                       return ListView.builder(itemCount: snapshot.data!.length,itemBuilder: (context,index){
                         return Padding(
                           padding: const EdgeInsets.all(8),
                           child: Stack(
                             children: [
                               Card(child: ListTile(title: Text("${index+1}.  "+snapshot.data![index].categoryName.toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold),),
                               ),
                               ),
                               Padding(
                                 padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/25,left:  MediaQuery.of(context).size.width/1.2),
                                 child: IconButton(onPressed: () async {
                                    await widget.categoryDao.deleteCategoryById(snapshot.data![index].categoryId!);

                                   setState(() {

                                   });

                                   final snack = SnackBar(backgroundColor: Colors.pink,content: Text('Category Removed'),duration: Duration(seconds: 1),);
                                   ScaffoldMessenger.of(context).showSnackBar(snack);

                                 }, icon: Icon(Icons.delete,color: Colors.red,)),
                               )
                             ],
                           ),
                         );
                       }

                       );
                       }
                     }
                     else {
                       return Center(child: CircularProgressIndicator());
                     }
                   }
               ),
             ),
           ),
         ],

       ),
     )
   );
  }
}