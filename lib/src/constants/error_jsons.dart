class ErrorJsons {
  static const Map invalidCredentials = {
    'error': true,
    'message': "Your PayPal credentials seems incorrect"
  };

  static const Map noInternetError = {
    'error': true,
    'message': "Unable to proceed, check your internet connection."
  };
}
