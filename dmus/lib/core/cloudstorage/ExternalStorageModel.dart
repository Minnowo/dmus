import 'package:dmus/core/Util.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ExternalStorageModel {
  Future<void> deleteFileFromExternalStorage(String filePath) async {
    final downloadsDirectory = await getExternalStorageDirectory();



    if (downloadsDirectory == null) {
      print('External storage directory is null. Make sure external storage access is granted.');
      return;
    }

    try {
      final file = File(filePath);

      if (await file.exists() && file.parent.path == downloadsDirectory.path) {
        await file.delete();
        print('File deleted successfully.');
      } else {
        print('File does not exist or is not in the downloads directory.');
      }
    } catch (e) {
      print('Error deleting the file: $e');
    }
  }
}