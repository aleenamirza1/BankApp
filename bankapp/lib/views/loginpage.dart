import 'package:bankapp/controllers/appvalidator.dart';
import 'package:bankapp/controllers/auth/authservices.dart';
import 'package:bankapp/views/signuppage.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _emailcontroller = TextEditingController();

  TextEditingController _passwordcontroller = TextEditingController();
  var isLoader = false;
  var authService = AuthService();
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      var data = {
        "email": _emailcontroller.text,
        "password": _passwordcontroller.text,
      };
      await authService.login(data, context);

      setState(() {
        isLoader = false;
      });
    }
  }

  var appValidator = AppValidator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Color.fromARGB(135, 37, 37, 38),
                  Color.fromARGB(245, 69, 69, 72)
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topRight,
              ),
            ),
            child: SafeArea(
                child: Center(
                    child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 25.0,
                  vertical: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: 150,
                        ),
                        Text(
                          "Login to your account",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.grey[200]),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _emailcontroller,
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: _DecoBox("Email", Icons.email_outlined),
                          validator: appValidator.validateEmail,
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        TextFormField(
                          controller: _passwordcontroller,
                          keyboardType: TextInputType.visiblePassword,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: _DecoBox("Password", Icons.lock_outline),
                          validator: appValidator.validatePassword,
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(9))),
                              onPressed: () {
                                isLoader ? print("Loading") : _submitForm();
                              },
                              child: isLoader
                                  ? Center(child: CircularProgressIndicator())
                                  : Text(
                                      "Login",
                                      style: TextStyle(color: Colors.black),
                                    )),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                ("Don't have an account"),
                                style: TextStyle(
                                  color: Colors.grey[200],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUpPage()));
                                },
                                child: Text(
                                  "Register now",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              )
                            ])
                      ],
                    )),
              ),
            )))));
  }

  InputDecoration _DecoBox(String label, IconData Suffixicon) {
    return InputDecoration(
        fillColor: Color.fromARGB(98, 137, 144, 172),
        filled: true,
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade800)),
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade300),
        suffixIcon: Icon(
          Suffixicon,
          color: Colors.grey.shade300,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ));
  }
}
