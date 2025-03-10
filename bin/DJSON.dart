import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import "JSONOBJECT.dart";
import 'package:archive/archive.dart';
import 'package:encrypt/encrypt.dart' as encrypt; //for protected function
import 'package:crypto/crypto.dart'; 
import 'dart:typed_data'; 


/*

  _____   _____      _  _____  ____  _   _ 
 |  __ \ / ____|    | |/ ____|/ __ \| \ | |
 | |  | | (___      | | (___ | |  | |  \| |
 | |  | |\___ \ _   | |\___ \| |  | | . ` |
 | |__| |____) | |__| |____) | |__| | |\  |
 |_____/|_____/ \____/|_____/ \____/|_| \_|
                                           
              By Ivan Koskov                                     
*/


class CreateJSON extends JSONobject {
  late String name;
  late String path;
  late bool isProtected; //if it will encrypted


  // Constructor to initialize file name and path
  CreateJSON(this.name, this.path, [this.isProtected = false]) {
    print('File: $name, Path: $path, isProtected: $isProtected');
  }

/*
  void DJSONprotected(CreateJSON file) {


//the protected method is no longer developed, use encryptOrDecryptFile instead

  
  }

*/


void encryptOrDecryptFile(
    String password,
    String inputFilePath,
    String outputFilePath,
    bool isEncrypting, // true for encryption, false for decryption
) async {
  // Generate a key from the password (using SHA256 for example)
  final key = _generateKey(password);

  // Generate a random IV (Initialization Vector)
  final iv = encrypt.IV.fromLength(16); // AES block size is 16 bytes

  // Create an AES encryption object with the key and IV
  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  // Read the file content
  final file = File(inputFilePath);
  final fileBytes = await file.readAsBytes();

  late List<int> resultBytes;
  if (isEncrypting) {
    // Encrypt the file content with the IV
    final encrypted = encrypter.encryptBytes(fileBytes, iv: iv);
    resultBytes = iv.bytes + encrypted.bytes; // Append IV to the encrypted data
  } else {
    // Decrypt the file content
    final encryptedBytes = Uint8List.fromList(fileBytes);
    final ivFromFile = encrypt.IV(encryptedBytes.sublist(0, 16)); // Extract IV from the first 16 bytes
    final encryptedData = encryptedBytes.sublist(16); // The remaining bytes are the encrypted data

    final decrypted = encrypter.decryptBytes(encrypt.Encrypted(encryptedData), iv: ivFromFile);
    resultBytes = decrypted;
  }

  // Write the processed content (encrypted/decrypted) to a new file
  final outputFile = File(outputFilePath);
  await outputFile.writeAsBytes(resultBytes);

  print(isEncrypting
      ? 'File encrypted and saved to $outputFilePath'
      : 'File decrypted and saved to $outputFilePath');
}

// Generate a key from a password
encrypt.Key _generateKey(String password) {
  final key = utf8.encode(password); // Convert password to bytes
  final digest = sha256.convert(key); // Hash the password using SHA-256
  return encrypt.Key(Uint8List.fromList(digest.bytes)); // Convert List<int> to Uint8List
}





Map<String, dynamic> _mergeJson(Map<String, dynamic> json1, Map<String, dynamic> json2) {
  // Create a new map to store the merged result
  var merged = Map<String, dynamic>.from(json1);

  json2.forEach((key, value) {
    if (merged.containsKey(key)) {
      // Check if both the value and the merged value are maps
      if (value is Map && merged[key] is Map) {
        // Merge nested maps recursively
        merged[key] = _mergeJson(
          merged[key] as Map<String, dynamic>,  // Explicit cast to Map<String, dynamic>
          value as Map<String, dynamic>         // Explicit cast to Map<String, dynamic>
        );
      } else if (value is List && merged[key] is List) {
        // Concatenate lists
        merged[key] = List.from(merged[key])..addAll(value);
      } else {
        // Overwrite the value if types are not matching or they are primitive
        merged[key] = value;
      }
    } else {
      // If key doesn't exist in the first JSON, add it
      merged[key] = value;
    }
  });

  return merged;
}


Future<dynamic> dynamicJSONtoCSV(CreateJSON file) async {
  try {
    // Use the `path` package for safer path handling
    var myFile = File(file.path + Platform.pathSeparator + file.name);

    if (await myFile.exists()) {
      // Read the file content as a string
      String contents = await myFile.readAsString();
      print('Original JSON Content: $contents');

      // Try to decode the JSON content
      var jsonData = json.decode(contents);

      // If the root of the JSON is a Map, we need to handle it differently
      if (jsonData is List) {
        // Convert JSON to CSV format if the root is a List
        String csvData = _convertJsonToCsv(jsonData);

        // Write the CSV data to a new file
        var myCSV = File(file.path + Platform.pathSeparator + 'translated.csv');
        await myCSV.writeAsString(csvData);

        print('CSV file created at: ${myCSV.path}');
        return csvData;
      } else {
        print('Error: Expected JSON to be an array at root.');
      }
    } else {
      print('Error: File does not exist at ${myFile.path}');
    }
  } catch (e) {
    print("Error: $e");
  }
  return null; // In case of an error or if file doesn't exist
}

// Helper function to convert JSON to CSV
String _convertJsonToCsv(List<dynamic> jsonData) {
  if (jsonData.isEmpty) {
    return '';
  }

  // Assume the first element contains the keys for the CSV headers
  var headers = jsonData[0].keys.toList();

  // Create CSV content with headers first
  String csvContent = headers.join(',') + '\n';

  // Iterate through each JSON object to create the rows for CSV
  for (var item in jsonData) {
    var row = headers.map((header) {
      var value = item[header];
      return value != null ? value.toString().replaceAll(',', '') : ''; // Remove commas from values to avoid issues
    }).join(',');
    csvContent += row + '\n';
  }

  return csvContent;
}



dynamic JSONobjectMerge(CreateJSON file, CreateJSON file2) {
  // This method takes the first object as the target file and the second one as the object to merge with.
  // The output will be saved in the directory of the first (original file).

  // First JSON file
  var myFile = File(file.path + Platform.pathSeparator + file.name);
  // Second JSON file
  var myFile2 = File(file2.path + Platform.pathSeparator + file2.name);

  // Read the contents of the first file
  String? currentContent1 = myFile.existsSync() ? myFile.readAsStringSync() : null;
  // Read the contents of the second file
  String? currentContent2 = myFile2.existsSync() ? myFile2.readAsStringSync() : null;

  // If either file doesn't exist or can't be read, throw an exception
  if (currentContent1 == null || currentContent2 == null) {
    throw Exception("Error: One or both files could not be read.");
  }

  // Decode the JSON strings into Dart objects
  Map<String, dynamic> json1 = jsonDecode(currentContent1) as Map<String, dynamic>;
  Map<String, dynamic> json2 = jsonDecode(currentContent2) as Map<String, dynamic>;

  // Merge both JSON objects
  var mergedJson = _mergeJson(json1, json2);

  // Convert merged map back to JSON string
  String mergedJsonString = jsonEncode(mergedJson);

  // Try writing the merged JSON to a new file
  try {
    var mergedFile = File(file.path + Platform.pathSeparator + 'mergedJSON.json');
    mergedFile.writeAsStringSync(mergedJsonString);
    print('Merge was successful and saved at: ${mergedFile.path}');
  } catch (e) {
    print('Error creating file: $e');
  }
}


dynamic JSONformat(var body) {
  // Check if body is a String (i.e., raw JSON string)
  if (body is String) {
    try {
      var decodedJson = jsonDecode(body);  // Decode JSON string to Map
      var encoder = JsonEncoder.withIndent('  ');  // Create an encoder with indentation
      return encoder.convert(decodedJson);  // Convert the Map back to pretty-printed JSON string
    } catch (e) {
      return 'Invalid JSON format: $e';  // Handle error if the string is not valid JSON
    }
  } 
  // Check if body is already a Map (no need to decode, just convert it to JSON string)
  else if (body is Map) {
    var encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(body);  // Directly format the Map as a JSON string
  } else {
    return 'Expected a JSON string or Map';  // If body is neither a String nor Map
  }
}



