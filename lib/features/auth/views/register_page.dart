import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:go_router/go_router.dart';
import '../../../common/overlay_loading.dart';
import '../controller/auth_controller.dart';
import '../widgets/input_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _controllerUsername = TextEditingController();
  final _focusNodeUsername = FocusNode();
  final _controllerPassword = TextEditingController();
  final _focusNodePassword = FocusNode();
  final _controllerConfirmPassword = TextEditingController();
  final _focusNodeConfirmPassword = FocusNode();
  final _formKeyRegister = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(left: 35, right: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // --- title page ---
            const Expanded(
              child: Center(
                // padding: EdgeInsets.only(top: 50),
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            // -- field ---
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  key: _formKeyRegister,
                  child: Column(
                    children: [
                      UsernameFied(
                        title: 'Email',
                        hintText: 'Type your email',
                        prefixIcon: const Icon(
                          Icons.person_2_outlined,
                          size: 20,
                          color: Colors.black38,
                        ),
                        controller: _controllerUsername,
                        focusNode: _focusNodeUsername,
                      ),
                      PasswordFieldRegistterPage(
                        title: 'Password',
                        hintText: 'Type your password',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          size: 20,
                          color: Colors.black38,
                        ),
                        controllerPassword: _controllerPassword,
                        controllerConfirmPassword: _controllerConfirmPassword,
                        focusNode: _focusNodePassword,
                      ),
                      ConfirmPasswordFieldRegistterPage(
                        title: 'Confirm Password',
                        hintText: 'Re-enter the password',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          size: 20,
                          color: Colors.black38,
                        ),
                        controllerPassword: _controllerPassword,
                        controllerConfirmPassword: _controllerConfirmPassword,
                        focusNode: _focusNodeConfirmPassword,
                      ),
                    ],
                  ),
                ),
                const Gap(25),
                // --- register button ---
                GestureDetector(
                  onTap: () async {
                    OverlayState overlayState = Overlay.of(context);
                    OverlayEntry overlayEntry = OverlayEntry(
                      builder: (context) {
                        return const Loading();
                      },
                    );
                    if (_formKeyRegister.currentState!.validate()) {
                      if (_controllerConfirmPassword.text.toString() !=
                          _controllerPassword.text.toString()) {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        overlayState.insert(overlayEntry);
                        await AuthController.createUserWithEmailAndPassword(
                          context,
                          _controllerUsername,
                          _controllerPassword,
                        ).whenComplete(() => overlayEntry.remove());
                      }
                    }
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
                    child: const Text('REGISTER',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),

                const Gap(40),

                const Text(
                  'Or Sign Up Using',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const Gap(15),
                // other login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.filled(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.white),
                        side: MaterialStatePropertyAll(
                          BorderSide(
                            color: Color(0xff4caf50),
                          ),
                        ),
                      ),
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/icon_google.svg',
                        width: 18,
                        height: 18,
                      ),
                    ),
                  ],
                ),
                const Gap(50),
              ],
            ),
            // --- back login page ----
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    '👉 Or Go to Login!',
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    colors: [
                      Colors.blue,
                      Colors.red,
                      Colors.purpleAccent,
                    ],
                    textAlign: TextAlign.center,
                    speed: const Duration(milliseconds: 500),
                  ),
                ],
                onTap: () {
                  context.go('/login');
                },
                repeatForever: true,
                pause: const Duration(milliseconds: 500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final snackBar = SnackBar(
  elevation: 0,
  behavior: SnackBarBehavior.floating,
  backgroundColor: Colors.transparent,
  content: AwesomeSnackbarContent(
    title: 'Warning!',
    message:
        'Passwords do not match! Please check your password and your confirmed password !',
    contentType: ContentType.warning,
  ),
);
