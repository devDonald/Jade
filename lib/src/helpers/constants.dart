
const APP_ID = "3d49bebc83b244a88223d6805ce688fee";

class AppConfig{
 static bool isValidEmail(String emailId) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailId);
  }
}