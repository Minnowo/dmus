import 'package:dmus/core/Util.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ExternalStorageModel {
  Future<void> deleteFileFromExternalStorage(String? filePath) async {
    final downloadsDirectory = await getExternalStorageDirectory();



    if (downloadsDirectory == null) {
      logging.finest('External storage directory is null. Make sure external storage access is granted.');
      return;
    }

    try {
      final file = File(filePath!);

      if (await file.exists() && file.parent.path == downloadsDirectory.path) {
        await file.delete();
        logging.finest('File deleted successfully.');
      } else {
        logging.finest('File does not exist or is not in the downloads directory.');
      }
    } catch (e) {
      logging.finest('Error deleting the file: $e');
    }
  }
}