import 'dart:async';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/home_page_model.dart';

class AppSharedPreferences {
  static final String userNumber = 'user_number';
  static final String userPw = 'user_password';
  static final int keyLength = 32;
  static final int ivLength = 16;
  static final String favoriteCards = 'favorite_cards';
  static final List<FAVORITE_WIDGET_TYPE> defaultFavoriteCards = [
    FAVORITE_WIDGET_TYPE.schedule,
    FAVORITE_WIDGET_TYPE.exams,
    FAVORITE_WIDGET_TYPE.busStops
  ];

  static Future savePersistentUserInfo(user, pass) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(userNumber, user);
    prefs.setString(userPw, encode(pass));
  }

  static Future removePersistentUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(userNumber);
    prefs.remove(userPw);
  }

  static Future<Tuple2<String, String>> getPersistentUserInfo() async {
    final String userNum = await getUserNumber();
    final String userPass = await getUserPassword();
    return  Tuple2(userNum, userPass);
  }

  static Future<String> getUserNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNumber) ??
        ''; // empty string for the case it does not exist
  }

  static Future<String> getUserPassword() async {
    final prefs = await SharedPreferences.getInstance();
    String pass = prefs.getString(userPw) ?? '';

    if (pass != '') {
      pass = decode(pass);
    } else {
      Logger().w('User password does not exist in shared preferences.');
    }

    return pass;
  }

  static saveFavoriteCards(List<FAVORITE_WIDGET_TYPE> newFavorites) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        favoriteCards, newFavorites.map((a) => a.index.toString()).toList());
  }

  static Future<List<FAVORITE_WIDGET_TYPE>> getFavoriteCards() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> storedFavorites = prefs.getStringList(favoriteCards);
    if (storedFavorites == null) return defaultFavoriteCards;
    return storedFavorites
            .map((i) => FAVORITE_WIDGET_TYPE.values[int.parse(i)])
            .toList() ??
        defaultFavoriteCards;
  }

  static String encode(String plainText) {
    final encrypter = _createEncrypter();
    return encrypter.encrypt(plainText).base64;
  }

  static String decode(String base64Text) {
    final encrypter = _createEncrypter();
    return encrypter.decrypt64(base64Text);
  }

  static Encrypter _createEncrypter() {
    final key = Key.fromLength(keyLength);
    final iv = IV.fromLength(ivLength);
    return Encrypter(AES(key, iv));
  }
}
