
import 'dart:io';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';



/// Gets the given paths embeded metadata
Future<Metadata> getMetadata(String path) async {

  final metadata = await MetadataRetriever.fromFile(File(path));

  return metadata;
}
