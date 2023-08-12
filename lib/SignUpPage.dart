// ignore: file_names
import 'dart:io';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentalhealthcare/LoginPage.dart';
import 'auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  File? _image;
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  Future<void> _getImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _saveDataToFirestore() async {
    if (_formKey.currentState!.validate()) {
      // Save the profile picture to Firebase Storage
      String imageUrl = '';
      if (_image != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_pics')
            .child('${DateTime.now()}.png');
        final uploadTask = ref.putFile(_image!);
        await uploadTask.whenComplete(() async {
          imageUrl = await ref.getDownloadURL();
        });
      }

      // Save the other fields to Cloud Firestore
      String username = _usernameController.text;
      String email = _emailController.text;
      final currentUser = FirebaseAuth.instance.currentUser;
      final userData = {
        'username': username,
        'email': email,
        'profile_pic': imageUrl,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .set(userData);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile data saved successfully')),
      );
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          const SnackBar(content: Text('The password provided is too weak.'));

        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          const SnackBar(content: Text('The account already exists for that email.'));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SignUp Page"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Center(
              child: GestureDetector(
                onTap: _getImage,
                child: _image == null
                    ? const Icon(Icons.account_circle, size: 100)
                    : CircleAvatar(
                        radius: 50, backgroundImage: FileImage(_image!)),
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'SignUp Page',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'username',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
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
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('SignUp'),
                  onPressed: () {
                    // Code for signup
                    createUserWithEmailAndPassword();
                    _saveDataToFirestore();

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Already have an account?'),
                TextButton(
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    //signup screen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
