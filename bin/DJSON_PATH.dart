
import 'dart:io' show Platform, stdout;



class DSJSONpathHelper{

String? returnHomeDir(){


 String os = Platform.operatingSystem;
  String? home = "";
  Map<String, String> envVars = Platform.environment;
  if (Platform.isMacOS) {
    home = envVars['HOME'];
  } else if (Platform.isLinux) {
    home = envVars['HOME'];
  } else if (Platform.isWindows) {
    home = envVars['UserProfile'];
  }
  stdout.writeln(home);

return home;
}

}