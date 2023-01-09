import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  final String data;
  Error(this.data);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1c2e46),
      body: Center(
        child: Container(
          height: 400,
          width: 400,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Text(
                'ERROR',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                data,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('home'),
                  textColor: Colors.white,
                  color: Color(0xff192a3e),
                  elevation: 10,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/');
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
