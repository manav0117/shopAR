import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com/authentication/login_page.dart';
import 'package:e_com/model/user_model.dart';
import 'package:e_com/widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = "sign-up";
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final paassword = TextEditingController();
  bool loading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    paassword.dispose();
  }

  void register() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: paassword.text);
      Navigator.pushNamed(context, LoginScreen.id);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter name';
                        }
                      },
                      decoration: const InputDecoration(
                          hintText: 'Name',
                          helperText: 'Enter name e.g Jhon',
                          prefixIcon: Icon(Icons.person)),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter phonenumber';
                        }
                      },
                      decoration: const InputDecoration(
                          hintText: 'Phone Number',
                          helperText: 'Enter phone number e.g 91XXXXXXXXXX',
                          prefixIcon: Icon(Icons.numbers)),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      validator: (value) {
                        if (!value!.contains('@') && value.isNotEmpty) {
                          return 'Enter valid Email';
                        }
                        if (value.isEmpty) {
                          return 'Enter email';
                        }
                      },
                      decoration: const InputDecoration(
                          hintText: 'Email',
                          helperText: 'Enter email e.g 123@gmail.com',
                          prefixIcon: Icon(Icons.alternate_email)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: paassword,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter password';
                        }
                      },
                      decoration: const InputDecoration(
                          hintText: 'Password',
                          helperText: 'Enter strong password',
                          prefixIcon: Icon(Icons.lock_open)),
                    ),
                  ],
                )),
            SizedBox(
              height: 30,
            ),
            RoundButton(
              title: 'Sign up',
              loading: loading,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    loading = true;
                  });
                  register();
                  setState(() {
                    loading = false;
                  });
                  saveToDataBase();
                }
              },
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginScreen();
                      }));
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.deepPurple),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  saveToDataBase() async {
    final CollectionReference vendors =
        FirebaseFirestore.instance.collection('vendors');

    Users users = Users(
        name: nameController.text.toString(),
        phoneNumber: phoneController.text.toString(),
        email: emailController.text.toString(),
        password: paassword.text.toString());
    final jsonData = users.toJson();
    await vendors.add(jsonData);
  }
}
