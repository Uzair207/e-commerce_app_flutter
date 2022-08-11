
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app_design/dao/user_dao.dart';
import 'package:shopping_app_design/entity/user_entity.dart';

class Register extends StatefulWidget{
  const Register({Key? key,required this.userDao}) : super(key: key);
  final UserDao userDao;
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formkey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final captchaController = TextEditingController();
  var randomString = "";
  String captcha = "";
  @override
  void initState() {

    captcha = doCaptchaBackgroundStuff();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(

          appBar: AppBar(
            backgroundColor: Colors.black54,

            title: const Text('Register Yourself',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
          ),
          body: Center(
            child: Form(
                        key: formkey,
                        child: SingleChildScrollView(
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 50.0, right: 50.0, bottom: 10),
                                child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Fields Cannot be empty";
                                      }
                                      else {
                                        return null;
                                      }
                                    },
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Username',)),
                              ),


                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 50.0, right: 50.0, bottom: 10),
                                child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Fields Cannot be empty";
                                      }
                                      else {
                                        return null;
                                      }
                                    },
                                    controller: emailController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Email',)),
                              ),


                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 50.0, right: 50.0, bottom: 10),
                                child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Fields Cannot be empty";
                                      }
                                      else {
                                        return null;
                                      }
                                    },
                                    controller: passwordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Password',)),
                              ),

                              Container(margin: EdgeInsets.only(top: 20),
                                child: Row(crossAxisAlignment: CrossAxisAlignment.end,mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 180,child: TextFormField(
                                      controller: captchaController,
                                      validator: (code){if(verifyHuman(code!)==false){
                                        return "Not Human";
                                      }
                                      else{
                                        return null;
                                      }
    },
                                      decoration: InputDecoration(hintText: "Enter Captcha Code"),)),

                                    Container(padding: EdgeInsets.only(left: 20),width: 100,margin: EdgeInsets.only(left: 20),decoration: BoxDecoration(border: Border.all(color: Colors.black)),child: Text(captcha,style: TextStyle(
                                    color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20,fontStyle: FontStyle.italic
                                  ),))],),
                              ),




                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: SizedBox(
                                  width: 150,
                                  child: ElevatedButton(style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black)),
                                      onPressed: () async {
                                    User user = User(userName:nameController.text, email:emailController.text,
                                        password:passwordController.text);
                                    final userrr = await widget.userDao.getRegisteredUser(user.userName,user.password);
                                    if (formkey.currentState!.validate()) {
                                      if(userrr!=null){
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("Error"),
                                                content: SingleChildScrollView(child:
                                                Text("User Already Exists",style: TextStyle(color: Colors.red),)),actions: [
                                                TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("OK"))
                                              ],);
                                            });
                                      }
                                      else {
                                        await widget.userDao.addUser(user);
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("Success"),
                                                content: SingleChildScrollView(child:
                                                Text("Successfully Registered",style: TextStyle(color: Colors.blue),)),actions: [
                                                TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("OK"))
                                              ],);
                                            });

                                        if (kDebugMode) {
                                          print("Registered Successfully");
                                        }
                                        else{
                                          if (kDebugMode) {
                                            print("Error");
                                          }
                                        }

                                      }
                                      nameController.clear();
                                      passwordController.clear();
                                      emailController.clear();
                                      captchaController.clear();


                                  }
                                    }
                                      , child: const Text("Register", style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 17
                                      ),)),
                                ),
                              )


                            ],
                          ),
                        )


                    ),
          )

              ),
    );
  }


  String doCaptchaBackgroundStuff(){
    var randomTempString = "";
    Random random = new Random();

    for(int i=0;i<4;i++){
      int randomNumber = 65+ random.nextInt(91-65);
      int number = 48 + random.nextInt(57-48);
      String char = String.fromCharCode(randomNumber);
      String num = String.fromCharCode(number);
      randomTempString+= char;
      randomTempString+=num;
    }
    for(int i=0;i<4;i++) {
      int index = random.nextInt(randomTempString.length);
      randomString+=randomTempString[index];
    }
    setState(() {

    });
    return randomString;
  }
  bool verifyHuman(String code){
    if(randomString==code){
      return true;
    }
    else{
      return false;
    }
  }


}