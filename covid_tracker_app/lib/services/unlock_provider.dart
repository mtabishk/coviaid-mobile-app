import 'package:flutter/cupertino.dart';

class UnlockProvider extends ChangeNotifier {
  bool faceDetected = false;

  void faceIsDetected() {
    notifyListeners();
    faceDetected = !faceDetected;
  }
}
