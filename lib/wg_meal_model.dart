class wg_meal_model {
  String? item;
  int? calories;

  wg_meal_model(this.item, this.calories);
    Map<String, dynamic> toMap() {
      return {
        'item': item,
        'calories': calories
      };
    }
  }
