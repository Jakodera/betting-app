import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fun_app/blocs/login/login_bloc.dart';
import 'package:fun_app/services/auth/auth_widget_builder.dart';
import 'package:fun_app/services/auth/register_page.dart';
import 'package:fun_app/services/repositories/user_auth_repository.dart';
import 'package:fun_app/widgets/app_background.dart';
import 'package:fun_app/widgets/splash_screen.dart';

class LoginPageParent extends StatelessWidget {
  final FirebaseUserAuth userAuth;

  const LoginPageParent({Key key, this.userAuth}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(userAuth: userAuth),
      child: LoginPage(
        userAuth: userAuth,
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  final FirebaseUserAuth userAuth;

  const LoginPage({Key key, this.userAuth}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailCntrl = TextEditingController();
  TextEditingController pwdCntrl = TextEditingController();

  bool _obscure = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: BlocProvider.of<LoginBloc>(context),
      listener: (context, state) {
        if (state is LoginLoaded) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AuthWidgetBuilder(
                userId: state.user.uid,
                userAuth: widget.userAuth,
              ),
            ),
          );
        } else if (state is LoginError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is LoginInitial) {
          return _initialData(context);
        } else if (state is LoginLoading) {
          return SplashScreen();
        } else if (state is LoginLoaded) {
          return Container();
        }
        return SizedBox();
      },
    );
  }

  Widget _initialData(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          AppBackground(),
          SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 80),
            child: Column(
              children: <Widget>[
                Text(
                  "Sign In",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: emailCntrl,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter your Email",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Password",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                        controller: pwdCntrl,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter your Password",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
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
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.grey,
                          ),
                        ),
                        obscureText: _obscure),
                    SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      child: Container(
                        height: 48,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                              colors: [
                                Colors.grey.withOpacity(0.65),
                                Colors.grey.withOpacity(0.75),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight),
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ),
                      ),
                      onTap: () {
                        BlocProvider.of<LoginBloc>(context).add(
                            LoginButtonPressed(emailCntrl.text, pwdCntrl.text));
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "- OR -",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Sign in with",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage("assets/images/facebook.jpg"),
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage("assets/images/google.jpg"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Don't have an Account?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      child: Text(
                        "Sign Up!",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      onTap: () =>
                          _navigateToSignUpParent(context, widget.userAuth),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _navigateToSignUpParent(
      BuildContext context, FirebaseUserAuth userAuth) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegisterPageParent(
          userAuth: userAuth,
        ),
      ),
    );
  }
}
