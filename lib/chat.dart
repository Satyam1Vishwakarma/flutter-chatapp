import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:get/get.dart';
import 'controller.dart';
import 'models.dart';

class Chat extends StatelessWidget {
  final websoc = Get.find<Websockets>();
  var _controller = TextEditingController();
  var _scroll = ScrollController();
  var _key = GlobalKey<FormState>();
  final String username, userid;

  void dispose() {
    _controller.dispose();
  }

  List<Widget> _users() {
    var _userslist = <Widget>[];

    for (var url in websoc.users.values) {
      _userslist.add(
        Container(
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(url),
              ),
              SizedBox(
                width: 9,
              )
            ],
          ),
        ),
      );
    }
    return _userslist;
  }

  _message() {
    var _messagelist = <Widget>[];
    for (var messi in websoc.message) {
      var _uid = messi['userid'];
      _messagelist.add(
        Container(
          margin: _uid == userid
              ? EdgeInsets.only(top: 20, bottom: 20, right: 10)
              : EdgeInsets.only(top: 20, bottom: 20, left: 10),
          alignment:
              _uid == userid ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            children: [
              Container(
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(websoc.users[_uid]),
                ),
              ),
              Container(
                child: Text(
                  messi['data'],
                  style: TextStyle(
                    color: _uid == userid ? Color(0xff1c2e46) : Colors.white,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                decoration: BoxDecoration(
                  color: _uid == userid ? Colors.white70 : Color(0xff1c2e46),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
    _messagelist.add(Container(
        child: SizedBox(
      height: 100,
    )));
    return _messagelist;
  }

  Chat(this.username, this.userid);
  @override
  Widget build(BuildContext context) {
    _inputbox() {
      return Container(
        height: 70,
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).pushNamed('/settings',
                      arguments: ModelLoginSignup(username, userid));
                }),
            Expanded(
              child: Form(
                key: _key,
                child: TextFormField(
                  onFieldSubmitted: (message) {
                    if (_key.currentState.validate()) {
                      var _data = convert.jsonEncode({
                        'event': 'message',
                        'data': message,
                        'userid': userid,
                      });
                      websoc.send(_data);
                      _controller.clear();
                      _scroll.animateTo(
                        _scroll.position.maxScrollExtent,
                        duration: Duration(
                          seconds: 1,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'enter a message';
                    }
                  },
                  controller: _controller,
                  autofocus: true,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    hintText: 'send a message..',
                  ),
                ),
              ),
            ),
            IconButton(
              color: Color(0xff192a3e),
              icon: Icon(
                Icons.send,
              ),
              onPressed: () {
                if (_key.currentState.validate()) {
                  var _data = convert.jsonEncode({
                    'event': 'message',
                    'data': _controller.text,
                    'userid': userid,
                  });
                  websoc.send(_data);
                  _controller.clear();
                  _scroll.animateTo(
                    _scroll.position.maxScrollExtent,
                    duration: Duration(
                      seconds: 1,
                    ),
                    curve: Curves.fastLinearToSlowEaseIn,
                  );
                }
              },
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xff1c2e46),
      body: Column(
        children: [
          Container(
            height: 70,
            color: Colors.transparent,
            child: Obx(
              () => ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(8),
                children: _users(),
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
              child: Material(
                elevation: 20,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: Obx(
                    () => ListView(
                      physics: BouncingScrollPhysics(),
                      reverse: true,
                      controller: _scroll,
                      padding: EdgeInsets.only(top: 15.0),
                      children: _message(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.white,
            child: _inputbox(),
          ),
        ],
      ),
    );
  }
}
