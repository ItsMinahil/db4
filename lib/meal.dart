import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:workmanager/workmanager.dart';
import 'package:db4/color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'calculation.dart';
import 'database_handler.dart';

class meal extends StatefulWidget {
  @override
  _MealState createState() => _MealState();
}

class _MealState extends State<meal> {
  int _breakfastCalories = 300;
  int _lunchCalories = 800;
  int _snackCalories = 200;
  int _dinnerCalories = 600;

  int _consumedCalories = 0;
  int _displayedConsumedCalories = 0;
  int _takenBreakfastCalories = 0;
  int _takenLunchCalories = 0;
  int _takenSnackCalories = 0;
  int _takenDinnerCalories = 0;

  @override
  void initState() {
    super.initState();
    _scheduleNotifications();
    _loadCaloriesFromSharedPreferences();
    _checkAndTriggerReset();

  }

  void _loadCaloriesFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _consumedCalories = prefs.getInt('consumed_calories') ?? 0;
      _takenBreakfastCalories = prefs.getInt('taken_breakfast_calories') ?? 0;
      _takenLunchCalories = prefs.getInt('taken_lunch_calories') ?? 0;
      _takenSnackCalories = prefs.getInt('taken_snack_calories') ?? 0;
      _takenDinnerCalories = prefs.getInt('taken_dinner_calories') ?? 0;
      _displayedConsumedCalories = prefs.getInt('displayed_consumed_calories') ?? _consumedCalories;
    });
  }

  void _saveCaloriesToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('consumed_calories', _consumedCalories);
    prefs.setInt('taken_breakfast_calories', _takenBreakfastCalories);
    prefs.setInt('taken_lunch_calories', _takenLunchCalories);
    prefs.setInt('taken_snack_calories', _takenSnackCalories);
    prefs.setInt('taken_dinner_calories', _takenDinnerCalories);
    prefs.setInt('displayed_consumed_calories', _displayedConsumedCalories);
  }


  void _checkAndTriggerReset() {
    // Calculate the initial delay until the scheduled reset time (8:00 AM)
    Duration initialDelay = _calculateInitialDelayreset(8, 0);

    // Schedule the reset to occur after the initial delay
    Timer(initialDelay, _triggerReset);
    print("Reset scheduled for 8:00 AM");
  }

  Duration _calculateInitialDelayreset(int hour, int minute) {
    // Calculate the time until the next occurrence of the specified hour and minute
    DateTime now = DateTime.now();
    DateTime scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);
    if (scheduledTime.isBefore(now)) {
      // If the scheduled time has already passed for today, schedule for the same time tomorrow
      scheduledTime = scheduledTime.add(Duration(days: 1));
    }
    return scheduledTime.difference(now);
  }
  void _triggerReset() {
    setState(() {
      // Reset the consumed calories
      _takenBreakfastCalories = 0;
      _takenLunchCalories = 0;
      _takenSnackCalories = 0;
      _takenDinnerCalories = 0;
      _consumedCalories = 0;
      // Save the reset values to SharedPreferences
      _saveCaloriesToSharedPreferences();
      print("reset compeleted");
    });
  }


  void _scheduleNotifications() {
    // Schedule the first notification at 7:00 AM daily
    Workmanager().registerPeriodicTask(
      "1",
      "notifyBreakfastReminder1",
      frequency: Duration(days: 1), // Repeat daily
      initialDelay: _calculateInitialDelay(7, 0), // Schedule for 7:00 AM
    );

    // Schedule the second notification at 8:30 AM daily
    Workmanager().registerPeriodicTask(
      "2",
      "notifyBreakfastReminder2",
      frequency: Duration(days: 1), // Repeat daily
      initialDelay: _calculateInitialDelay(8, 20), // Schedule for 8:30 AM
    );
  }

  Duration _calculateInitialDelay(int hour, int minute) {
    // Calculate the time until the specified hour and minute
    DateTime now = DateTime.now();
    DateTime scheduledTime = DateTime(now.year, now.month, now.day, hour, minute, 0);
    Duration initialDelay = scheduledTime.difference(now);
    if (initialDelay.isNegative) {
      // If the scheduled time has passed for today, schedule for the same time tomorrow
      scheduledTime = scheduledTime.add(Duration(days: 1));
      initialDelay = scheduledTime.difference(now);
    }
    return initialDelay;
  }


  @override
  Widget build(BuildContext context) {
    _consumedCalories = _takenBreakfastCalories + _takenLunchCalories + _takenSnackCalories + _takenDinnerCalories;

    final String email= ModalRoute.of(context)?.settings.arguments as String;
    Future<Database> openDB() async{
      Database _database=await DatabaseHandler().openDB();
      if(_database!=null)
        return _database;
      else{
        print('null db');
        return _database;
      }
      //print('open fun is called in mwg');
    }
    Future<int> getAgeFromEmail(String email) async {
      Database _database=await openDB();
      var age;
      if( _database!=null){
        List<Map<String, dynamic>> result = await _database.query(
          'WEIGHTGAINUSER',
          columns: ['age'],
          where: 'email = ?',
          whereArgs: [email],
        );

        if (result.isNotEmpty) {
          age = result[0]['age'];
        }
        await _database.close();

      }
      return age;

    }// add ? with int
    Future<int> getHeightFromEmail(String email) async {
      Database _database=await openDB();
      var height;
      if (_database != null) {

        List<Map<String, dynamic>> result = await _database.query(
          'WEIGHTGAINUSER',
          columns: ['height'],
          where: 'email = ?',
          whereArgs: [email],
        );


        if (result.isNotEmpty) {
          height = result[0]['height'];
        }
        await _database.close();
      }
      return height;
    }
    Future<int> get_cweight_FromEmail(String email) async {
      Database _database=await openDB();
      var cweight;
      if (_database != null) {
        List<Map<String, dynamic>> result = await _database.query(
          'WEIGHTGAINUSER',
          columns: ['cweight'],
          where: 'email = ?',
          whereArgs: [email],
        );

        if (result.isNotEmpty) {
          cweight = result[0]['cweight'];
        }

        await _database.close();

      }
      return cweight;
    }
    Future<int> get_gweight_FromEmail(String email) async {
      Database _database=await openDB();
      var gweight;
      if (_database != null) {
        List<Map<String, dynamic>> result = await _database.query(
          'WEIGHTGAINUSER',
          columns: ['gweight'],
          where: 'email = ?',
          whereArgs: [email],
        );

        if (result.isNotEmpty) {
          gweight = result[0]['gweight'];
        }

        await _database.close();
      }
      return gweight;
    }
    Future<String> getGenderFromEmail(String email) async {
      Database _database=await openDB();
      String gender='Male';
      if (_database != null) {
        List<Map<String, dynamic>> result = await _database.query(
          'WEIGHTGAINUSER',
          columns: ['gender'],
          where: 'email = ?',
          whereArgs: [email],
        );

        if (result.isNotEmpty) {
          gender = result[0]['gender'];
        }

        await _database.close();
      }
      return gender;
    }
    Future<String> getActivityLevelFromEmail(String email) async {
      Database _database=await openDB();
      String activity_level='Sedentary';
      if (_database != null) {
        List<Map<String, dynamic>> result = await _database.query(
          'WEIGHTGAINUSER',
          columns: ['activity_level'],
          where: 'email = ?',
          whereArgs: [email],
        );

        if (result.isNotEmpty) {
          activity_level = result[0]['activity_level'];
        }

        await _database.close();
      }
      return activity_level;
    }

    Future<int> fage = getAgeFromEmail(email) ;
    int age=30;
    fage.then((value) {
      if (value != null) {
        age = value.toInt();
        print(age);
      }
    });
    Future<int> fheight = getHeightFromEmail(email) ;
    int height=6;
    fheight.then((value) {
      if (value != null) {
        height = value.toInt();
        print(height);
      }
    });
    Future<int> fcweight = get_cweight_FromEmail(email);
    int cweight=50;
    fcweight.then((value) {
      if (value != null) {
        cweight = value.toInt();
        print(cweight);
      }
    });
    Future<int> fgweight = get_gweight_FromEmail(email);
    int gweight=60;
    fgweight.then((value) {
      if (value != null) {
        gweight = value.toInt();
        print(gweight);
      }
    });
    Future<String> fgender= getGenderFromEmail(email);
    String gender='Male';
    fgender.then((value) {
      if (value != null) {
        gender = value.toString();
        print(gender);
      }
    });
    Future<String> factivity_level= getActivityLevelFromEmail(email);
    String activity_level='Sedentary';
    factivity_level.then((value) {
      if (value != null) {
        activity_level = value.toString();
        print(activity_level);
      }
    });
    Future<int> daily_cal() async{
      int monthsToReach = 2;
      WeightGainCalculator wg_daily_cal=new WeightGainCalculator();
      int daily_calories = await wg_daily_cal.calculateDailyCaloriesNeededToGainWeight
        (cweight, gweight , height ,age,gender,activity_level) ;
      return daily_calories;
    }

    Future<int> total_cal() async{
      int monthsToReach = 2;
      WeightGainCalculator wg_total_cal=new WeightGainCalculator();
      int total_calories = await wg_total_cal.calculateTotalCaloriesToGainWeight(cweight ,gweight,height ,age ,gender,activity_level);
      return total_calories;
    }
    Future<int> b_cal() async{
      int monthsToReach = 2;
      WeightGainCalculator wg_b_cal=new WeightGainCalculator();
      int b_calories = await wg_b_cal.calculateTotalCaloriesToGainWeight(cweight ,gweight,height ,age ,gender,activity_level);
      return b_calories;
    }
    Future<int> l_cal() async{
      int monthsToReach = 2;
      WeightGainCalculator wg_l_cal=new WeightGainCalculator();
      int l_calories = await wg_l_cal.calculateTotalCaloriesToGainWeight(cweight ,gweight,height ,age ,gender,activity_level);
      return l_calories;
    }
    Future<int> s_cal() async{
      int monthsToReach = 2;
      WeightGainCalculator wg_s_cal=new WeightGainCalculator();
      int s_calories = await wg_s_cal.calculateTotalCaloriesToGainWeight(cweight ,gweight,height ,age ,gender,activity_level);
      return s_calories;
    }
    Future<int> d_cal() async{
      int monthsToReach = 2;
      WeightGainCalculator wg_d_cal=new WeightGainCalculator();
      int d_calories = await wg_d_cal.calculateTotalCaloriesToGainWeight(cweight ,gweight,height ,age ,gender,activity_level);
      return d_calories;
    }


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        title: Text(
          'Meal Chart',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // FutureBuilder for total calories
                    FutureBuilder<int>(
                      future: total_cal(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // While waiting for the future to complete, you can show a loading indicator
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          // Handle errors that may occur during the computation
                          return Text("Error: ${snapshot.error}");
                        } else {
                          // Once the future completes successfully, you can access the result
                          int totalCalories = snapshot.data ?? 0;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Total Calories: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$totalCalories',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    SizedBox(height: 8),
                    // Static row for displayed consumed calories
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Taken Calories: ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '$_displayedConsumedCalories',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FutureBuilder<int>(
                  future: daily_cal(), // Specify your future function here
                  builder: (context, snapshot) {
                    // Check the connection state
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Show a loading spinner while waiting for the future to complete
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      // Handle any error in the future
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Future has completed successfully, display the data
                      num dailyCalories = snapshot.data ?? 0.0; // Retrieve the future's value
                      // Build the UI with the retrieved data
                      return CircularPercentIndicator(
                        radius: 100,
                        lineWidth: 10,
                        circularStrokeCap: CircularStrokeCap.round,
                        backgroundColor: Colors.transparent,
                        progressColor: Colors.deepPurple,
                        percent: 0.8, // You can adjust this value as needed
                        startAngle: 218,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Today Calories',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '$dailyCalories',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Consumed: $_consumedCalories',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSmallSquareBox(Icons.local_dining, 'Breakfast',
                      _breakfastCalories, _takenBreakfastCalories,
                      AppColors.breakfast),
                  _buildSmallSquareBox(Icons.fastfood, 'Lunch', _lunchCalories,
                      _takenLunchCalories, AppColors.lunch),
                  _buildSmallSquareBox(
                      Icons.local_cafe, 'Snack', _snackCalories,
                      _takenSnackCalories, AppColors.snack),
                  _buildSmallSquareBox(
                      Icons.restaurant, 'Dinner', _dinnerCalories,
                      _takenDinnerCalories, AppColors.dinner1),
                ],
              ),
              SizedBox(height: 70),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMealType('Breakfast', context),
                  _buildMealType('Lunch', context),
                  _buildMealType('Snack', context),
                  _buildMealType('Dinner', context),
                ],
              ),
            ],

          ),
        ),
      ),
    );
  }

  Widget _buildSmallSquareBox(IconData iconData, String mealType, int calories,
      int takenCalories, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(iconData),
        ),
        SizedBox(height: 8),
        Text(
          mealType,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Calories: $calories',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        Text(
          'Eaten: $takenCalories',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildMealType(String mealType, BuildContext context) {
    DateTime now = DateTime.now();
    bool isButtonEnabled = false;
    String timing = '';
    int calorieRange = 0;

    switch (mealType) {
      case 'Breakfast':
        isButtonEnabled = now.hour >= 7 && now.hour < 9;
        timing = '7 AM - 9 AM';
        calorieRange = _breakfastCalories;
        break;
      case 'Lunch':
        isButtonEnabled = now.hour >= 12 && now.hour < 15;
        timing = '12 PM - 3 PM';
        calorieRange = _lunchCalories;
        break;
      case 'Snack':
        isButtonEnabled = now.hour >= 15 && now.hour < 18;
        timing = '3 PM - 6 PM';
        calorieRange = _snackCalories;
        break;
      case 'Dinner':
        isButtonEnabled = now.hour >= 18 && now.hour < 23;
        timing = '6 PM - 9 PM';
        calorieRange = _dinnerCalories;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Row(
        children: [
          Text(
            '$mealType ($timing)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: isButtonEnabled
                ? () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddMealDialog(
                    mealType: mealType,
                    calorieRange: calorieRange,
                    onMealAdded: (int calories) {
                      int totalCalories = 0;
                      if (mealType == 'Breakfast') {
                        totalCalories = _takenBreakfastCalories + calories;
                      } else if (mealType == 'Lunch') {
                        totalCalories = _takenLunchCalories + calories;
                      } else if (mealType == 'Snack') {
                        totalCalories = _takenSnackCalories + calories;
                      } else if (mealType == 'Dinner') {
                        totalCalories = _takenDinnerCalories + calories;
                      }
                      if (totalCalories > calorieRange) {
                        // Show message and prevent adding calories
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Calories exceed the $mealType calorie range!',
                            ),
                          ),
                        );
                      } else {
                        setState(() {
                          if (mealType == 'Breakfast') {
                            _takenBreakfastCalories += calories;
                          } else if (mealType == 'Lunch') {
                            _takenLunchCalories += calories;
                          } else if (mealType == 'Snack') {
                            _takenSnackCalories += calories;
                          } else if (mealType == 'Dinner') {
                            _takenDinnerCalories += calories;
                          }
                          _consumedCalories += calories;
                          _displayedConsumedCalories += calories;
                          _saveCaloriesToSharedPreferences();
                        });
                      }
                    },
                  );
                },
              );
            }
                : null,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors
                        .deepPurple; // Background color for disabled state
                  }
                  return Colors.purple; // Background color for enabled state
                },
              ),
            ),
            child: Text(
              'Add',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Text color
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddMealDialog extends StatefulWidget {
  final Function(int) onMealAdded;
  final String mealType;

  const AddMealDialog({Key? key, required this.onMealAdded, required this.mealType, required int calorieRange})
      : super(key: key);

  @override
  _AddMealDialogState createState() => _AddMealDialogState();
}

class _AddMealDialogState extends State<AddMealDialog> {
  List<Map<String, dynamic>> _searchResults = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() async {
    String query = _searchController.text;
    List<String> results = await getmeal(query);
    setState(() {
      _searchResults = results.map((mealString) => {'meal': mealString, 'quantity': 1}).toList();
    });
  }

  Future<List<String>> getmeal(String query) async {
    // Simulated function, you need to implement your own logic here to fetch meals
    return Future.delayed(Duration(seconds: 1), () {
      return [
        "Meal 1 - 300 calories",
        "Meal 2 - 500 calories",
        "Meal 3 - 200 calories",
        "Meal 4 - 100 calories"
      ];
    });
  }

  void _incrementQuantity(int index) {
    setState(() {
      _searchResults[index]['quantity']++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_searchResults[index]['quantity'] > 1) {
        _searchResults[index]['quantity']--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Text(
                  'Search:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 40),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_searchResults.length, (index) {
                    String result = _searchResults[index]['meal'];
                    int quantity = _searchResults[index]['quantity'];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(result),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => _decrementQuantity(index),
                            ),
                            Text('$quantity'), // Display quantity
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => _incrementQuantity(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.add_circle),
                              onPressed: () {
                                int calories = int.parse(
                                    result.split(' - ')[1].split(' ')[0]);
                                widget.onMealAdded(calories * quantity); // Multiply calories by quantity
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          int calories = int.parse(
                              result.split(' - ')[1].split(' ')[0]);
                          widget.onMealAdded(calories * quantity); // Multiply calories by quantity
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
