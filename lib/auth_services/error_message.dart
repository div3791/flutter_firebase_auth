import 'package:flutter/services.dart';

class ErrorHandling {
  static String getErrorMessage(PlatformException e) {
    switch (e.code) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return 'Email is already in use.\nPlease try again with different email';
      case 'ERROR_WRONG_PASSWORD':
        return 'Invalid Email ID or Password';
      case 'ERROR_TOO_MANY_REQUESTS':
        return 'Too many requests in short time. Please try again later';
      case  'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
        return 'Email is already registered with other login method. Please try again with different email';
      case  'ERROR_INVALID_VERIFICATION_CODE':
        return 'Invalid Verification Code';
      default:
        return 'Something went wrong';
    }
  }
}
