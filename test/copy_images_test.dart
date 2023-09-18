import 'dart:io';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;
import 'package:image_copy/copy_images.dart';

void main() {
  group('Image Copy Tests', () {
    // Define test directories
    var sourceDirectory = '${Directory.current.path}/test_data/source';
    var destinationDirectory = '${Directory.current.path}/test_data/destination';

    setUp(() {
      // Set up destination directory before each test
      if (Directory(destinationDirectory).existsSync()) {
        Directory(destinationDirectory).deleteSync(recursive: true);
      } else {
        Directory(destinationDirectory).createSync(recursive: true);
      }
    });

    tearDown(() {
      // Clean up destination directory after each test
      if (Directory(destinationDirectory).existsSync()) {
        Directory(destinationDirectory).deleteSync(recursive: true);
      }
    });

    test('Copy images from source to destination', () {
      Progress progress = copyImages(sourceDirectory, destinationDirectory).last;

      var files = Directory(destinationDirectory).listSync(recursive: true, followLinks: true);
      expect(files.length, greaterThan(0));
      for (var file in files) {
        expect(file.existsSync(), true);
      }

      expect(progress.total, 2);
      expect(progress.completed(), 2);
    });

    test('Copied images have correct folder structure', () {
      copyImages(sourceDirectory, destinationDirectory).last;

      List<String> expectedPaths = [
        '2023/08-17/data.txt',
        '2023/08-17/untsunts.dat',
        // Add more expected paths based on your test data
      ];

      for (var expectedPath in expectedPaths) {
        var file = File(path.join(destinationDirectory, expectedPath));
        expect(file.existsSync(), true);
      }
    });

    test('Copy new images only', () {
      copyImages(sourceDirectory, destinationDirectory).last;
      Iterable<Progress> iterable = copyImages(sourceDirectory, destinationDirectory);

      List<String> expectedPaths = [
        '2023/08-17/data.txt',
        '2023/08-17/untsunts.dat',
        // Add more expected paths based on your test data
      ];

      for (var expectedPath in expectedPaths) {
        var file = File(path.join(destinationDirectory, expectedPath));
        expect(file.existsSync(), true);
      }
      expect(iterable.isEmpty, true);
    });
  });
}
