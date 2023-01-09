import 'package:chatapp/controller.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'variable.dart';
import 'dart:convert' as convert;

class Settings extends StatelessWidget {
  final websoc = Get.find<Websockets>();
  final String username, userid;
  Settings(this.username, this.userid);

  _uploadimage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
      allowMultiple: false,
    );
    if (result != null) {
      var file = result.files.first;
      var req =
          http.MultipartRequest('POST', Uri.parse(postavatar + '/' + userid));
      req.files.add(
        http.MultipartFile.fromBytes('img', file.bytes, filename: file.name),
      );
      await req.send();
      var _data = convert.jsonEncode({
        'event': 'avatarup',
        'data': userid,
      });
      websoc.send(_data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1c2e46),
      body: Container(
        margin: EdgeInsets.all(10),
        color: Colors.transparent,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                ),
                Spacer(),
                IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.arrow_right_alt),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
            Container(
              padding: EdgeInsets.all(33),
              margin: EdgeInsets.all(20),
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Obx(
                    () => Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(websoc.users[userid]),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () {
                      _uploadimage();
                    },
                  ),
                  Row(
                    children: [
                      Text(username),
                      SizedBox(
                        width: 1,
                      ),
                      IconButton(icon: Icon(Icons.edit), onPressed: () {})
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
