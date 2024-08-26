import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:parentsapp/Screens/Signup/components/pass_sign.dart';
import 'package:parentsapp/Screens/Signup/components/sign_up_top_image.dart';
import 'package:parentsapp/constants.dart';
import 'package:parentsapp/responsive.dart';
// import 'package:parentsapp/student_reg.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../components/background.dart';
import 'package:http/http.dart' as http;
import 'package:parentsapp/otp.dart';
import '../../Login/login_screen.dart';

class password extends StatefulWidget {
  final String value;

  const password({Key? key, required this.value, required String phoneNumber}) : super(key: key);

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<password> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String phoneNumberContoller = '';

  @override
  void initState() {
    super.initState();
    phoneNumberContoller = widget.value;
    print(phoneNumberContoller);
  }

  Future<void> _signup() async {
    final String phone_Number = phoneNumberContoller;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;
    print(phoneNumberContoller);

    // Validate password
    if (!_isValidPassword(password)) {
      _showAlertDialog("Invalid Password", "Password must contain at least 8 characters, including special, upper, lower, and number.");
      return;
    }

    // Validate password match
    if (password != confirmPassword) {
      _showAlertDialog("Password Mismatch", "Passwords do not match. Please enter the same password in both fields.");
      return;
    }

    try {
      print(phoneNumberContoller);
      final response = await http.post(
        Uri.parse('http://10.11.5.203:8000/signup'), // Replace with your server URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phoneNumber': phone_Number, 'password': password}),
      );
      print(response.body);
      if (response.statusCode == 200) {
        // Signup successful, handle the response as needed
        Map<String, dynamic> decodedResponse = json.decode(response.body);
        String profile = decodedResponse['profile'];
        print("hi 1");
        print(profile);
        if (profile == "Placement") {
          print("place 2");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        } else if (profile == "Staff") {
          print("staff 3");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => studentRegister(),
            ),
          );
        }
        // Send email and password to backend for storage
        //await _sendToBackend(email, password);
      } else {
        // Signup failed, handle the error
        print('Signup failed: ${response.body}');
        // You can show an error message or perform other actions here
      }
    } catch (e) {
      // Exception occurred during signup, handle the error
      print('Error during signup: $e');
      // You can show an error message or perform other actions here
    }
  }

  bool _isValidPassword(String password) {
    // Password must contain at least 8 characters, including special, upper, lower, and number.
    RegExp passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileSignupScreen(value: phoneNumberContoller),
          desktop: Row(
            children: [
              Expanded(
                child: SignUpScreenTopImage(),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 450,
                      child: Form(
                        child: Column(
                          children: [
                            TextFormField(
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              cursorColor: kPrimaryColor,
                              onSaved: (password) {},
                              controller: passwordController,
                              decoration: const InputDecoration(
                                hintText: "Your password",
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(Icons.lock),
                                ),
                              ),
                            ),
                            const SizedBox(height: defaultPadding / 2),
                            TextFormField(
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              cursorColor: kPrimaryColor,
                              onSaved: (confirmPassword) {},
                              controller: confirmPasswordController,
                              decoration: const InputDecoration(
                                hintText: "Confirm Password",
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(Icons.lock),
                                ),
                              ),
                            ),
                            const SizedBox(height: defaultPadding / 2),
                            ElevatedButton(
                              onPressed: () {
                                //_signup();
                              },
                              child: Text("Sign UP".toUpperCase()),
                            ),
                            const SizedBox(height: defaultPadding),
                            AlreadyHaveAnAccountCheck(
                              login: false,
                              press: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) {
                                //       return const LoginScreen();
                                //     },
                                //   ),
                                // );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: defaultPadding / 2),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  studentRegister() {}
}


class MobileSignupScreen extends StatelessWidget {
  final String value;

  const MobileSignupScreen({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SignUpScreenTopImage(),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: pass(phoneNumber:value, value: '',),
            ),
            Spacer(),
          ],
        ),
        Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom))
        // SocalSignUp()
      ],
    )
    );
  }
}


