import 'package:ecommerce/home_page copy.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
      final api = dotenv.env['URL'] ?? '';
      String url = '$api/api/login';

      final response = await http.post(
        (Uri.parse(url)),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];
        final userId = responseData['id'];

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
                  builder: (context) => HomePage(
                        token: token,
                      )));
        });
      } else {
        setState(() {
          _message = 'Login failed';
        });
        Timer(Duration(seconds: 1), () {
          setState(() {
            _message = '';
          });
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _message = 'An error occurred. Please check your internet connection.';
      });
      Timer(Duration(seconds: 1), () {
        setState(() {
          _message = '';
        });
      });
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
          title: Text('Login'),
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
      child: RichText(
        text: TextSpan(
          text: 'Belum Punya Akun? ',
          style: TextStyle(color: Colors.black),
          children: <TextSpan>[
            TextSpan(
                text: 'Register',
                style: TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
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
    );
  }

  Widget _textBoxPassword() {
    return TextFormField(
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
