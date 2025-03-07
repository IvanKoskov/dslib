import 'DJSON.dart';

import 'dart:io';

import 'package:archive/archive.dart';



class Djsonarchive {



 bool DJSONarchive(CreateJSON file) {
    final filePathToArchive = file.path;

    // Create an archive
    var archive = Archive();

    // Check if the provided path is a file or a directory
    if (FileSystemEntity.isFileSync(filePathToArchive)) {
      final fileToArchive = File(filePathToArchive);
      if (fileToArchive.existsSync()) {
        List<int> bytes = fileToArchive.readAsBytesSync();
        // Add the file to the archive
        archive.addFile(ArchiveFile(filePathToArchive, bytes.length, bytes));
      }
    } else if (FileSystemEntity.isDirectorySync(filePathToArchive)) {
      Directory directory = Directory(filePathToArchive);
      List<FileSystemEntity> files = directory.listSync(recursive: true);

      for (var entity in files) {
        if (entity is File && entity.existsSync()) {
          List<int> bytes = entity.readAsBytesSync();
          String relativePath = entity.path.replaceFirst(file.path + Platform.pathSeparator, '');
          // Add the file to the archive with its relative path
          archive.addFile(ArchiveFile(relativePath, bytes.length, bytes));
        }
      }
    } else {
      print('The specified file or directory does not exist.');
      return false;
    }

    // Create a zip file from the archive
    var zipData = ZipEncoder().encode(archive);

    // Save the zip file to disk
    final zipFilePath = file.path + Platform.pathSeparator + file.name + '.zip';
    File(zipFilePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(zipData!);

    print('Archive created successfully: $zipFilePath');
    return true;
  }
}



