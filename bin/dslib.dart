import 'package:dslib/dslib.dart' as dslib;

import 'DJSONarchive.dart';
import 'dart:io';

import 'DJSON.dart';
import 'DJSON_PATH.dart';

void main(List<String> arguments) async {
  // Create an instance of CreateJSON with a specific file and path


/*
*********************************************************
*  CreateJSON object creates an instance of JSON file   *
* Parameters (String name, String path, bool encrypted) *
*   Last parameter is optional and default is false     *
*   Usage: pass object itself to its methods            * 
*********************************************************

*/

  var file = CreateJSON('testdata.json', '/Users/evan/testjson');  // Use your appropriate path here

 // var arhcive = Djsonarchive();

  //arhcive.DJSONarchive(file);

    // Example usage
  //file.encryptOrDecryptFile('1234', '/Users/evan/testjson/testdata.json', '/Users/evan/testjson/testdataa2.json', true); // Encrypt
  //file.encryptOrDecryptFile('1234', '/Users/evan/testjson/testdataa2.json', '/Users/evan/testjson/testdata33.json', false); // Decrypt
  

/*
// var file = CreateJSON('testdata.json', '/Users/evan/testjson', true); //if it will be encrypted

  // Step 1: Create a new JSON file with initial content
  var initialContent = {
    'name': 'John Doe',
    'age': 30,
    'email': 'johndoe@example.com',
    'isActive': true,
    'tags': ['developer', 'dart']
  };
  file.createJSONFile(file, initialContent);

  // Step 2: Populate (append) additional data to the JSON file
  var additionalContent = {
    'address': '1234 Elm Street',
    'phone': '123-456-7890',
  };
  file.populateJSONfile(additionalContent, file);

  // Step 3: Read the JSON file content
  String? fileContent = await file.readJSON(file);

  // Step 4: Decode the JSON content
  if (fileContent != null) {
    var decodedContent = file.convertFromJSON(fileContent);
    print('Decoded content from file:');
    print(decodedContent);
  }

  */















  /*
  DSJSONpathHelper path = DSJSONpathHelper();

var testpth = path.returnHomeDir();

print('$testpth');

  // Creating a JSON file with flexible content
  var content = {
    'name': 'John Doe',
    'age': 30,
    'email': 'johndoe@example.com',
    'isActive': true,
    'tags': ['developer', 'dart'],
  };

  file.createJSONFile(file, content);

  // Adding more data to the file
  var newContent = {
    'address': '1234 Elm Street',
    'phone': '123-456-7890',
  };
  file.populateJSONfile(newContent, file);



*/
}


