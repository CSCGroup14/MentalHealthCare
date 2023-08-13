import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentalhealthcare/MainPage.dart';
import 'package:mentalhealthcare/SignUpPage.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final User? user = Auth().currentUser;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = true;

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const MainPage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
     

      if (e.code == 'user-not-found') {
        
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.code)),
      );

      } else if (e.code == 'wrong-password') {
        
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.code)),
      );
      } else {
        
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.code)),
      );
        
      }

     
    
      });
    }
  }
  void _toggleVisibility() {
    setState(() {
        _passwordVisible = !_passwordVisible;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Login Page"))),
      body: Card(
        elevation: 20,
        child: Center(
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  Image.asset(
             'assets/mental1.jpg',
              width: 100,
              height: 100,
            fit: BoxFit.fitHeight,
            scale:1.0,
             ),
                  
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                           prefixIcon: Icon(Icons.email),
            
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                        
                       obscureText:_passwordVisible ? true:false,
                       decoration:  InputDecoration(
                       suffixIcon: IconButton(
                        icon: Icon(
                              _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: _toggleVisibility,
                      ),
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        labelText: 'Password',
                        
        
                      ),
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        return null;
                      },
                      
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //forgot password screen
                    },
                    child: const Text(
                      'Forgot Password',
                    ),
                  ),
                  Container(
                    
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                         style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                        child: const Text('Login',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                        onPressed: () {
                          signInWithEmailAndPassword();
                        },
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Does not have account?'),
                      TextButton(
                        child: const Text(
                          'Sign up',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () async {
                          //signup screen
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
              ),
        ),
      ),
    );
  }
}
