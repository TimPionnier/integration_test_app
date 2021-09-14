import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:integration_test/integration_test_driver_extended.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<void> main() async {
  try {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    await integrationDriver(
      onScreenshot: (String screenshotName, List<int> screenshotBytes) async {
        final File image = await File('screenshots/$screenshotName.png')
            .create(recursive: true);
        image.writeAsBytesSync(screenshotBytes);

        Uint8List data = Uint8List.fromList(screenshotBytes);

        firebase_storage.Reference ref =
            storage.ref('screenshots/$screenshotName.png');

        // Upload raw data.
        await ref.putData(data);
        // Get raw data.
        Uint8List? downloadedData = await ref.getData();
        // prints -> Hello World!
        print(utf8.decode(downloadedData!));
        return true;
      },
    );
  } catch (e) {
    print('Error occured: $e');
  }
}
