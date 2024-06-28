import 'package:ecommerce/ui/authpage/login_seller.dart';
import 'package:ecommerce/ui/main_screen.dart';
import 'package:ecommerce/utils/api/login.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:async';
import 'package:ecommerce/ui/authpage/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool _isLoading = false;
  String? _message;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final result = await loginUser(email!, password!, false);

      if (result['success']) {
        final token = result['token'];
        final userId = result['userId'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);

        _message = 'Login successful';

        Timer(Duration(milliseconds: 15), () {
          setState(() {
            _message = '';
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreen(
                        token: token,
                      )));
        });
      } else {
        setState(() {
          _message = 'Email atau Password Salah';
        });

        Timer(Duration(seconds: 3), () {
          setState(() {
            _message = '';
          });
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login User'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Stack(
            children: [
              if (_isLoading)
                Center(
                  child: LoadingAnimationWidget.twistingDots(
                    leftDotColor: const Color(0xFF1A1A3F),
                    rightDotColor: const Color(0xFFEA3799),
                    size: 50,
                  ),
                ),
              if (_message != null)
                Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(_message!),
                    ),
                  ),
                ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: _textBoxEmail(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: _textBoxPassword(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: _registerRedirect(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: _loginButton(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget _textBoxEmail() {
    return TextFormField(
      key: Key('emailField'),
      decoration: InputDecoration(
        labelText: 'Email',
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      controller: _emailController,
      onSaved: (value) {
        email = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the email address';
        }
        return null;
      },
    );
  }

  Widget _registerRedirect() {
    return Center(
      child: Column(
        children: [
          RichText(
            key: Key('registerRichText'),
            text: TextSpan(
              text: 'Belum Punya Akun? ',
              style: TextStyle(color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: 'Register',
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()));
                      }),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Login sebagai seller? ',
              style: TextStyle(color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: 'Login',
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPageSeller()));
                      }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _textBoxPassword() {
    return TextFormField(
      key: Key('passField'),
      decoration: InputDecoration(
          labelText: 'Email',
          floatingLabelBehavior: FloatingLabelBehavior.always),
      controller: _passwordController,
      onSaved: (value) {
        password = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the email address';
        }
        return null;
      },
    );
  }

  Widget _loginButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: ElevatedButton(
          key: Key('button'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              _loginUser();
            }
          },
          child: Text('Login'),
        ),
      ),
    );
  }
}
