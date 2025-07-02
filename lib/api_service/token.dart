import 'dart:convert';

import 'package:crypto/crypto.dart';

class Sha256Token{

  static const String _staticKey = 'Suganta@Real%2025&App*Key';

  static String generateTokenTimeStamp(String timestamp){
    final bytes = utf8.encode(timestamp);
    final digest  = sha256.convert(bytes);
   return digest.toString();

  }

  static String urlPath(String url){
    // AppLogger.log("Path Url -->>$url");
    final bytes = utf8.encode(url);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static String token({

    required String encodedUrl,
    required String timestamp,

}){


    final timestampGenerated = generateTokenTimeStamp(timestamp);
    final encodedToken = urlPath(encodedUrl);
    final combined = '$_staticKey$encodedToken$timestampGenerated';
    final bytes = utf8.encode(combined);
    final digest = sha256.convert(bytes);


    // AppLogger.log("NewToken ->>> NewURL ::-->> $encodedToken, Static Key ::-->>$_staticKey, TImeStampGenerated ::-->>  $timestampGenerated  Combined  :: -->$combined  Final Token -->> $digest");

    return digest.toString();
  }



}