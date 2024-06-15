// import 'package:lottie/lottie.dart';
// import 'package:db4/getstarted%20page.dart';
// import 'package:db4/weightgain.dart';
// import 'package:db4/weightloss.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'login.dart';
//
// class page extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.purple,
//         title: Text(
//           'My FitnessPlanner',
//           textAlign: TextAlign.right,
//           style: TextStyle(
//             color: Colors.white,
//             fontStyle: FontStyle.italic,
//             fontWeight: FontWeight.bold,
//             fontSize: 24,
//           ),
//         ),
//         centerTitle: false,
//       ),
//
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               SizedBox(height: 40),
//               // Lottie Animation
//               Lottie.asset(
//                 'assets/images/nextpage.json', // Replace with the actual path to your Lottie animation file
//                 width:280,
//                 height: 280, // Adjust the height as needed
//                 repeat: true,
//                 reverse:true,
//               ),
//               SizedBox(height: 40),
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//
//                   children: [
//                     Text(
//                       'Choose Your Goal',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),
//                     SizedBox(height: 40),
//                     TextField(
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.purple, width: 3),
//                         ),
//                       ),
//                       readOnly: true,
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontStyle: FontStyle.italic,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                       controller: TextEditingController(
//                         text: 'Weight Gain',
//                       ),
//                       onTap: () {
//                         _storeSelectionAndNavigate(context, 'weightgain');
//                         Navigator.of(context).push(MaterialPageRoute(
//                           builder: (BuildContext context) => WeightGain(),
//                         ));
//                       },
//                     ),
//                     SizedBox(height: 30),
//                     TextField(
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.purple, width: 3),
//                         ),
//                       ),
//                       readOnly: true,
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontStyle: FontStyle.italic,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                       controller: TextEditingController(
//                         text: 'Weight Loss',
//                       ),
//                       onTap: () {
//                         _storeSelectionAndNavigate(context, 'weightloss');
//                         Navigator.of(context).push(MaterialPageRoute(
//                           builder: (BuildContext context) => weightloss(),
//                         ));
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Positioned(
//             left: 10,
//             bottom: 10,
//             child: ElevatedButton(
//               onPressed: () {
//                 // Add your admin button action here
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (BuildContext context) => LoginPage(),
//                 ));
//               },
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
//               ),
//               child: Text(
//                 'Admin',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   _storeSelectionAndNavigate(BuildContext context, String selection) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('selectedPage', selection);
//     Navigator.of(context).push(MaterialPageRoute(
//       builder: (BuildContext context) => (selection == 'weightgain') ? WeightGain() : weightloss(),
//     ));
//   }
// }
import 'package:db4/weightgain.dart';
import 'package:db4/weightloss.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:db4/getstarted%20page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:db4/adminpanel.dart';
import 'login.dart';

class page extends StatelessWidget {
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            onPressed: () {
              // Navigate to user account page
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => LoginPage(),
              ));
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 40),
              // Lottie Animation
              Lottie.asset(
                'assets/images/nextpage.json',
                // Replace with the actual path to your Lottie animation file
                width: 280,
                height: 280, // Adjust the height as needed
                repeat: true,
                reverse: true,
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Choose Your Goal',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 40),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple, width: 3),
                        ),
                      ),
                      readOnly: true,
                      style: TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      controller: TextEditingController(
                        text: 'Weight Gain',
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => WeightGain(),
                        ));
                      },
                    ),
                    SizedBox(height: 30),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple, width: 3),
                        ),
                      ),
                      readOnly: true,
                      style: TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      controller: TextEditingController(
                        text: 'Weight Loss',
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => weightloss(),
                        ));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: IconButton(
              icon: Icon(
                Icons.person,
                color: Colors.purple,
              ),
              onPressed: () {
                // Navigate to dietitian page or perform other actions here
              },
            ),
          ),
        ],
      ),
    );
  }
}