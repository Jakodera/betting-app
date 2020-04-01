import 'package:flutter/material.dart';
import 'package:fun_app/services/auth/auth.dart';
import 'package:fun_app/services/auth/register_page.dart';
import 'package:fun_app/widgets/app_background.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _email;
  String _password;
  bool _obscure = false;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit(BuildContext context) async {
    if (validateAndSave()) {
      try {
        var auth = Provider.of<BaseAuth>(context, listen: false);
        await auth.signInWithEmailAndPassword(_email, _password);
      } catch (e) {
        print("Error $e");
        _showSnackBar();
      }
    }
  }

  _showSnackBar() {
    final snackBar = SnackBar(
      content: Text(
        "Wrong username or password!",
        style: TextStyle(fontSize: 16),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      buildEmailField(),
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
                      buildPasswordField(),
                      SizedBox(
                        height: 24,
                      ),
                      buildSubmitButton(context),
                    ],
                  ),
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
                      backgroundImage: AssetImage("assets/facebook.jpg"),
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage("assets/google.jpg"),
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
                    SizedBox(width: 8,),
                    GestureDetector(
                      child: Text(
                        "Sign Up!",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context, MaterialPageRoute(
                            builder: (context) => RegisterPage()
                          )
                        );
                      },
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

  Widget buildEmailField() {
    return TextFormField(
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
          )),
      validator: (value) => value.isEmpty ? "Email is not valid" : null,
      onSaved: (value) => _email = value,
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
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
          )),
      validator: (value) => value.isEmpty
          ? "Password is not valid"
          : value.length < 6 ? "Password is less than 6 chars long!" : null,
      onSaved: (value) => _password = value,
      obscureText: _obscure
    );
  }

  Widget buildSubmitButton(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 48,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(colors: [
            Colors.grey.withOpacity(0.65),
            Colors.grey.withOpacity(0.75),
          ], begin: Alignment.centerLeft, end: Alignment.centerRight),
        ),
        child: Center(
          child: Text(
            "Login",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      ),
      onTap: () => validateAndSubmit(context),
    );
  }
}
