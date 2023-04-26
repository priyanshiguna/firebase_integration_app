import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({Key? key}) : super(key: key);

  @override
  State<FileUploadScreen> createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  final ImagePicker image = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;
  var imageName = "assets/images/Media.png";
  String dataUrl = 'data:text/plain;base64,SGVsbG8sIFdvcmxkIQ==';
  XFile? picture;

  uploadFile() async {
    try {
      Reference ref = storage.ref();
      Reference imageRef = ref.child("image/${picture!.name}");
      File image = File(picture!.path);
      await imageRef.putFile(image);
      String url = await imageRef.getDownloadURL();
      debugPrint("FileUrl ---> $url");
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
  }

  uploadString() async {
    Reference ref = storage.ref();

    Reference dataRef = ref.child("String(URL)/$dataUrl");

    await dataRef.putString(dataUrl, format: PutStringFormat.dataUrl);
  }

  uploadData() async {
    try {
      ByteData bytes = await rootBundle.load(imageName);
      Reference ref = storage.ref();
      Reference dataString = ref.child(imageName);
      Uint8List rawData =
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
      await dataString.putData(rawData);
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
  }

  downloadData() async {
    try {
      debugPrint(" print-->  ${picture!.name}");
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = "${appDocDir.absolute}assets/images/Media.jpg";
      File file = File(filePath);
      Reference ref = storage.ref();

      Reference imageRef = ref.child("image/${picture!.name}");
      String url = await imageRef.getDownloadURL();
      debugPrint("DownloadUrl ---> $url");

      await imageRef.writeToFile(file);
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
  }

  removeImage() async {
    try {
      Reference ref = storage.ref();

      Reference imageRef = ref.child("image/${picture!.name}");

      await imageRef.delete();
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Image To Firebase"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                picture = await image.pickImage(source: ImageSource.gallery);
                setState(() {});
              },
              child: Container(
                height: 220,
                width: 220,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                  shape: BoxShape.circle,
                ),
                child: picture != null
                    ? Image.file(
                        File(picture!.path),
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.add, size: 90),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color(0xFFFFFFFF)),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              onPressed: () {
                uploadFile();
              },
              child: const Text('Upload image File',
                  style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color(0xFFFFFFFF)),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              onPressed: () {
                uploadString();
              },
              child: const Text('Upload String',
                  style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color(0xFFFFFFFF)),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              onPressed: () {
                uploadData();
              },
              child: const Text('upload data',
                  style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color(0xFFFFFFFF)),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              onPressed: () {
                removeImage();
              },
              child: const Text('Delete image',
                  style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color(0xFFFFFFFF)),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              onPressed: () {
                downloadData();
              },
              child: const Text('Download File',
                  style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
