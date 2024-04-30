import 'dart:io';
import 'package:open_filex/open_filex.dart';

class FileService {
  void openFile({required String path}) {
    OpenFilex.open(path);
  }

  Future<File> copyFile(
      {required String oldpath,
      required String path,
      required String filename,
      required String extension}) async {
    File oldFile = File(oldpath);
    return await File('$path/$filename.$extension')
        .create(recursive: true)
        .then((File file) {
      return oldFile.copy('$path/$filename.$extension');
    });
  }
}
