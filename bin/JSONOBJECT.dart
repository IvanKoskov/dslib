import 'dart:core';

import 'DJSON_PATH.dart';
import 'dart:convert';
//import 'package:archive/archive.dart'; not ready

class JSONobject extends DSJSONpathHelper {
  late var body;
  late var fromJSON;

  // This function uses Dart's built-in json.encode() to convert the body into a JSON string
  String convertToJSON(var body) {
    return json.encode(body);  // Using json.encode for better flexibility and standardization
  }

  // Decode the JSON string to Dart object
  dynamic convertFromJSON(var fromJSON) {
    if (fromJSON is String) {
      return json.decode(fromJSON);  // Decode the JSON string to Dart object
    } else {
      throw FormatException("Expected a JSON string, but received a non-string.");
    }
  }


  bool compressJSON() {






   return true;
  }




}
