import 'package:e_com/authentication/signup_page.dart';
import 'package:e_com/pages/main_screen.dart';
import 'package:e_com/widget/round_button.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  final paassword = TextEditingController();
  bool loading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoggedIn = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    paassword.dispose();
  }

  login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: paassword.text);
      setState(() {
        isLoggedIn = true;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // SignInScreen(providerConfigs: [EmailProviderConfiguration()]);

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
            title: 'Login ',
            loading: loading,
            onTap: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  loading = true;
                });
                login();
                if (isLoggedIn == true) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MainScreen();
                  }));
                }
                setState(() {
                  loading = false;
                  isLoggedIn = false;
                });
              }
            },
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Dont't have an account?"),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SignUpScreen();
                    }));
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.deepPurple),
                  ))
            ],
          )
        ],
      ),
    ));
  }
}
