import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

class FileService {
  void openFile({required String path}) {
    OpenFilex.open(path);
  }

  Future<File> copyFile(
      {required PlatformFile? pickedfile,
      required String path,
      required String filename,
      required String extension}) async {
    final newFile = File('path/${removeDiacritics(filename)}.extension');
    return File(pickedfile!.path!).copy(newFile.path);
  }
}
