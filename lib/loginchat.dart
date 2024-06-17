import 'package:chat_app/home_page.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _controllerUsername = TextEditingController();
  final _focusNodeUsername = FocusNode();
  final _controllerPassword = TextEditingController();
  final _focusNodePassword = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width - 70,
          height: 60,
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,

            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Please enter some text';
            //   } else {
            //     if (RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            //             .hasMatch(value) ==
            //         false) {
            //       return 'This is not an email';
            //     }
            //   }
            //   return null;
            // },
            //--
            onTapOutside: (event) {
              _focusNodeUsername.unfocus();
            },
            //--
            focusNode: _focusNodeUsername,
            controller: _controllerUsername,
            cursorColor: Colors.blue,
            cursorWidth: 1,
            style: const TextStyle(fontSize: 14),
            //---
            decoration: const InputDecoration(
              label: Text('Email'),
              contentPadding: EdgeInsets.only(top: 18, bottom: 0, left: 0),
              // hintText: 'email',
              hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
              // prefixIcon: Padding(
              //     padding: const EdgeInsets.only(right: 13), child: prefixIcon),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width - 70,
          height: 60,
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,

            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Please enter some text';
            //   } else {
            //     if (RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            //             .hasMatch(value) ==
            //         false) {
            //       return 'This is not an email';
            //     }
            //   }
            //   return null;
            // },
            //--
            onTapOutside: (event) {
              _focusNodePassword.unfocus();
            },
            //--
            focusNode: _focusNodePassword,
            controller: _controllerPassword,
            cursorColor: Colors.blue,
            cursorWidth: 1,
            style: const TextStyle(fontSize: 14),
            //---
            decoration: const InputDecoration(
              label: Text('Password'),
              contentPadding: EdgeInsets.only(top: 18, bottom: 0, left: 0),
              // hintText: 'email',
              hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
              // prefixIcon: Padding(
              //     padding: const EdgeInsets.only(right: 13), child: prefixIcon),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => HomePage(
                          userName: _controllerUsername.text,
                        )));
          },
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width - 70,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.purpleAccent,
                ],
              ),
            ),
            child: const Text(
              'LOGIN',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
