import 'package:flutter/material.dart';
import 'package:shopping_app_design/database.dart';
import 'package:shopping_app_design/screens/register_screen.dart';

import 'admin_screens/admin_panel.dart';
import 'main.dart';

void main() {
  runApp(
    const LoginScreen()
  );
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFFFFFFF)),
        home: FutureBuilder<AppDatabase>(future: $FloorAppDatabase.databaseBuilder('app_database').build(),builder:(context,data){
            if(data.hasData){
              return Login(database: data.data);
            }
            else if(data.hasError){
              return const Text("Error Occurred");
            }
            else{
              return const Center(child: CircularProgressIndicator());
            }
        }
        ),
            );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key,required this.database}) : super(key: key);
  final AppDatabase? database;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login Screen",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),),
          backgroundColor: Colors.black54
        ),
        body: Padding(
          padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/15,left: MediaQuery.of(context).size.width/8,right: MediaQuery.of(context).size.width/8),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TextFormField(
                              style: const TextStyle(fontStyle: FontStyle.italic),

                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Fields Cannot be empty";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: userNameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Username',
                                ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TextFormField(
                                style: const TextStyle(fontStyle: FontStyle.italic),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Fields Cannot be empty";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Password',
                                )),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width/2.9,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black)),
                                      onPressed: () async {
                                        List<String> catList = [];
                                       final result = await widget.database!.userDao.getRegisteredUser(userNameController.text, passwordController.text);
                                       final categories = await widget.database!.categoryDao.getAllCategories();
                                       for (int i = 0; i < categories.length; i++) {
                                         catList.add(categories[i].categoryName);
                                       }
                                        if (formKey.currentState!.validate()) {
                                            if(result==null&&!isAdmin()){
                                               showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                return AlertDialog(
                                                title: const Text("Incorrect Username or Password"),
                                                content: const SingleChildScrollView(child:
                                                Text("Please Enter Correct Username or Password",style: TextStyle(color: Colors.red),)),actions: [
                                                  TextButton(onPressed: (){Navigator.of(context).pop();}, child: const Text("OK"))
                                                ],);
                                            });}
                                            else if(isAdmin()){
                                              Navigator.push(
                                                       context,
                                                       MaterialPageRoute(
                                                           builder: (context) =>
                                                              AdminPanel(categoryDao: widget.database!.categoryDao,userDao: widget.database!.userDao,productDao: widget.database!.productDao, title: 'Welcome admin_screens',)),
                                                     );
                                              userNameController.clear(); passwordController.clear();
                                            }
                                            else{
                                              Navigator.push(
                                                       context,
                                                       MaterialPageRoute(builder: (context) =>   MyHomePage(categoryDao: widget.database!.categoryDao,productDao: widget.database!.productDao,userDao: widget.database!.userDao,myCatList: catList,user: result,cartDao: widget.database!.cartDao,favDao: widget.database!.favouriteDao, title: 'Welcome',)),
                                                     );
                                              userNameController.clear(); passwordController.clear();
                                            }

                                        }
                                      },
                                      child: const Text(
                                        "Login",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width/2.9,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black)),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                   Register(userDao: widget.database!.userDao)),
                                        );
                                      },
                                      child: const Text("Register Now",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold))),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
          ),
        ));
  }



  bool isAdmin() {
    if (userNameController.text == 'admin' &&
        passwordController.text == 'admin') {
      return true;
    } else {
      return false;
    }
  }
}
