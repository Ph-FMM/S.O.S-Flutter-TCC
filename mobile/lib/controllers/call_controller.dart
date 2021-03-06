import 'package:http/http.dart' as http;

import 'package:SOS_Brasil/models/call.dart';

class CallController {
  static Future<String> create(Call call, String token, String baseUrl) async {
    try {
      String url = baseUrl + "/call";

      var req = http.MultipartRequest("POST", Uri.parse(url));

      req.headers["Content-Type"] = "multipart/form-data";
      req.headers["Authorization"] = "Bearer " + token;

      req.fields["title"] = call.title;
      req.fields["description"] = call.description;
      req.fields["isPersonal"] = call.isPersonal.toString();
      req.fields["latitude"] = call.latitude.toString();
      req.fields["longitude"] = call.longitude.toString();
      req.fields["user_id"] = call.userId.toString();

      if (call.imageFile != null) {
        req.files.add(http.MultipartFile.fromBytes(
          "imageFile",
          call.imageFile.readAsBytesSync(),
          filename: call.imageFile.path.split("/").last,
        ));
      }

      if (call.audioFile != null) {
        req.files.add(http.MultipartFile.fromBytes(
          "audioFile",
          call.audioFile.readAsBytesSync(),
          filename: call.audioFile.path.split("/").last,
        ));
      }

      var res = await req.send().timeout(Duration(seconds: 30));
      if (res.statusCode == 200) {
        return await res.stream.bytesToString();
      } else
        return "";
    } catch (e) {
      print(e);
      return "";
    }
  }
}
