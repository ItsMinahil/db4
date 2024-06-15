import 'package:db4/calculation.dart';
import 'package:db4/user_repo.dart';
import 'package:db4/wg_meal_model.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sqflite/sqflite.dart';
import 'color.dart';
import 'database_handler.dart';
bool first_time=true;

class meal extends StatefulWidget {
  @override
  _mealState createState() => _mealState();
}

class _mealState extends State<meal> {
  // Define initial meal calories values

  int _breakfastCalories = 300;
  int _lunchCalories = 500;
  int _snackCalories = 200;
  int _dinnerCalories = 600;
  Database? _database;

  @override
  Widget build(BuildContext context) {
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
    Future<double> calculated_cal() async{
      WeightGainCalculator wg_cal=new WeightGainCalculator();
      double calories = await wg_cal.calculateCalories(age,height,cweight,gweight,gender,activity_level);
      return calories;
    }
    Future<double> cal_cal=calculated_cal();
    return FutureBuilder<double>(
      future: cal_cal,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Display a loading indicator while waiting for the result
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Display an error message if cal_cal encounters an error
        } else {
          double calories = snapshot.data!;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white10,
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CircularPercentIndicator(
                        radius: 100,
                        lineWidth: 10,
                        circularStrokeCap: CircularStrokeCap.round,
                        backgroundColor: Colors.transparent,
                        progressColor: Colors.deepPurple,
                        percent: 0.8,
                        startAngle: 218,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total ${calories.toStringAsFixed(2) ?? 'Loading...'}', // Display calories
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Goal: 2000', // Placeholder for goal calories
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,

                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSmallSquareBox(
                            Icons.local_dining, 'Breakfast', _breakfastCalories, AppColors.breakfast, context),
                        _buildSmallSquareBox(
                            Icons.fastfood, 'Lunch', _lunchCalories, AppColors.lunch, context),
                        _buildSmallSquareBox(
                            Icons.local_cafe, 'Snack', _snackCalories, AppColors.snack, context),
                        _buildSmallSquareBox(
                            Icons.restaurant, 'Dinner', _dinnerCalories, AppColors.dinner1, context),
                      ],
                    ),
                    SizedBox(height: 70),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMealType('Breakfast', context),
                        _buildMealType('Lunch', context),
                        _buildMealType('Snack',context),
                        _buildMealType('Dinner', context),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildSmallSquareBox(IconData iconData, String mealType, int calories, Color color,
      BuildContext context) {
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
      ],
    );
  }

  Widget _buildMealType(String mealType, BuildContext context) {
    //String? email= ModalRoute.of(context)?.settings.arguments as String?;
    Future<Database> openDB() async{
      Database _database=await DatabaseHandler().openDB();

      return _database;
    }
    Future<void> insertDB() async {
      try {
        Database _database = await openDB();
        print('we are in insert db function');
        UserRepo userRepo = new UserRepo();
        await userRepo.createTable_wg_meal(_database); // Await table creation
        await userRepo.insert(_database); // Await data insertion
        print('inserted in meal weightgain');
        // Don't close the database here; keep it open for other operations
      } catch (e) {
        print('Error inserting data: $e');
        // Handle error appropriately (e.g., log, display error message)
      }
    }



    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Row(
        children: [
          Text(
            mealType,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () async {
              //  insertDB();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddMealDialog(
                    // Pass callback to update calories
                    onMealAdded: (int calories) {
                      // Update the corresponding meal box calories
                      setState(() {
                        if (mealType == 'Breakfast') {
                          _breakfastCalories -= calories;
                        } else if (mealType == 'Lunch') {
                          _lunchCalories -= calories;
                        } else if (mealType == 'Snack') {
                          _snackCalories -= calories;
                        } else if (mealType == 'Dinner') {
                          _dinnerCalories -= calories;
                        }
                      });
                    },
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              backgroundColor: Colors.deepPurple,
              textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              fixedSize: Size(80, 30),
              foregroundColor: Colors.white,
            ),
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

}


class AddMealDialog extends StatefulWidget {
  final Function(int) onMealAdded; // Callback function

  const AddMealDialog({Key? key, required this.onMealAdded}) : super(key: key);

  @override
  _AddMealDialogState createState() => _AddMealDialogState();
}

class _AddMealDialogState extends State<AddMealDialog> {
  List<String> _searchResults = [];
  TextEditingController _searchController = TextEditingController();

  Future<Database> openDB() async{
    Database _database=await DatabaseHandler().openDB();
    return _database;
  }
  Future<List<String>> getmeal(query)async{
    Database _database=await openDB();
    UserRepo userRepo=new UserRepo();
    List<Map<String, dynamic>> meals=await userRepo.get_wg_meal(_database);
    List<String> filteredMeals = meals
        .where((Map<String, dynamic> meal) =>
        meal['item']!.toString().toLowerCase().contains(query.toLowerCase())) // Access 'item' key and ensure it's not null
        .map((Map<String, dynamic> meal) =>
    '${meal['item']} - ${meal['calories']} calories') // Access 'item' and 'calories' keys
        .toList();
    await _database.close();
    return filteredMeals;

  }


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
    // Query your SQLite database here and update _searchResults
    List<String> results = (await getmeal(query)) as List<String>;
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 10,
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
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
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_searchResults[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        // Extract calories from the selected meal
                        int calories = int.parse(
                          _searchResults[index].split(' - ')[1].split(' ')[0],
                        );
                        // Call the callback function to subtract calories
                        widget.onMealAdded(calories);
                        // Close the dialog
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );


  }


}

