import 'dart:convert';
import 'dart:io';

/// Used to write log files
///
/// taken from https://github.com/SourceHorizon/logger/blob/main/lib/src/outputs/file_output.dart
class FileOutput {
  final File file;
  final bool overrideExisting;
  final Encoding encoding;
  IOSink? _sink;

  FileOutput({
    required this.file,
    this.overrideExisting = false,
    this.encoding = utf8,
  });

  Future<void> init() async {
    _sink = file.openWrite(
      mode: overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend,
      encoding: encoding,
    );
  }

  void output(List<String> event) {
    _sink?.writeAll(event, '\n');
    _sink?.writeln();
  }

  Future<void> destroy() async {
    await _sink?.flush();
    await _sink?.close();
  }
}
