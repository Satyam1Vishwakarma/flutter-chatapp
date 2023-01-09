import 'variable.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Websockets extends GetxController {
  var users = <String, String>{}.obs;
  var message = [].obs;
  var channel;

  Websockets(this.channel);

  @override
  void onInit() async {
    await _getusers();
    _connection();
    super.onInit();
  }

  _connection() {
    channel.stream.listen((data) async {
      var jdata = convert.jsonDecode(data);
      var event = jdata['event'];

      if (event == 'message') {
        message.add(jdata);
      } else if (event == 'online') {
        var uid = jdata['userid'];
        var response = await http.get(getavatar + '/' + uid);
        var resp = convert.jsonDecode(response.body);

        users[uid] = resp['data'];
      } else if (event == 'offline') {
        users.remove(jdata['userid']);
      } else if (event == 'avatarup') {
        var uid = jdata['data'];
        var response = await http.get(getavatar + '/' + jdata['data']);
        var resp = convert.jsonDecode(response.body);
        users[uid] = resp['data'];
      }
    });
  }

  _getusers() async {
    var response = await http.get(getusers);
    var resp = convert.jsonDecode(response.body)['data'];
    List<String> data = List.from(resp);

    for (var i in data) {
      var response = await http.get(getavatar + '/' + i);
      var resp = convert.jsonDecode(response.body);
      if (resp['status'] == 1) {
        users[i] = resp['data'];
      }
    }
  }

  send(data) {
    channel.sink.add(data);
  }
}