  // Method to populate a JSON file with dynamic content
int populateJSONfile(var body, CreateJSON file) {
  try {
    var myFile = File(file.path + Platform.pathSeparator + file.name);
    
    // Read the existing content (if any)
    String? currentContent = myFile.existsSync() ? myFile.readAsStringSync() : null;
    
    // If currentContent is not empty, decode it
    if (currentContent != null && currentContent.isNotEmpty) {
      var decodedContent = json.decode(currentContent);

      // If the content is a Map (i.e., the file has a single JSON object), create an array with the current object
      if (decodedContent is Map<String, dynamic>) {
        decodedContent = [decodedContent];
      }

      // If the content is a list, append the new object to the list
      if (decodedContent is List) {
        decodedContent.add(body);
      }

      // Write the updated content back to the file as a JSON array
      myFile.writeAsStringSync(json.encode(decodedContent));

    } else {
      // If the file is empty, just create an array with the body as the first element
      myFile.writeAsStringSync(json.encode([body]));
    }

    print('Populated JSON with: $body');
    return 0;  // Success
  } catch (e) {
    print("Error writing to file: $e");
    return 1;  // Failure
  }
}



  // Method to create a JSON file with dynamic content
  void createJSONFile(CreateJSON file, var content) {
    try {
      // Manually handling path separator using Platform.pathSeparator
      var myFile = File(file.path + Platform.pathSeparator + file.name);
      myFile.writeAsStringSync(convertToJSON(content));
      print('File created: ${myFile.path}');
    } catch (e) {
      print("Error creating file: $e");
    }
  }

  // Make the readJSON method asynchronous
  Future<String?> readJSON(CreateJSON file) async {
    try {
      var myFile = File(file.path + Platform.pathSeparator + file.name);

      if (await myFile.exists()) {
        // Read file content as a string
        String contents = await myFile.readAsString();
        print(contents);
        return contents;
      } else {
        print('Error: File does not exist at ${myFile.path}');
        return null;
      }
    } catch (e) {
      print("Error reading file: $e");
      return null;
    }
  }

  // Method to delete a JSON file
  void deleteJSONFile(CreateJSON file) {
    // Manually handling path separator using Platform.pathSeparator
    var myFile = File(file.path + Platform.pathSeparator + file.name);

    if (myFile.existsSync()) {
      myFile.deleteSync();
      print('File deleted: ${myFile.path}');
    } else {
      print('File does not exist: ${myFile.path}');
    }
  }


  String JSONlocate(CreateJSON file){

   String JSONlocatedAt = file.path + Platform.pathSeparator + file.name;

   return JSONlocatedAt;
  }

  String JSONfolder(CreateJSON file) {

String folder = file.path;

    return folder;
  }


  

}










/*
void main() {
  // Example usage of CreateJSON and flexible JSON content
  var file = CreateJSON('data.json', Directory.current.path);  // File name and path

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

  // Deleting the file (optional)
  file.deleteJSONFile(file);
}
*/