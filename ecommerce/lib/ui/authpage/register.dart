import 'package:ecommerce/ui/authpage/login.dart';
import 'package:ecommerce/ui/homepage/isipulsa_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:async';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? confirmPassword;
  bool _isLoading = false;
  bool _isComplete = false;
  String _message = '';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confimPasswordController = TextEditingController();

  Future<void> _registerUser() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      final api = dotenv.env['URL'] ?? '';
      String url = '${api}/api/register';

      final response = await http.post(
        (Uri.parse(url)),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        }),
      );
      if (response.statusCode == 201) {
        setState(() {
          _message = 'Registration successful!';
          _isComplete = true;
        });
        // Show success message for 3 seconds
        Timer(Duration(seconds: 1), () {
          setState(() {
            _message = '';
            _isComplete = false;
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        });
      } else {
        setState(() {
          _message = response.body;
          _isComplete = true;
        });

        Timer(Duration(seconds: 1), () {
          setState(() {
            _message = '';
            _isComplete = false;
          });
        });
      }
    } catch (e) {
      print('Error: $e');

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
          title: Text("Register"),
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
              if (!_isLoading && _isComplete && _message.isNotEmpty)
                Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(_message),
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
                            child: _textBoxConfirmPassword(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: _registerButton(),
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

  Widget _textBoxPassword() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password',
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

  Widget _textBoxConfirmPassword() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Email',
          floatingLabelBehavior: FloatingLabelBehavior.always),
      controller: _confimPasswordController,
      onSaved: (value) {
        confirmPassword = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the email address';
        }
        return null;
      },
    );
  }

  Widget _registerButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              _registerUser();
            }
          },
          child: Text('Register'),
        ),
      ),
    );
  }
}
