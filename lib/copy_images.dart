import 'dart:io';
import 'package:path/path.dart' as path;

Future<void> copyNewImagesToFolderStructure(List<File> images, String destinationRoot) async {
  for (var image in images) {
    DateTime dateTaken = await getFileModifiedDate(image);
    String year = dateTaken.year.toString();
    String month = dateTaken.month.toString().padLeft(2, '0');
    String day = dateTaken.day.toString().padLeft(2, '0');

    String destinationPath = path.join(destinationRoot, year, '$month-$day');
    Directory(destinationPath).createSync(recursive: true);

    String imageName = path.basename(image.path);
    String destinationImage = path.join(destinationPath, imageName);

    // Check if the destination image already exists
    if (!File(destinationImage).existsSync()) {
      image.copySync(destinationImage);
    }
  }
}

Future<DateTime> getFileModifiedDate(File file) async {
  try {
    var fileStat = await file.stat();
    return fileStat.modified;
  } catch (e) {
    print('Error reading file modification date: $e');
    return DateTime(2000, 1, 1);
  }
}

List<File> findAllFilesInDirectory(String sourceDirectory) {
  List<File> files = [];
  Directory directory = Directory(sourceDirectory);

  if (directory.existsSync()) {
    for (var entity in directory.listSync()) {
      if (entity is File) {
        files.add(entity);
      }
    }
  }

  return files;
}

Future<void> copyImages(String sourceDir, String destinationDir) async {
  List<File> images = findAllFilesInDirectory(sourceDir);
  await copyNewImagesToFolderStructure(images, destinationDir);
}