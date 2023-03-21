import 'package:shared_preferences/shared_preferences.dart';

class HelperFuntion {
//keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  //saving the data to shared prefrences

  //getting the data from shared prefrences

  static Future<bool?> getUserLoggedInStatus() async {
   SharedPreferences sf = await SharedPreferences.getInstance();

    return sf.getBool(userLoggedInKey);
  }
}
