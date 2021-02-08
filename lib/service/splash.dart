
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../homepage_dart.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4),
            ()=>Navigator.push(context,
            MaterialPageRoute(builder:
                (context) =>
                    Employ()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child:Image.network("https://cdn.dribbble.com/users/563824/screenshots/3306683/untitled-6-110.gif"),
    );
  }
}

