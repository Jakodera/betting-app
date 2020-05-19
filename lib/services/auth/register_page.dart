import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fun_app/blocs/registration/registration_bloc.dart';
import 'package:fun_app/services/auth/login_page.dart';
import 'package:fun_app/services/repositories/user_auth_repository.dart';
import 'package:fun_app/widgets/app_background.dart';
import 'package:fun_app/widgets/splash_screen.dart';
import 'package:path/path.dart';

import '../../main.dart';

class RegisterPageParent extends StatelessWidget {
  final FirebaseUserAuth userAuth;

  const RegisterPageParent({Key key, @required this.userAuth})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegistrationBloc(userAuth: userAuth),
      child: RegisterPage(
        userAuth: userAuth,
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  final FirebaseUserAuth userAuth;

  RegisterPage({this.userAuth});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  File _imagePath;

  bool _obscure = true;

  TextEditingController emailCntrl = TextEditingController();
  TextEditingController pwdCntrl = TextEditingController();
  TextEditingController uNameCntrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: BlocProvider.of<RegistrationBloc>(context),
      listener: (context, state) {
        if (state is RegistrationError) {
          print(state.message);
        } else if (state is RegistrationLoaded) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyApp(),
            ),
          );
        }
      },
      builder: (context, state) {
        print(state);
        if (state is RegistrationInitial) {
          return _initialData(context);
        } else if (state is RegistrationLoading) {
          return SplashScreen();
        } else if (state is RegistrationLoaded) {
          return Container();
        } else
          return Center(child: Text("Error"));
      },
    );
  }

  Widget _initialData(BuildContext context) {
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
                            child: (_imagePath != null)
                                ? Image.file(
                                    _imagePath,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset("assets/images/milan.png",
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
                            "Choose avatar: ",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          IconButton(
                            icon: Icon(
                              FontAwesomeIcons.camera,
                              size: 30,
                              color: Colors.grey,
                            ),
                            onPressed: () async {
                              _imagePath = await widget.userAuth.getImage();
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: <Widget>[
                      TextField(
                        controller: uNameCntrl,
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
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: emailCntrl,
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
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: pwdCntrl,
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
                      ),
                    ],
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
                    onTap: () => {
                      print(emailCntrl.text),
                      print(pwdCntrl.text),
                      print(uNameCntrl.text),
                      _imagePath == null
                          ? BlocProvider.of<RegistrationBloc>(context).add(
                              RegisterButtonPressed(
                                email: emailCntrl.text,
                                password: pwdCntrl.text,
                                username: uNameCntrl.text,
                              ),
                            )
                          : BlocProvider.of<RegistrationBloc>(context).add(
                              RegisterButtonPressed(
                                  email: emailCntrl.text,
                                  password: pwdCntrl.text,
                                  username: uNameCntrl.text,
                                  fileName: basename(_imagePath.path),
                                  imageName: _imagePath),
                            ),
                    },
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
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () =>
                            _navigateToSignInParent(context, widget.userAuth),
                        child: Text(
                          'Sign In!',
                          style: TextStyle(
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

  void _navigateToSignInParent(
      BuildContext context, FirebaseUserAuth userAuth) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoginPageParent(
          userAuth: userAuth,
        ),
      ),
    );
  }
}
