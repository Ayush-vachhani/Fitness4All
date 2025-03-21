// healthy_snack.dart

import 'dart:math';

class HealthySnacks {
  static final List<String> snackRecommendations = [
    "Greek Yogurt with Honey",
    "Hummus with Veggie Sticks",
    "Mixed Nuts",
    "Apple Slices with Peanut Butter",
    "Dark Chocolate and Almonds",
    "Trail Mix",
    "Cottage Cheese with Pineapple",
    "Rice Cakes with Avocado",
    "Protein Bars",
    "Hard-Boiled Eggs",
    "Edamame",
    "Celery Sticks with Almond Butter",
    "Popcorn (Air-Popped)",
    "Roasted Chickpeas",
    "Sliced Cucumber with Tzatziki",
    "Banana with Almond Butter",
    "Kale Chips",
    "Dark Chocolate-Covered Almonds",
    "Smoothie with Spinach and Berries",
    "Chia Pudding",
    "Oatmeal with Fresh Berries",
    "Whole Grain Crackers with Cheese",
    "Avocado Toast",
    "Boiled Sweet Potatoes",
    "Quinoa Salad",
    "Roasted Pumpkin Seeds",
    "Dark Chocolate-Covered Raisins",
    "Frozen Grapes",
    "Rice Pudding with Cinnamon",
    "Protein Shake",
  ];

  // Method to get a random snack recommendation
  static String getRandomSnack() {
    final random = Random();
    return snackRecommendations[random.nextInt(snackRecommendations.length)];
  }
}