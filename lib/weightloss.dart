import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:db4/stepcounter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'getstarted page.dart';
import 'main.dart';

class weightloss extends StatefulWidget {
  @override
  _weightlossState createState() => _weightlossState();
}

class _weightlossState extends State<weightloss> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController heightFeetController = TextEditingController();
  TextEditingController heightInchesController = TextEditingController();
  TextEditingController currentWeightController = TextEditingController();
  TextEditingController goalWeightController = TextEditingController();

  User? userId;
  //=FirebaseAuth.instance.currentUser;

  String nameError = '';
  String emailError = '';
  String ageError = '';
  String heightFeetError = '';
  String heightInchesError = '';
  String currentWeightError = '';
  String goalWeightError = '';

  bool hasError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My FitnessPlanner'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildTextField(
              'Enter Name',
              nameController,
              nameError,
                  (value) {
                setState(() {
                  nameError = _validateName(value);
                  checkErrors();
                });
              },
              TextInputType.text,
            ),
            SizedBox(height: 25),
            buildTextFieldWithValidation(
              'Enter Email',
              emailController,
              emailError,
                  (value) {
                setState(() {
                  emailError = _validateEmail(value);
                  checkErrors();
                });
              },
                  (value) {
                if (value.isEmpty) {
                  return 'Email is required.';
                }
                return null;
              },
            ),
            SizedBox(height: 25),
            buildTextField(
              'Enter Age',
              ageController,
              ageError,
                  (value) {
                setState(() {
                  ageError = _validateAge(value);
                  checkErrors();
                });
              },
              TextInputType.number,
            ),
            SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: buildTextFieldWithValidation(
                    'Enter Height (Feet)',
                    heightFeetController,
                    heightFeetError,
                        (value) {
                      setState(() {
                        heightFeetError = _validateHeightFeet(value);
                        checkErrors();
                      });
                    },
                        (value) {
                      if (value.isEmpty) {
                        return 'Height is required.';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 25),
                Expanded(
                  child: buildTextFieldWithValidation(
                    'Enter Height (Inches)',
                    heightInchesController,
                    heightInchesError,
                        (value) {
                      setState(() {
                        heightInchesError = _validateHeightInches(value);
                        checkErrors();
                      });
                    },
                        (value) {
                      if (value.isEmpty) {
                        return 'Height is required.';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            buildTextFieldWithValidation(
              'Enter Current Weight (Kgs)',
              currentWeightController,
              currentWeightError,
                  (value) {
                setState(() {
                  currentWeightError = _validateCurrentWeight(value);
                  checkErrors();
                });
              },
                  (value) {
                if (value.isNotEmpty &&
                    !RegExp(r'^\d*$').hasMatch(value)) {
                  return 'Please enter a valid weight in kgs.';
                } else if (value.isNotEmpty &&
                    double.parse(value) <= 0) {
                  return 'Weight must be greater than zero.';
                }
                return null;
              },
            ),
            SizedBox(height: 25),
            buildTextFieldWithValidation(
              'Enter Goal Weight (Kgs)',
              goalWeightController,
              goalWeightError,
                  (value) {
                setState(() {
                  goalWeightError = _validateGoalWeight(value);
                  checkErrors();
                });
              },
                  (value) {
                if (value.isNotEmpty &&
                    !RegExp(r'^\d*$').hasMatch(value)) {
                  return 'Please enter a valid weight in kgs.';
                } else if (value.isNotEmpty &&
                    double.parse(value) <=
                        double.parse(currentWeightController.text)) {
                  return 'Goal weight should be less than current weight.';
                }
                return null;
              },
            ),
            SizedBox(height: 27),
            ElevatedButton(
              onPressed: hasError
                  ? null
                  : ()async{

                Map<String,dynamic> data={"name": nameController.text,"email":emailController.text,
                  "age":ageController.text,"height": heightFeetController.text,
                  "cweight":currentWeightController.text,"gweight":goalWeightController.text,"userId":userId?.uid,};
                FirebaseFirestore.instance.collection("userweightlos").add(data);
                print("user id is ${userId}");

                if (_validateFields()) {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString('selectedPage', 'weightloss');
                  // All conditions met, move to the next page
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => step(),
                    ),
                  );
                }
              },
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.purple, fixedSize: Size(130, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email is required.';
    } else {
      if (!RegExp(r'^[a-z]+[a-zA-Z0-9._%+-]*@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
        return ' Email format. Example: alice123@my-mail.com';
      }
    }
    return '';
  }

  String _validateName(String name) {
    if (name.isEmpty) {
      return 'Name is required.';
    } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(name)) {
      return 'Only letters are allowed.';
    }
    return '';
  }

  String _validateAge(String age) {
    if (age.isEmpty) {
      return 'Age is required.';
    } else {
      int ageValue = int.tryParse(age) ?? 0;
      if (ageValue < 16 || ageValue > 60) {
        return 'Age should be between 16 and 60.';
      }
    }
    return '';
  }

  String _validateHeightFeet(String feet) {
    if (feet.isEmpty) {
      return 'Height is required.';
    } else {
      int feetValue = int.tryParse(feet) ?? 0;
      if (feetValue < 4 || feetValue > 7) {
        return 'Feet should be between 4 and 7.';
      }
    }
    return '';
  }

  String _validateHeightInches(String inches) {
    if (inches.isEmpty) {
      return 'Height is required.';
    } else {
      int inchesValue = int.tryParse(inches) ?? 0;
      if (inchesValue < 1 || inchesValue > 11) {
        return 'Inches should be between 1 and 11.';
      }
    }
    return '';
  }

  String _validateCurrentWeight(String weight) {
    if (weight.isEmpty) {
      return 'Current weight is required.';
    } else if (!RegExp(r'^\d*$').hasMatch(weight)) {
      return 'Please enter a valid weight in kgs.';
    } else if (double.parse(weight) <= 0) {
      return 'Weight must be greater than zero.';
    }
    return '';
  }

  String _validateGoalWeight(String weight) {
    if (weight.isEmpty) {
      return 'Goal weight is required.';
    } else if (!RegExp(r'^\d*$').hasMatch(weight)) {
      return 'Please enter a valid weight in kgs.';
    } else if (double.parse(weight) >=
        double.parse(currentWeightController.text)) {
      return 'Goal weight should be less than current weight.';
    }
    return '';
  }

  Widget buildTextField(String labelText, TextEditingController controller,
      String errorText, Function(String) onChanged, TextInputType keyboardType) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            onChanged: (value) {
              onChanged(value);
            },
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: labelText,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            ),
          ),
          if (errorText.isNotEmpty) ...[
            SizedBox(height: 4),
            Text(
              errorText,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildNumberField(String labelText, TextEditingController controller,
      String errorText, Function(String) onChanged) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            onChanged: (value) {
              onChanged(value);
            },
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: labelText,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            ),
          ),
          if (errorText.isNotEmpty) ...[
            SizedBox(height: 4),
            Text(
              errorText,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildTextFieldWithValidation(String labelText,
      TextEditingController controller, String errorText,
      Function(String) onChanged, String? Function(String) validator) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            onChanged: (value) {
              onChanged(value);
              // Call the validator function when the user types
              setState(() {
                errorText = validator(controller.text) ?? '';
              });
            },
            decoration: InputDecoration(
              labelText: labelText,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            ),
            keyboardType: TextInputType.emailAddress,
            onSubmitted: (_) {
              // Call the validator function when the user submits
              setState(() {
                errorText = validator(controller.text) ?? '';
              });
            },
          ),
          if (errorText.isNotEmpty) ...[
            SizedBox(height: 4),
            Text(
              errorText,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ],
      ),
    );
  }

  bool _validateFields() {
    bool isValid = true;

    if (nameController.text.isEmpty) {
      setState(() {
        nameError = 'Name is required.';
        isValid = false;
      });
    } else {
      setState(() {
        nameError = '';
      });
    }

    if (emailController.text.isEmpty) {
      setState(() {
        emailError = 'Email is required.';
        isValid = false;
      });
    } else {
      setState(() {
        emailError = _validateEmail(emailController.text);
      });
    }

    if (ageController.text.isEmpty) {
      setState(() {
        ageError = 'Age is required.';
        isValid = false;
      });
    } else {
      setState(() {
        ageError = _validateAge(ageController.text);
      });
    }

    if (heightFeetController.text.isEmpty &&
        heightInchesController.text.isEmpty) {
      setState(() {
        heightFeetError = 'Height is required.';
        heightInchesError = 'Height is required.';
        isValid = false;
      });
    } else {
      setState(() {
        heightFeetError = '';
        heightInchesError = '';
      });
    }

    if (currentWeightController.text.isEmpty) {
      setState(() {
        currentWeightError = 'Current weight is required.';
        isValid = false;
      });
    } else if (!RegExp(r'^\d*$').hasMatch(currentWeightController.text)) {
      setState(() {
        currentWeightError = 'Please enter a valid weight in kgs.';
        isValid = false;
      });
    } else if (double.parse(currentWeightController.text) <= 0) {
      setState(() {
        currentWeightError = 'Weight must be greater than zero.';
        isValid = false;
      });
    } else {
      setState(() {
        currentWeightError = '';
      });
    }

    if (goalWeightController.text.isEmpty) {
      setState(() {
        goalWeightError = 'Goal weight is required.';
        isValid = false;
      });
    } else if (!RegExp(r'^\d*$').hasMatch(goalWeightController.text)) {
      setState(() {
        goalWeightError = 'Please enter a valid weight in kgs.';
        isValid = false;
      });
    } else if (double.parse(goalWeightController.text) >=
        double.parse(currentWeightController.text)) {
      setState(() {
        goalWeightError =
        'Goal weight should be less than current weight.';
        isValid = false;
      });
    } else {
      setState(() {
        goalWeightError = '';
      });
    }

    return isValid;
  }

  void checkErrors() {
    setState(() {
      hasError = nameError.isNotEmpty ||
          emailError.isNotEmpty ||
          ageError.isNotEmpty ||
          heightFeetError.isNotEmpty ||
          heightInchesError.isNotEmpty ||
          currentWeightError.isNotEmpty ||
          goalWeightError.isNotEmpty;
    });
  }
}

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Page'),
      ),
      body: Center(
        child: Text('Welcome! You have successfully submitted the form.'),
      ),
    );
  }
}
