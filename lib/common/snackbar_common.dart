import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class SnackbarCommon {
  static final snackBarErrorPasswordNotMatch = SnackBar(
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

  static final snackBarErrorFormatEmail = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Warning!',
      message: 'The email address is badly formatted, please try again !',
      contentType: ContentType.warning,
    ),
  );

  static final snackBarErrorOccurred = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Warning!',
      message: 'Something error occurred, please try again !',
      contentType: ContentType.warning,
    ),
  );

  static final snackbarUsedEmail = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Warning!',
      message:
          'The email address is already in use by another account, please use another email !',
      contentType: ContentType.warning,
    ),
  );

  static final snackbarPassword = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Warning!',
      message: 'Password should be at least 6 characters, please !',
      contentType: ContentType.warning,
    ),
  );

  static final snackbarIncorrectPassword = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Warning!',
      message: 'Incorrect password, please try again !',
      contentType: ContentType.warning,
    ),
  );
}
