import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class step extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Circular Percentage Indicators'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular Percentage Indicator in Purple Color
            CircularPercentIndicator(
              radius: 110,
              lineWidth: 12,
              percent: 0.8,
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: Colors.transparent,
              progressColor: Colors.purple,
              startAngle: 218,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.shoePrints,
                    size: 40,
                    color: Colors.black,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '566 Steps',
                    style: TextStyle(color: Colors.black,fontStyle: FontStyle.italic,fontWeight:FontWeight.w900,),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            // Wrap the Row with a Container to occupy the full width
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildCircularIndicator(0.5, Colors.transparent, Colors.transparent,
                      FontAwesomeIcons.fire,Colors.orange, '677 kcal'),
                  buildCircularIndicator(0.5, Colors.transparent, Colors.transparent,
                      FontAwesomeIcons.route,  Colors.red, '677 km'),
                  buildCircularIndicator(0.5, Colors.transparent, Colors.transparent,
                      FontAwesomeIcons.shoePrints,Colors.blueAccent, '677 Steps'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCircularIndicator(double percent, Color progressColor,
      Color backgroundColor, IconData iconData, Color iconColor, String text) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 40,
          lineWidth: 7,
          percent: percent,
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: backgroundColor,
          progressColor: progressColor,
          center: Icon(
            iconData,
            size: 40,
            color: iconColor,

          ),
        ),
        SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(color: Colors.black,fontStyle: FontStyle.italic,fontWeight:FontWeight.w900,),

        ),
      ],
    );
  }
}


