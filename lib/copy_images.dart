import 'dart:io';
import 'package:path/path.dart' as path;

class Progress {
  int _completed;
  final int total;

  Progress({
    required this.total,
  }) : _completed = 0;

  completeOne() {
    _completed++;
  }

  int completed() {
    return _completed;
  }
}

Iterable<Progress> copyNewImagesToFolderStructure(List<File> images, String destinationRoot) sync* {
  Progress progress = Progress(total: images.length);
  for (var image in images) {
    DateTime dateTaken = getFileModifiedDate(image);
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
      progress.completeOne();
      yield progress;
    }
  }
}

DateTime getFileModifiedDate(File file) {
  try {
    var fileStat = file.statSync();
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

Iterable<Progress> copyImages(String sourceDir, String destinationDir) {
  List<File> images = findAllFilesInDirectory(sourceDir);
  return copyNewImagesToFolderStructure(images, destinationDir);
}