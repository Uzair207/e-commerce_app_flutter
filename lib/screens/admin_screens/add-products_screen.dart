
import 'package:flutter/material.dart';
import 'package:shopping_app_design/dao/category_dao.dart';
import 'package:shopping_app_design/dao/product_dao.dart';
import 'package:shopping_app_design/entity/products_entity.dart';


class AddProductsScreen extends StatefulWidget{
  AddProductsScreen({Key? key, required this.productDao,required this.list,required this.firstValue,required this.categoryDao}) : super(key: key);
  final ProductDao productDao;
  final CategoryDao categoryDao;
  List<String> list;
  var firstValue;
  @override
  State<AddProductsScreen> createState() => _AddProductsScreenState();
}

class _AddProductsScreenState extends State<AddProductsScreen> {
  final prodNameController = TextEditingController();
  final prodPriceController = TextEditingController();
  final prodDiscountController = TextEditingController();
  String dropDownValue = "";
  final form_key = GlobalKey<FormState>();

  @override
  void initState() {


   if(widget.list.isNotEmpty){
     dropDownValue = widget.list.first;
   }
    // TODO: implement initState
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    if(widget.list.isEmpty){
      dropDownValue = "";
    }
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black54,
          title: const Text("Add New Products"),
        ),

        body: Center(
          child: Form(
            key: form_key,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: SizedBox(
                height: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50.0,right: 50.0),
                          child: TextFormField(
                            validator: (value){
                              if(_isNumeric(value!)==true||value.isEmpty){
                                return "Enter Valid Product Name";
                              }
                              else{
                                return null;
                              }
                            },
                            controller: prodNameController,
                            decoration: const InputDecoration(hintText: 'Enter Product Name'),),
                        ),
                      ),
                      Container(margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50,right: 50),
                          child: TextFormField(
                            validator: (value){
                              if(_isNumeric(value!)==false){
                                  return "Enter Valid Price";
                              }
                              else{
                                return null;
                              }
                            },
                            controller: prodPriceController,
                            decoration: const InputDecoration(hintText: 'Enter Product Price'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 40),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50,right: 50),
                          child: TextFormField(
                            validator: (value){
                              if(_isNumeric(value!)==false){
                                return "Enter Valid Discount";
                              }
                              else{
                                return null;
                              }
                            },
                            controller: prodDiscountController,
                            decoration: const InputDecoration(hintText: 'Enter Discount'),
                          keyboardType: TextInputType.number,),
                        ),
                      ),



                      SizedBox(
                        width: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Category",style: TextStyle(fontSize: 15),),
                            Container(margin: const EdgeInsets.only(top: 8),
                              child: DropdownButton(value: dropDownValue,isExpanded: true,
                                icon: const Icon(Icons.keyboard_arrow_down),items: widget.list.map((String items){
                                  return DropdownMenuItem(
                                      value: items,
                                      child: Text(items)
                                  );}
                                ).toList(), onChanged: (String? newValue){
                                  setState(() {
                                    dropDownValue = newValue!;
                                  });
                                },),
                            ),
                          ],
                        ),
                      ),
      Container(margin: const EdgeInsets.only(top: 20),
      child: ElevatedButton(style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black)),
      onPressed: () async {

                    final prodCategory = await widget.categoryDao.getCategoryByName(dropDownValue);
                    if(prodCategory==null){showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(title: const Text("Error"),content: const SingleChildScrollView(child:
    Text("Add a Category",style: TextStyle(color: Colors.red),)),
                        
                        
                        actions: [
    
      TextButton(onPressed: (){Navigator.of(context).pop();}, child: const Text("OK"),)],);
                      });}
                    final prevProduct = await widget.productDao.getProductByNameAndCat(prodNameController.text, prodCategory!.categoryId!);

                    if(form_key.currentState!.validate()) {
                    Product p = Product(productName: prodNameController.text,
                        price: int.parse(prodPriceController.text),categoryId: prodCategory.categoryId!,discount: int.parse(prodDiscountController.text));

                    if(prevProduct==null){
                    await widget.productDao.addProduct(p);
                    showDialog(context: context, builder: (BuildContext context){
                    return AlertDialog(
                      title: const Text("Success"),
                      content: const SingleChildScrollView(child:
                      Text("Successfully Added",style: TextStyle(color: Colors.blue),)),actions: [
                      TextButton(onPressed: (){Navigator.of(context).pop();
                      prodNameController.clear();prodPriceController.clear();prodDiscountController.clear();}, child: const Text("OK"))
                    ],);});
                    }
                    else{
                      showDialog(context: context, builder: (BuildContext context){
                        return AlertDialog(
                          title: const Text("Already Exists"),
                          content: const SingleChildScrollView(child:
                          Text("Product with this name and category already exists",style: TextStyle(color: Colors.red),)),actions: [
                          TextButton(onPressed: (){Navigator.of(context).pop();
                          prodNameController.clear();prodPriceController.clear();prodDiscountController.clear();}, child: const Text("OK"))
                        ],);});
                    }

                  }
      },
                child: const Text("Add Product"),))

                    ]),
              ),
            ),
          ),
        ),
      ),
    );

  }
  bool _isNumeric(String result) {
    if (result.isEmpty) {
      return false;
    }
    return double.tryParse(result) != null;
  }
}