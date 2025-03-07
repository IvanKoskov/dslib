/*

                               _____   _____      _  _____  ____  _   _ 
                              |  __ \ / ____|    | |/ ____|/ __ \| \ | |
                              | |  | | (___      | | (___ | |  | |  \| |
                              | |  | |\___ \ _   | |\___ \| |  | | . ` |
                              | |__| |____) | |__| |____) | |__| | |\  |
                              |_____/|_____/ \____/|_____/ \____/|_| \_|
                                           
                                        By Ivan Koskov     

***********************************************************************************************************************
* 1. In order to start working with the library, you will need to have the Dart SDK installed on your machine.        *
*                                                                                                                     *
*    For Linux:                                                                                                        *
*      sudo apt update -y                                                                                              *
*      sudo apt install apt-transport-https                                                                            *
*      sudo sh -c 'wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable_amd64.deb   *
*      | tee /etc/apt/sources.list.d/dart_stable.list'                                                                  *
*      sudo apt update -y                                                                                              *
*      sudo apt install dart                                                                                           *
*                                                                                                                     *
*    For MacOS:                                                                                                       *
*      brew tap dart-lang/dart                                                                                         *
*      brew install dart                                                                                               *
*                                                                                                                     *
*    Website: https://dart.dev                                                                                         *
*                                                                                                                     *
* 2. After installing Dart, import the library file with all definitions in your project's main file (.dart):         *
*                                                                                                                     *
*      import 'DJSON.dart';                                                                                            *
*                                                                                                                     *
* 3. The library is designed to be reusable, which is why it is based on instances of objects.                         *
*                                                                                                                     *
*    To begin, create a new JSON file instance by typing: `CreateJSON object`. It creates an instance of a JSON file.  *
*    Parameters: (String name, String path, bool encrypted). The last parameter is optional, and the default is false.  *
*                                                                                                                     *
*    General usage: Pass the object itself to its methods. You can create multiple instances, and they will be         *
*    separate from each other.                                                                                         *
*                                                                                                                     *
*    Example:                                                                                                          *
*      late var file = CreateJSON('testdata.json', '/Users/evan/testjson');                                           *
*      var file = CreateJSON('testdata.json', '/Users/evan/testjson', true); // if it will be encrypted                *
*                                                                                                                     *
*    // Example usage of protecting jsons
 * //file.encryptOrDecryptFile('1234', '/Users/evan/testjson/testdata.json', '/Users/evan/testjson/testdataa2.json', true); // Encrypt*
 * //file.encryptOrDecryptFile('1234', '/Users/evan/testjson/testdataa2.json', '/Users/evan/testjson/testdata33.json', false); // Decrypt  *
*                                                                                                                     *
* 4. Now, let's use one of the methods on the file:                                                                    *
*                                                                                                                     *
*    var initialContent = {                                                                                           *
*      'name': 'John Doe',                                                                                             *
*      'age': 30,                                                                                                      *
*      'email': 'johndoe@example.com',                                                                                 *
*      'isActive': true,                                                                                                *
*      'tags': ['developer', 'dart']                                                                                   *
*    };                                                                                                                *
*                                                                                                                     *
*    file.createJSONFile(file, initialContent);                                                                        *
*                                                                                                                     *
*    This creates and populates the file.                                                                              *
*                                                                                                                     *
* 5. Another example:                                                                                                  *
*                                                                                                                     *
*    var file = CreateJSON('testdata.json', '/Users/evan/testjson');  // Use your appropriate path here                 *
*    var archive = Djsonarchive(); // Create another instance, but of the archiving class                             *
*    archive.DJSONarchive(file); // Pass the JSON object directly with its data assigned to it                         *
*                                                                                                                     *
* 6. To see all available functions and methods, please refer to the main library file (`JSONOBJECT.dart`) and other library  *
*    files (e.g., `DJSON.dart`). These files contain all the functions and methods that are available for use.         *
*                                                                                                                     *
***********************************************************************************************************************
*/
