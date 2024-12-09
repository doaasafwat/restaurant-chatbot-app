import 'package:cashier_bot_for_restaurant/auth/view/views/login_view.dart';
import 'package:cashier_bot_for_restaurant/auth/view/widgets/custom_button.dart';
import 'package:cashier_bot_for_restaurant/auth/view/widgets/custom_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;

  Future<void> registerUser() async {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        addressController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required!')),
      );
      return;
    }

    setState(() {
      isLoading = true; 
    });

    try {

      final List<String> methods =
          await _auth.fetchSignInMethodsForEmail(emailController.text.trim());
      if (methods.isNotEmpty) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This email is already registered.')),
        );
        return;
      }
      


      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await _firestore.collection('Customers').doc(userCredential.user?.uid).set({
        'username': usernameController.text.trim(),
        'email': emailController.text.trim(),
        'address': addressController.text.trim(),
        'phone': phoneController.text.trim(),
        'createdAt': DateTime.now(),
      });

      setState(() {
        isLoading = false; 
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Registration failed. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.10,
                    ),
                    const Text(
                      'Hello! Register to get started',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomFormField(
                      hintText: 'Name',
                      isPassword: false,
                      controller: usernameController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomFormField(
                      hintText: 'Email',
                      isPassword: false,
                      controller: emailController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomFormField(
                      hintText: 'Address',
                      isPassword: false,
                      controller: addressController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomFormField(
                      hintText: 'Phone',
                      isPassword: false,
                      controller: phoneController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomFormField(
                      hintText: 'Password',
                      controller: passwordController,
                      isObsecure: true,
                      isPassword: true,
                      isPasswordVisible: isPasswordVisible,
                      onTogglePasswordVisibility: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    CustomButton(
                      onPressed: registerUser, // استدعاء دالة التسجيل
                      text: 'Sign Up',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) => LoginPage(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account?  ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: const [
                            TextSpan(
                              text: 'Sign in',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

