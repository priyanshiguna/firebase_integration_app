import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({Key? key}) : super(key: key);

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  final ImagePicker image = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;
  XFile? picture;

  setImage() async {
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
            const SizedBox(height: 50),
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
                setImage();
              },
              child: const Text('Upload image',
                  style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
