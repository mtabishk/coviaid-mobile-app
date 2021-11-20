import 'package:covid_tracker_app/services/auth.dart';
import 'package:covid_tracker_app/services/face_mask_detection_api.dart';
import 'package:covid_tracker_app/services/unlock_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class FaceUnlockPage extends StatefulWidget {
  const FaceUnlockPage({Key? key}) : super(key: key);

  @override
  State<FaceUnlockPage> createState() => _FaceUnlockPageState();
}

class _FaceUnlockPageState extends State<FaceUnlockPage> {
  File? _image;
  final imagePicker = ImagePicker();
  dynamic result;

  // state variable
  bool _loading = false;
  bool _showError = false;

  Future<void> _getImage() async {
    try {
      final image = await imagePicker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front);

      if (image != null) {
        if (this.mounted) {
          setState(() {
            _image = File(image.path);
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    String? photoUrl = auth.currentuser?.photoURL ?? null;
    return Scaffold(
      appBar: AppBar(
        title: Text('Wear a mask to Unlock'),
        centerTitle: true,
        elevation: 1,
        actions: <Widget>[
          photoUrl != null
              ? CircleAvatar(
                  radius: 20.0,
                  child: ClipRRect(
                    child: Image.network(photoUrl.toString()),
                    borderRadius: BorderRadius.circular(30),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.account_box),
                  onPressed: null,
                ),
          SizedBox(width: 8.0),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClipRRect(
                child: _image == null
                    ? Image.asset("assets/face.png", width: 300, height: 300)
                    : Image.file(_image as File, width: 300, height: 300),
              ),
              if (_loading) CircularProgressIndicator(),
              if (_showError)
                Text("Unable to detect the mask. Please wear one to stay safe.",
                    style: TextStyle(color: Colors.red)),
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: () async {
                    await _getImage();
                    setState(() {
                      _loading = true;
                    });
                    try {
                      if (_image != null) {
                        //Face Mask Detection API
                        final res = await FaceMaskDetectionAPI()
                            .uploadImageForFaceMaskDetection(
                                file: _image as File,
                                filename: "sample_image.jpg");
                        print('Label: ${res.label} Accuracy: ${res.accuracy}');
                        if (res.label == 'Mask') {
                          Provider.of<UnlockProvider>(context, listen: false)
                              .faceIsDetected();
                        } else if (res.label == 'No Mask') {
                          setState(() {
                            _showError = true;
                          });
                        }
                        // For testing purpose (No API)
                        // Provider.of<UnlockProvider>(context, listen: false)
                        //     .faceIsDetected();
                      }
                    } catch (e) {
                      print(e.toString());
                      setState(() {
                        _showError = true;
                      });
                    } finally {
                      setState(() {
                        _loading = false;
                      });
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_open),
                      SizedBox(width: 4.0),
                      Text("Unlock"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
