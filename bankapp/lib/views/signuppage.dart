import 'package:bankapp/controllers/appvalidator.dart';
import 'package:bankapp/controllers/auth/authservices.dart';
import 'package:bankapp/views/loginpage.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _usernamecontroller = TextEditingController();

  TextEditingController _emailcontroller = TextEditingController();

  TextEditingController _passwordcontroller = TextEditingController();

  TextEditingController _phonecontroller = TextEditingController();

  var authService = AuthService();
  var isLoader = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      var data = {
        "username": _usernamecontroller.text,
        "email": _emailcontroller.text,
        "password": _passwordcontroller.text,
        "phone": _phonecontroller.text,
        'remainingAmount': 0,
        'totalCredit': 0,
        'totalDebit': 0,
      };
      await authService.createUser(data, context);

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
                          "Lets create an account for you",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.grey[200]),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            controller: _usernamecontroller,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration:
                                _DecoBox("Username", Icons.person_2_outlined),
                            validator: appValidator.validateUsername),
                        SizedBox(
                          height: 16.0,
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
                          controller: _phonecontroller,
                          keyboardType: TextInputType.phone,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration:
                              _DecoBox("Phone number", Icons.call_outlined),
                          validator: appValidator.validatePhoneNumber,
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
                                      "Register",
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
                                ("Already have an account?"),
                                style: TextStyle(
                                  color: Colors.grey[200],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                                child: Text(
                                  "Login now",
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
