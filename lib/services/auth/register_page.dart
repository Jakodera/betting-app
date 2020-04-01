import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fun_app/my_home_page.dart';
import 'package:fun_app/services/auth/auth.dart';
import 'package:fun_app/services/auth/login_page.dart';
import 'package:fun_app/widgets/app_background.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  String _username;
  String _userId;
  String _fileName;

  bool _obscure = true;

  File _image;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit(BuildContext context) async {
    try {
      var auth = Provider.of<BaseAuth>(context, listen: false);

      if (validateAndSave()) {
        await auth.createUserWithEmailAndPassword(_email, _password);
        _userId = await auth.currentUser();
        await auth.createData(_email, _password, _userId, _username, _fileName);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
        print("User id:$_userId");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<void> uplodadImage(BuildContext context) async {
    _fileName = _image.path;
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child("users");
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    print(taskSnapshot);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          AppBackground(),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Register",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.black,
                      child: ClipOval(
                        child: SizedBox(
                          width: 90,
                          height: 90,
                          child: (_image != null)
                              ? Image.file(_image, fit: BoxFit.cover)
                              : Image.asset("assets/milan.png",
                                  fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          "New avatar: ",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.camera,
                            size: 30,
                            color: Colors.grey,
                          ),
                          onPressed: getImage,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          prefixIcon: Icon(FontAwesomeIcons.chess,
                              color: Colors.grey, size: 18),
                          hintText: 'Username',
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 14),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        validator: (value) =>
                            value.isEmpty ? "Username is empty" : null,
                        onSaved: (value) => _username = value,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(FontAwesomeIcons.mailBulk,
                              color: Colors.grey, size: 18),
                          hintText: "Email",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) =>
                            value.isEmpty ? "Enter Email..." : null,
                        onSaved: (value) => _email = value,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            FontAwesomeIcons.userLock,
                            color: Colors.grey,
                            size: 18,
                          ),
                          suffixIcon: IconButton(
                            icon: _obscure
                                ? Icon(
                                    Icons.visibility_off,
                                    color: Colors.grey,
                                  )
                                : Icon(
                                    Icons.visibility,
                                    color: Colors.grey,
                                  ),
                            onPressed: () {
                              setState(() {
                                _obscure = !_obscure;
                              });
                            },
                          ),
                          hintText: "Password",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) => value.length < 6
                            ? "Password is too short! (6 chars min)"
                            : null,
                        onSaved: (value) => _password = value,
                        obscureText: _obscure,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    height: 54,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                          colors: [
                            Colors.grey.withOpacity(0.65),
                            Colors.grey.withOpacity(0.75),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                    ),
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () => validateAndSubmit(context),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Already have an Account?',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(width: 8,),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => LoginPage()
                          ));
                        },
                        child: Text(
                          'Sign In!', style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
