import 'dart:convert';

import 'package:ecommerce/ui/user/form_data.dart';
import 'package:ecommerce/utils/api/register.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class RegisterPageSeller extends StatefulWidget {
  const RegisterPageSeller({super.key});

  @override
  State<RegisterPageSeller> createState() => _RegisterPageSellerState();
}

class _RegisterPageSellerState extends State<RegisterPageSeller> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? namaToko;
  String? password;
  String? confirmPassword;
  bool _isLoading = false;
  bool _isComplete = false;
  String _message = '';

  final _emailController = TextEditingController();
  final _namaTokoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confimPasswordController = TextEditingController();

  Future<void> _registerUser() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });
    String result =
        await registerUser(email!, password!, confirmPassword!, true, namaToko);
    final response = jsonDecode(result);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', response['id']);

    setState(() {
      _message = response['detail'];
      _isComplete = true;
    });

    // Show success message for 3 seconds
    Timer(Duration(seconds: 1), () {
      setState(() {
        _message = '';
        _isComplete = false;
      });
      if (response['status'] == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FormDataUser()),
        );
      }
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Register Seller'),
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
                            child: _textBoxNamaToko(),
                          ),
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

  Widget _textBoxNamaToko() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Nama Toko',
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      controller: _namaTokoController,
      onSaved: (value) {
        namaToko = value;
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
