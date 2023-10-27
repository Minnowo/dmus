


import 'package:file_picker/file_picker.dart';

Future<List<PlatformFile>?> pickMultipleFiles() async {

  FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

  return result?.files;
}

Future<List<PlatformFile>?> pickMusicFiles() async {

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowMultiple: true,
    allowedExtensions: ['flac', 'mp3', 'ogg', 'opus', 'wav'],
  );

  return result?.files;
}

Future<String?> pickDirectory() async {

  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

  return selectedDirectory;
}
