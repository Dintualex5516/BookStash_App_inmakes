import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_stash/service/auth_service.dart';
import "package:book_stash/utils/toast.dart"; 



class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Signup",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Email"),
                  hintText: "Enter your email",
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Password"),
                  hintText: "Enter your Password",
                ),
                obscureText: true, // Optional: to hide the password input
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: OutlinedButton(
                  onPressed: () async {
                    await AuthServiceHelper.cteateAccountWithEmail(
                      emailController.text,
                      passwordController.text,
                    ).then((value) {
                      if (value == "Account Created") {
                        Message.show(message: "Account Created");
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          "/home", // Replace with your home route
                          (route) => false,
                        );
                      } else {
                        Message.show(message: "Error: $value");
                      }
                    });
                  },
                  child: Text("Signup"),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Already have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Login"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}