import 'dart:io';

import 'package:flutter_best_practices/build_config.dart';
import 'package:flutter_best_practices/utils/logging.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static Future<Directory> getOrCreateAppDataDir() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final dirPath = path.join(
      appDocDir.path,
      BuildConfig.instance.appDocumentDirSubFolder,
    );
    final dir = Directory(dirPath);
    if (!await dir.exists()) {
      devLog(' - Creating app data dir', name: 'FileHelper');
      devLog('     ${dir.path}', name: 'FileHelper');
      await dir.create(recursive: true);
    }
    return Directory(dirPath);
  }

  static Future<Directory> getOrCreateUserDataDir() async {
    try {
      final appDataDir = await getOrCreateAppDataDir();
      // Example of scoping data to a user directory.
      // final userId = Provider.get<AuthManager>().userId;
      // if (userId == null) {
      //   // Custom exception
      //   throw SessionUserIdNotSet();
      // }
      // final dirPath = path.join(appDataDir.path, 'user-$userId');
      final dirPath = appDataDir.path;
      final dir = Directory(dirPath);
      if (!await dir.exists()) {
        devLog(' - Creating user data dir', name: 'FileHelper');
        devLog('     ${dir.path}', name: 'FileHelper');
        await dir.create(recursive: true);
      }
      return Directory(dirPath);
      // } on SessionUserIdNotSet {
      //   devLog(
      //     'Session user id was not set',
      //     name: 'FileHelper',
      //   );
    } catch (e, stackTrace) {
      // if (e is SessionUserIdNotSet) {
      //   message = 'Cannot get-or-create user data dir, no user ID is available';
      // } else {
      //   message = 'Something went wrong with get-or-create user data dir';
      // }
      devLog(
        'Something went wrong in getOrCreateUserDataDir',
        error: e,
        stackTrace: stackTrace,
        name: 'FileHelper',
      );
      rethrow;
    }
  }

  static Future<void> moveFileToDownloads(
    File tempFile,
    String fileName,
  ) async {
    final downloadsDir = await getDownloadsDirectory();
    if (downloadsDir == null) {
      devLog('Could not move file to downloads folder', name: 'FileHelper');
    } else {
      final downloadsFilePath = path.join(downloadsDir.path, fileName);
      devLog('Moving file to $downloadsFilePath', name: 'FileHelper');
      await tempFile.copy(downloadsFilePath);
      await tempFile.delete();
    }
  }
}
