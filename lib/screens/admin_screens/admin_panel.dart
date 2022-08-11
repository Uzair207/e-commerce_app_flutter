import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app_design/dao/category_dao.dart';
import 'package:shopping_app_design/dao/product_dao.dart';
import 'package:shopping_app_design/dao/user_dao.dart';
import 'package:shopping_app_design/entity/category_entity.dart';
import 'package:shopping_app_design/screens/admin_screens/add-products_screen.dart';
import 'package:shopping_app_design/screens/admin_screens/view_products_screen.dart';

import 'add-products_screen.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel(
      {Key? key,
      required this.title,
      required this.categoryDao,
      required this.userDao,
      required this.productDao})
      : super(key: key);
  final String title;
  final CategoryDao categoryDao;
  final UserDao userDao;
  final ProductDao productDao;

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final nameController = TextEditingController();
  final catFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome Admin"),
        backgroundColor: Colors.black54,
      ),
      body: Form(
        key: catFormKey,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Add Categories"),
                          content: SingleChildScrollView(
                            child: Column(children: <Widget>[
                              TextFormField(
                                validator: (value){if(value!.isEmpty){
                                  return "Field Cannot be Empty";
                                }
                                else{
                                  return null;
                                }
    },
                                controller: nameController,
                                decoration: const InputDecoration(
                                    hintText: 'Enter Category Name'),
                              ),
                            ]),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  final prevCatResult = await widget.categoryDao.getCategoryByName(nameController.text);
                                  if(catFormKey.currentState!.validate()) {
                                    if(prevCatResult==null) {
                                      Navigator.of(context).pop();
                                      await widget.categoryDao.addCategory(
                                          ProductCategory(
                                              categoryName: nameController
                                                  .text));
                                      if (kDebugMode) {
                                        print("Success added new Category");
                                      }
    showDialog(context: context, builder: (BuildContext context){
    return AlertDialog(
    title: const Text("Success"),
    content: SingleChildScrollView(child:
    Text("Successfully Added!",style: TextStyle(color: Colors.blue),)),actions: [
    TextButton(onPressed: (){Navigator.of(context).pop();
   }, child: Text("OK"))
    ],);});


                                    }
                                    else{
                                      Navigator.of(context).pop();
                                      showDialog(context: context, builder: (BuildContext context){
                                        return AlertDialog(
                                          title: const Text("Already Exists"),
                                          content: SingleChildScrollView(child:
                                          Text("Category with this name already exists",style: TextStyle(color: Colors.red),)),actions: [
                                          TextButton(onPressed: (){Navigator.of(context).pop();
                                          }, child: Text("OK"))
                                        ],);});
                                    }
                                    nameController.clear();
                                  }
                                  },
                                child: const Text("Add"))
                          ],
                        );
                      });
                },
                child: const Text("Add Categories"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    textStyle: MaterialStateProperty.all(const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )))),
            ElevatedButton(
                onPressed: () async {
                  var firstValue;
                  final categories = await widget.categoryDao.getAllCategories();
                  List<String> list = [];
                  for (int i = 0; i < categories.length; i++) {
                    list.add(categories.elementAt(i).categoryName);
                    if(i==0){
                      firstValue = categories.elementAt(i).categoryName;
                    }
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddProductsScreen(
                              productDao: widget.productDao,
                              list: list,
                              firstValue: firstValue,
                              categoryDao: widget.categoryDao,
                            )),
                  );
                },
                child: const Text("Add Products"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                    textStyle: MaterialStateProperty.all(const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )))),


            ElevatedButton(onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => ViewProductScreen(widget.productDao,widget.categoryDao)));

            },
                child: const Text("View Products"),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.pink),
              textStyle: MaterialStateProperty.all(const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )))),



          ],
        )),
      ),
    );
  }
}
