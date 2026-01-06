import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String?> saveVideoToDownloads(File videoFile, String fileName) async {
  if (!await Permission.storage.request().isGranted) return null;

  Directory? downloadsDir = await getExternalStorageDirectory();
  String newPath = "${downloadsDir!.path}/$fileName";

  File newFile = await videoFile.copy(newPath);
  return newFile.path;
}
