import 'package:shared_preferences/shared_preferences.dart';

class HelperFuntion {
//keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  //saving the data to shared prefrences

  static Future<bool> saveUserLoggedInStatus(bool inUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, inUserLoggedIn);
  }

  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  //getting the data from shared prefrences

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();

    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmaiFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();

    return sf.getString(userEmailKey);
  }

  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();

    return sf.getString(userNameKey);
  }
}
