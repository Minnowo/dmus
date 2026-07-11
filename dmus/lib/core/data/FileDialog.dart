import 'package:dmus/core/Util.dart';
import 'package:file_picker/file_picker.dart';

/// Opens a file picker to ask the user for 0 or more files
///
/// Returns null if the user does not pick any files / aborts
///
/// Returns a list of all picked files
Future<List<PlatformFile>?> pickMultipleFiles() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

  return result?.files;
}

/// Opens a file picker to ask the user for 0 or more files with music extensions
///
/// Returns null if the user does not pick any files / aborts
///
/// Returns a list of all picked files
Future<List<PlatformFile>?> pickMusicFiles() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowMultiple: true,
    allowedExtensions: musicFileExtensions,
  );

  return result?.files;
}

/// Opens a file picker to ask the user for a directory
///
/// Returns null if the user does not pick any folder / aborts
///
/// Returns the directory path as a string
Future<String?> pickDirectory() async {
  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

  return selectedDirectory;
}

/// Opens a file picker to ask the user for a single database backup file
///
/// Returns null if the user does not pick a file / aborts
///
/// Deliberately does not filter by extension: Android has no registered MIME type for `.db`
/// files, and filtering FileType.custom by an extension with no known MIME type makes the
/// underlying file_picker plugin fail before it even opens a picker
Future<PlatformFile?> pickDatabaseFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result == null || result.files.isEmpty) {
    return null;
  }

  return result.files.first;
}
