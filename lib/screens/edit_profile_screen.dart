import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app_design/dao/user_dao.dart';
import 'package:shopping_app_design/entity/user_entity.dart';

class EditProfile extends StatefulWidget{
  EditProfile(this.user,this.userDao);
  final User? user;
  final UserDao userDao;
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final formm_key = GlobalKey<FormState>();
  final editNameController = TextEditingController();
  final editEmailController = TextEditingController();
  final editPasswordController = TextEditingController();
  bool editName = false;
  bool editEmail = false;
  bool editPass = false;
  bool allowUpdate = false;
  @override
  void initState() {
    editNameController.text = widget.user!.userName;
    editEmailController.text = widget.user!.email;
    editPasswordController.text = widget.user!.password;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Colors.black54,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/11,MediaQuery.of(context).size.height/4,
              MediaQuery.of(context).size.width/11,0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/2,
            child: Form(
                key: formm_key,
                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Stack(
                          children: [
                            TextFormField(
                              enabled: !editName?false:true,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Field Cannot be empty";
                                  }
                                  else {
                                    return null;
                                  }
                                },
                                controller: editNameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Username',)),

                            Padding(
                              padding: EdgeInsets.only(top: 4,left:  MediaQuery.of(context).size.width/1.45),
                              child: IconButton(onPressed: (){
                                if(editName==false){
                                  editName = true;
                                }
                                else{
                                  editName = false;
                                }
                                setState(() {

                                });

                              }, icon: Icon(Icons.edit)),
                            )
                          ],
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Stack(
                          children: [
                            TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Field Cannot be empty";
                                  }
                                  else {
                                    return null;
                                  }
                                },
                              enabled:!editEmail?false:true,
                                controller: editEmailController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Email',)),
                            Padding(
                              padding: EdgeInsets.only(top: 4,left:  MediaQuery.of(context).size.width/1.45),
                              child: IconButton(onPressed: (){
                                if(editEmail==false){
                                  editEmail = true;
                                }
                                else{
                                  editEmail = false;
                                }
                                setState(() {

                                });


                              }, icon: Icon(Icons.edit)),
                            )
                          ],
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Stack(
                          children: [
                            TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Field Cannot be empty";
                                  }
                                  else {
                                    return null;
                                  }
                                },
                              enabled: !editPass?false:true,
                                controller: editPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Password',)),
                            Padding(
                              padding: EdgeInsets.only(top: 4,left:  MediaQuery.of(context).size.width/1.45),
                              child: IconButton(onPressed: (){
                                if(editPass==false){
                                  editPass = true;
                                }
                                else{
                                  editPass = false;
                                }
                                setState(() {

                                });

                              }, icon: Icon(Icons.edit)),
                            )
                          ],
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width/2.7,
                          child: ElevatedButton(style:ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.black)) ,onPressed: () async {
                            if(formm_key.currentState!.validate()){

                                if(editNameController.text==widget.user!.userName && editPasswordController.text==widget.user!.password && editEmailController.text==widget.user!.email){
                                  allowUpdate = false;
                                }
                                else{
                                  allowUpdate = true;
                                widget.userDao.updateUser(User(userId:widget.user!.userId,email:editEmailController.text,userName: editNameController.text,password: editPasswordController.text));
                              showDialog(
                                  context: context,
                                  builder: allowUpdate?(BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Success"),
                                      content: SingleChildScrollView(child:
                                      Text("Successfully Updated",style: TextStyle(color: Colors.blue),)),actions: [
                                      TextButton(onPressed: (){Navigator.of(context).pop();
                                      }, child: Text("OK"))
                                    ],);


                                  }:(BuildContext context){
                                    return AlertDialog(
                                      title: const Text("Success"),
                                      content: SingleChildScrollView(child:
                                      Text("Same Values Entered!",style: TextStyle(color: Colors.blue),)),actions: [
                                      TextButton(onPressed: (){Navigator.of(context).pop();
                                      }, child: Text("OK"))
                                    ],);

                                  });
    }}

                          setState(() {

                          });
                          }

                             // editNameController.clear();
                             // editPasswordController.clear();
                             // editEmailController.clear();


                            ,child: const Text("Update", style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17
                              ),)),
                        ),
                      )


                    ],
                  ),
                )


            ),
              ),
          ),
        ),
      ),
    );
  }
}