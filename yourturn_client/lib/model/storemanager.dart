import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class StoreManager {

  Future<File> localFile(String fileName) async {
    Directory directory = await getApplicationDocumentsDirectory();
    return File(join(directory.path, fileName));
  }

  Future<Directory> localDir(String dirName) async {
    Directory directory = await getApplicationDocumentsDirectory();
    return Directory(join(directory.path, dirName));
  }

  Future<String> load(String fileName) async {
    File file = await localFile(fileName);
    return file.readAsString();
  }

  Future<String> store(String contents, String fileName) async {
    File file = await localFile(fileName);
    file.writeAsString(contents);
    return file.path;
  }

  Future<String> storeBytes(List<int> contents, String fileName) async {
    File file = await localFile(fileName);
    file.writeAsBytes(contents);
    return file.path;
  }
}