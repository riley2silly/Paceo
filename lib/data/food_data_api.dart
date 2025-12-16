import 'dart:convert';
import 'package:http/http.dart' as http;

class FoodDataApi {
  static const String apiKey = "jvAqMkrRi3vo6Yah6NMupPjgOLtfCzs0JdOHgh4R"; // 👈 your key

  static Future<Map<String, dynamic>?> searchFood(String query) async {
    try {
      final url = Uri.parse(
        "https://api.nal.usda.gov/fdc/v1/foods/search?query=$query&api_key=$apiKey&pageSize=1"
      );

      final response = await http.get(url);

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);

      if (data["foods"] == null || data["foods"].isEmpty) return null;

      final food = data["foods"][0];
      final nutrients = food["foodNutrients"];

      double calories = 0;
      double protein = 0;
      double carbs = 0;
      double fats = 0;

      for (var n in nutrients) {
        switch (n["nutrientName"]) {
          case "Energy":
            calories = (n["value"] ?? 0).toDouble();
            break;
          case "Protein":
            protein = (n["value"] ?? 0).toDouble();
            break;
          case "Carbohydrate, by difference":
            carbs = (n["value"] ?? 0).toDouble();
            break;
          case "Total lipid (fat)":
            fats = (n["value"] ?? 0).toDouble();
            break;
        }
      }

      return {
        "name": food["description"],
        "calories": calories.round(),
        "protein": protein.round(),
        "carbs": carbs.round(),
        "fats": fats.round(),
      };
    } catch (e) {
      print("API Error: $e");
      return null;
    }
  }
}
