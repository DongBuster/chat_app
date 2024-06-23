import 'package:flutter/material.dart';

class UsernameFied extends StatelessWidget {
  final String title;
  final String hintText;
  final Icon prefixIcon;
  final TextEditingController controller;
  final FocusNode focusNode;
  const UsernameFied({
    super.key,
    required this.title,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 70,
          height: 60,
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,

            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              } else {
                if (RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                        .hasMatch(value) ==
                    false) {
                  return 'This is not an email';
                }
              }
              return null;
            },
            //--
            onTapOutside: (event) {
              focusNode.unfocus();
            },
            //--
            focusNode: focusNode,
            controller: controller,
            cursorColor: Colors.blue,
            cursorWidth: 1,
            style: const TextStyle(fontSize: 14),
            //---
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(top: 18, bottom: 0, left: 0),
              hintText: hintText,
              hintStyle: const TextStyle(fontSize: 14, color: Colors.black38),
              prefixIcon: Padding(
                  padding: const EdgeInsets.only(right: 13), child: prefixIcon),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38)),
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
            ),
          ),
        )
      ],
    );
  }
}

class PasswordFieldLoginPage extends StatefulWidget {
  final String title;
  final String hintText;
  final Icon prefixIcon;
  final TextEditingController controller;
  final FocusNode focusNode;
  const PasswordFieldLoginPage({
    super.key,
    required this.title,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    required this.focusNode,
  });

  @override
  State<PasswordFieldLoginPage> createState() => _PasswordFieldLoginPageState();
}

class _PasswordFieldLoginPageState extends State<PasswordFieldLoginPage> {
  bool visibility = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 70,
          height: 60,
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,

            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            //---
            obscureText: visibility ? true : false,
            onTapOutside: (event) {
              widget.focusNode.unfocus();
            },
            //--
            focusNode: widget.focusNode,
            controller: widget.controller,
            cursorColor: Colors.blue,
            cursorWidth: 1,
            style: const TextStyle(fontSize: 14),
            //---

            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(top: 18, bottom: 0, left: 0),

              hintText: widget.hintText,
              hintStyle: const TextStyle(fontSize: 14, color: Colors.black38),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(right: 13),
                child: widget.prefixIcon,
              ),
              //---
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    visibility = !visibility;
                  });
                },
                child: visibility
                    ? const Icon(
                        Icons.visibility_off,
                        color: Colors.black54,
                      )
                    : const Icon(
                        Icons.visibility,
                        color: Colors.black54,
                      ),
              ),

              //--
              filled: true,
              fillColor: Colors.white,
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38)),
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
            ),
          ),
        )
      ],
    );
  }
}

class PasswordFieldRegistterPage extends StatefulWidget {
  final String title;
  final String hintText;
  final Icon prefixIcon;
  final TextEditingController controllerConfirmPassword;
  final TextEditingController controllerPassword;
  final FocusNode focusNode;
  const PasswordFieldRegistterPage({
    super.key,
    required this.title,
    required this.hintText,
    required this.prefixIcon,
    required this.controllerPassword,
    required this.controllerConfirmPassword,
    required this.focusNode,
  });

  @override
  State<PasswordFieldRegistterPage> createState() =>
      _PasswordFieldRegistterPageState();
}

class _PasswordFieldRegistterPageState
    extends State<PasswordFieldRegistterPage> {
  bool visibility = true;
  bool confirmPassword = false;

  void setconfirmPassword() {
    if (widget.controllerConfirmPassword.text.toString() ==
        widget.controllerPassword.text.toString()) {
      confirmPassword = true;
    } else {
      confirmPassword = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 70,
          height: 60,
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            obscureText: visibility ? true : false,
            onTapOutside: (event) {
              widget.focusNode.unfocus();
            },
            onChanged: (value) {
              setState(() {
                widget.controllerPassword.text = value;
                setconfirmPassword();
              });
            },
            //--
            focusNode: widget.focusNode,
            controller: widget.controllerPassword,
            cursorColor: Colors.blue,
            cursorWidth: 1,
            style: const TextStyle(fontSize: 14),
            //---

            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(top: 18, bottom: 0, left: 0),
              hintText: widget.hintText,
              hintStyle: const TextStyle(fontSize: 14, color: Colors.black38),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(right: 13),
                child: widget.prefixIcon,
              ),
              //---
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    visibility = !visibility;
                  });
                },
                child: visibility
                    ? const Icon(
                        Icons.visibility_off,
                        color: Colors.black54,
                      )
                    : const Icon(
                        Icons.visibility,
                        color: Colors.black54,
                      ),
              ),

              //--
              filled: true,
              fillColor: Colors.white,
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38)),
              focusedBorder: confirmPassword
                  ? const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue))
                  : const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
            ),
          ),
        )
      ],
    );
  }
}

class ConfirmPasswordFieldRegistterPage extends StatefulWidget {
  final String title;
  final String hintText;
  final Icon prefixIcon;
  final TextEditingController controllerConfirmPassword;
  final TextEditingController controllerPassword;
  final FocusNode focusNode;
  const ConfirmPasswordFieldRegistterPage({
    super.key,
    required this.title,
    required this.hintText,
    required this.prefixIcon,
    required this.controllerConfirmPassword,
    required this.controllerPassword,
    required this.focusNode,
  });

  @override
  State<ConfirmPasswordFieldRegistterPage> createState() =>
      _ConfirmPasswordFieldRegistterPageState();
}

class _ConfirmPasswordFieldRegistterPageState
    extends State<ConfirmPasswordFieldRegistterPage> {
  bool visibility = true;
  bool confirmPassword = true;

  void setconfirmPassword() {
    if (widget.controllerConfirmPassword.text.toString() ==
        widget.controllerPassword.text.toString()) {
      confirmPassword = true;
    } else {
      confirmPassword = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 70,
          height: 60,
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,

            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            obscureText: visibility ? true : false,
            onTapOutside: (event) {
              widget.focusNode.unfocus();
            },

            onChanged: (value) {
              setState(() {
                widget.controllerConfirmPassword.text = value;
                setconfirmPassword();
              });
            },
            //--
            focusNode: widget.focusNode,
            controller: widget.controllerConfirmPassword,
            cursorColor: Colors.blue,
            cursorWidth: 1,
            style: const TextStyle(fontSize: 14),
            //---

            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(top: 18, bottom: 0, left: 0),
              hintText: widget.hintText,
              hintStyle: const TextStyle(fontSize: 14, color: Colors.black38),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(right: 13),
                child: widget.prefixIcon,
              ),
              //---
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    visibility = !visibility;
                  });
                },
                child: visibility
                    ? const Icon(
                        Icons.visibility_off,
                        color: Colors.black54,
                      )
                    : const Icon(
                        Icons.visibility,
                        color: Colors.black54,
                      ),
              ),

              //--
              filled: true,
              fillColor: Colors.white,
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38)),
              focusedBorder: confirmPassword
                  ? const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue))
                  : const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
            ),
          ),
        )
      ],
    );
  }
}
