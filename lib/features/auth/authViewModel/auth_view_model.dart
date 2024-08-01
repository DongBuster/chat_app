import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/snackbar_common.dart';
import '../../../models/accout_user.dart';
import '../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthViewModel {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static firebase_auth.User get user => auth.currentUser!;
  static firebase_auth.FirebaseAuth auth = firebase_auth.FirebaseAuth.instance;

  //--- login accout google ---
  static Future<firebase_auth.UserCredential> _signInWithGoogle() async {
    // Trigger the authentication flow

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = firebase_auth.GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await auth.signInWithCredential(credential);
  }

  //--- create data user and push data user ---
  static Future<void> createUser(String email, String id) async {
    String nameUser = email.toString();
    int splitIndex = nameUser.indexOf('@');
    nameUser = nameUser.substring(0, splitIndex);
    final accountUser = AccoutUser(
      id: id,
      name: nameUser,
      image: user.photoURL.toString(),
      email: user.email.toString(),
      isNewUser: 'true',
      isOnline: 'false',
    );

    await firestore.collection('users').doc(user.uid).set(accountUser.toJson());
    // await Supabase.instance.client.from('rooms_chat').insert({'userId': id});
    // await Supabase.instance.client.from('friends').insert({'userId': id});
  }

  //--- Check if user is new or not ---
  static Future<String> isNewUser(String userId) async {
    final DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (snapshot.exists && snapshot.data() != null) {
      final data = snapshot.data() as Map<String, dynamic>;
      final isNewUser = data['isNewUser'];
      return isNewUser ?? '';
    } else {
      return '';
    }
  }

  //--- handle login accout google ---
  static Future<void> handleGoogleBtnClick(BuildContext context) async {
    _signInWithGoogle().then((userLogin) async {
      // print(userLogin);
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      isNewUser(userLogin.user!.uid).then((isNewUser) async {
        if (isNewUser == 'true' || isNewUser == 'false') {
          context.go('/homePage');
          await prefs.setBool('islogin', true);
          await prefs.setString('email', userLogin.user!.email!);
        } else {
          createUser(userLogin.user!.email!, userLogin.user!.uid);
          context.go('/homePage');
          await prefs.setBool('islogin', true);
          await prefs.setString('email', userLogin.user!.email!);
        }
      });
    }).catchError((error) {
      debugPrint('Login accout google error:$error');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackbarCommon.snackBarErrorOccurred);
    });
  }

  //--- sign in email  and password ---
  static Future<void> signInWithEmailAndPassword(
    BuildContext context,
    TextEditingController controllerUsername,
    TextEditingController controllerPassword,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await Auth()
          .signInWithEmailAndPassword(
        email: controllerUsername.text,
        password: controllerPassword.text,
      )
          .then(
        (user) {
          prefs.setBool('islogin', true);
          prefs.setString('email', controllerUsername.text);
          context.go('/homePage');
        },
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint('login : ${e.message}');
      if (e.message == 'The email address is badly formatted') {
        // print('asjd');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackbarCommon.snackBarErrorFormatEmail);
      } else if (e.message ==
          'The password is invalid or the user does not have a password.') {
        // print('asjd');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackbarCommon.snackbarIncorrectPassword);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackbarCommon.snackBarErrorOccurred);
      }
    }
  }

  //--- handle create accout email ---
  static Future<void> createUserWithEmailAndPassword(
    BuildContext context,
    TextEditingController controllerUsername,
    TextEditingController controllerPassword,
  ) async {
    try {
      await Auth()
          .createUserWithEmailAndPassword(
        email: controllerUsername.text,
        password: controllerPassword.text,
      )
          .then(
        (value) {
          createUser(controllerUsername.text, user.uid);
          context.go('/login');
        },
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint('ERROR-createUserWithEmailAndPassword:${e.message}');
      if (e.message ==
          'The email address is already in use by another account.') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackbarCommon.snackbarUsedEmail);
      }
      if (e.message == 'Password should be at least 6 characters') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackbarCommon.snackbarPassword);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackbarCommon.snackBarErrorOccurred);
      }
    }
  }
}
