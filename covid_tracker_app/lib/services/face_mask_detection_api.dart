import 'package:covid_tracker_app/models/face_mask_detection_api_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class FaceMaskDetectionAPI {
  final endpoint =
      "http://ec2-52-66-199-153.ap-south-1.compute.amazonaws.com:8080";

  Future<FaceMaskDetectionAPIModel> uploadImageForFaceMaskDetection(
      {required File file, required String filename}) async {
    var url = Uri.parse('$endpoint');

    //MultiPart request
    var request = http.MultipartRequest('POST', url);
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile(
        'file',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: filename,
        contentType: MediaType('image', 'jpg'),
      ),
    );
    request.headers.addAll(headers);

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.toBytes();
      var result = String.fromCharCodes(responseData);

      var jsonResponse = convert.jsonDecode(result);

      return FaceMaskDetectionAPIModel(
        label: jsonResponse['label'],
        accuracy: jsonResponse['accuracy'],
      );
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw response;
    }
  }
}
