import 'dart:async';

import 'package:db4/stepcounter.dart';
import 'package:flutter/material.dart';
import 'package:db4/weightgaindashboard.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'getstarted page.dart';
import 'nextpage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToSelectedDashboard();
  }

  Future<void> navigateToSelectedDashboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String selectedPage = prefs.getString('selectedPage') ?? '';
    Widget dashboard;
    if (selectedPage == 'weightgain') {
      dashboard = MyHomePage();
    } else if (selectedPage == 'weightloss') {
      dashboard = step();
    } else {
      // Default to WeightGainDashboard if no selection is made
      dashboard =welcome();
    }
    Timer(Duration(seconds:12),(){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => dashboard,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    // Your splash screen UI here
    return Scaffold(
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/images/pics.json',height: 300,width: 300,repeat:true,reverse:true,), // Replace with your animation file path
            // Adjust spacing as needed
            Text(
              '',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900,color: Colors.purple,fontStyle: FontStyle.italic,),
            ),
          ],
        ), // Placeholder for the splash screen UI
      ),
    );
  }
}
