import 'package:get/get.dart';
import 'variable.dart';
import 'models.dart';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/html.dart';
import 'controller.dart';

class LoginSignup extends StatelessWidget {
  final _loginsignupkey = GlobalKey<FormState>();
  final button1, button2, nav;
  String _username, _password;

  LoginSignup(this.button1, this.button2, this.nav);

  Widget _usernametext() {
    return TextFormField(
      style: TextStyle(
        color: Color(0xff192a3e),
      ),
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.account_box,
            color: Color(0xff192a3e),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          hintStyle: TextStyle(
            color: Colors.blueGrey,
          ),
          hintText: 'username'),
      onSaved: (val) {
        _username = val;
      },
      validator: (username) {
        if (username.isEmpty) {
          return 'enter username';
        }
        return null;
      },
    );
  }

  Widget _passwordtext() {
    return TextFormField(
      style: TextStyle(
        color: Color(0xff192a3e),
      ),
      obscureText: true,
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.remove_red_eye,
            color: Color(0xff192a3e),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          hintStyle: TextStyle(
            color: Colors.blueGrey,
          ),
          hintText: 'password'),
      onSaved: (val) {
        _password = val;
      },
      validator: (username) {
        if (username.isEmpty) {
          return 'enter password';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1c2e46),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          height: 300,
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Form(
            key: _loginsignupkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _usernametext(),
                _passwordtext(),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(button1),
                  textColor: Colors.white,
                  color: Color(0xff192a3e),
                  elevation: 10,
                  onPressed: () async {
                    if (_loginsignupkey.currentState.validate()) {
                      _loginsignupkey.currentState.save();
                      var data = convert.jsonEncode(
                          {'username': _username, 'password': _password});
                      var url = baseurl + '/' + button1;
                      try {
                        final headers = {"Content-type": "application/json"};
                        var response = await http.post(
                          url,
                          headers: {"Content-Type": "application/json"},
                          body: data,
                        );
                        if (response.statusCode == 200) {
                          var resp = convert.jsonDecode(response.body);
                          if (resp['status'] == 1) {
                            var eusername = resp['username'];
                            var euserid = resp['userid'];
                            var channel = HtmlWebSocketChannel.connect(
                                wsurl + '/' + euserid);
                            Get.put(Websockets(channel));
                            Navigator.of(context).pushNamed('/chat',
                                arguments:
                                    ModelLoginSignup(eusername, euserid));
                          } else {
                            Navigator.of(context).pushNamed('/error',
                                arguments: 'Incorrect password or username');
                          }
                        } else {
                          Navigator.of(context)
                              .pushNamed('/error', arguments: 'Server error');
                        }
                      } catch (e) {
                        Navigator.of(context).pushNamed('/error',
                            arguments: 'Unable to connect to the server');
                      }
                    }
                  },
                ),
                MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(button2),
                    textColor: Colors.white,
                    color: Color(0xff192a3e),
                    elevation: 10,
                    onPressed: () {
                      Navigator.of(context).pushNamed(nav);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
