import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:parentsapp/bearer.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Signup/signup_screen.dart';
import 'package:http/http.dart' as http;
import '../../../home.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginState();
}

class _LoginState extends State<LoginForm> {
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            cursorColor: kPrimaryColor,
            controller: phoneNumberController,
            decoration: InputDecoration(
              hintText: "Your phone number",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.phone),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              controller: passwordController,
              decoration: InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(

            onPressed: () {
            // _login(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
              );
            },
            child: Text(
              "Login".toUpperCase(),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }


  final TextEditingController phoneNumberContoller = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  Future<void> _login(BuildContext context) async {
    final String phone_Number = phoneNumberController.text;
    final String password = passwordController.text;


    try {

      final response = await http.post(
        // Uri.parse('http://10.11.3.211:8000/login'),
        // Uri.parse('http://10.11.5.203:8000/register'),
        Uri.parse('http://192.168.160.109:8000/register'),

         // Replace with your server URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone_Number': phone_Number, 'password': password}),
      );
      // print(response.body);
      if (response.statusCode == 200) {
        // Signup successful, handle the response as needed
        Map<String, dynamic> decodedResponse = json.decode(response.body);
        String profile = decodedResponse['Profile'];


// Create an instance of the Bearer class and store the 'bearer' value
        Bearer be=new Bearer();
        String? value=decodedResponse['bearer'];
        be.insertToken(value!);
//        Bearer.instance.insertToken(value!);
        print("hi 1");
        print(profile);
        if (profile == "Placement") {
          print("place 2");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ),
          );
        } else if (profile == "Staff") {
          print("staff 3");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
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

}



