import 'package:db4/tablegain.dart';
import 'package:db4/tableloss.dart';
import 'package:db4/weightgaintable.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:db4/getstarted%20page.dart';
import 'package:db4/weightgain.dart';
import 'package:db4/weightloss.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'adminpanel.dart';
import 'Approved.dart';
import 'login.dart';
import 'losstable.dart';
import 'nextpage.dart';

class admin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'GriftFit',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 40),
              Center(
                child: Text(
                  'Admin Workspace',
                  style: TextStyle(
                    color: Colors.purple.shade900,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    shadows: [
                      Shadow(
                        color: Colors.deepPurple,
                        blurRadius: 2,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
              // Lottie Animation
              Lottie.asset(
                'assets/images/ad.json',
                // Replace with the actual path to your Lottie animation file
                width: 280,
                height: 280, // Adjust the height as needed
                repeat: true,
                reverse: true,
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // Background color for Weight Gain TextField
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blue[50],// Fill color same as container color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                            // borderSide: BorderSide(color: Colors.blue, width: 7),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                            borderSide: BorderSide(color: Colors.blue, width: 10),
                          ),
                        ),
                        readOnly: true,
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.blue,
                              blurRadius: 1,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        controller: TextEditingController(
                          text: 'Weight Gain',
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => gaintable(),
                          ));
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      // Background color for Weight Loss TextField
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.deepPurple.shade400.withOpacity(0.2),
                          // Fill color same as container color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                            // borderSide: BorderSide(color: Colors.deepPurple, width: 3),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                            borderSide: BorderSide(color: Colors.deepPurple, width: 10),
                          ),
                        ),
                        readOnly: true,
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.purple,
                              blurRadius: 1,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        controller: TextEditingController(
                          text: 'Weight Loss',
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => tableloss(),
                          ));
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      // Background color for Payment TextField
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.green.shade400.withOpacity(0.2), // Fill color same as container color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                            // borderSide: BorderSide(color: Colors.green, width: 3),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                            borderSide: BorderSide(color: Colors.green, width: 10),
                          ),
                        ),
                        readOnly: true,
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.green,
                              blurRadius: 1,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        controller: TextEditingController(
                          text: 'Payment',
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>Approved(),
                          ));
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      // Background color for Dietitian TextField
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.pink.shade400.withOpacity(0.2),
                          // Fill color same as container color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                            // borderSide: BorderSide(color: Colors.pink, width: 3),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                            borderSide: BorderSide(color: Colors.pink, width: 10),
                          ),
                        ),
                        readOnly: true,
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.pink,
                              blurRadius: 1,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        controller: TextEditingController(
                          text: 'Dietitian',
                        ),
                        onTap: () {
                          // Implement navigation or other functionality here
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>page()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
