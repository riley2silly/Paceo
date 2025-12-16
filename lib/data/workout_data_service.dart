import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// ------------------------------------------------------------
///  🧠 STATIC PROGRAM CATALOG
///     - weight_loss (free)
///     - muscle_gain (free)
///     - others = premium
/// ------------------------------------------------------------
const Map<String, List<List<Map<String, dynamic>>>> kPrograms = {
  "weight_loss": [
    [
      {
        "type": "workout",
        "title": "Brisk Walk",
        "description": "30 min brisk walk at moderate pace.",
        "minutes": 30,
        "calories": 150,
        "category": "Cardio",
      },
      {
        "type": "workout",
        "title": "Bodyweight Circuit",
        "description": "3x10 squats, push-ups, planks.",
        "minutes": 20,
        "calories": 120,
        "category": "Strength",
      },
    ],
    [
      {
        "type": "workout",
        "title": "Interval Jog",
        "description": "Jog/walk intervals.",
        "minutes": 25,
        "calories": 170,
        "category": "Cardio",
      },
    ],
  ],

  // 💪 Muscle Gain — FREE
  "muscle_gain": [
    [
      {
        "type": "workout",
        "title": "Upper Body Strength",
        "description": "Push-ups, rows, shoulder presses.",
        "minutes": 30,
        "calories": 180,
        "category": "Strength",
      },
      {
        "type": "workout",
        "title": "Core Finish",
        "description": "Planks, dead bugs, hollow holds.",
        "minutes": 15,
        "calories": 90,
        "category": "Core",
      },
    ],
    [
      {
        "type": "workout",
        "title": "Lower Body Strength",
        "description": "Squats, lunges, hip thrusts.",
        "minutes": 35,
        "calories": 210,
        "category": "Strength",
      },
    ],
  ],

  // 🔥 Extreme Fat Loss — PREMIUM
  "fat_loss_extreme": [
    [
      {
        "type": "workout",
        "title": "HIIT Sprint Blocks",
        "description": "10x 30s sprint / 60s walk.",
        "minutes": 25,
        "calories": 260,
        "category": "Cardio / HIIT",
      },
      {
        "type": "workout",
        "title": "Metabolic Circuit",
        "description": "Burpees, mountain climbers, jump squats.",
        "minutes": 20,
        "calories": 220,
        "category": "HIIT",
      },
    ],
    [
      {
        "type": "workout",
        "title": "Steady State Cardio",
        "description": "Incline walk / light jog.",
        "minutes": 40,
        "calories": 280,
        "category": "Cardio",
      },
    ],
  ],

  // ✨ Toning & Sculpting — PREMIUM
  "toning_program": [
    [
      {
        "type": "workout",
        "title": "Full Body Tone",
        "description": "Light dumbbells, high reps.",
        "minutes": 30,
        "calories": 160,
        "category": "Strength / Tone",
      },
      {
        "type": "workout",
        "title": "Glute & Core",
        "description": "Bridges, clamshells, side planks.",
        "minutes": 20,
        "calories": 110,
        "category": "Strength",
      },
    ],
    [
      {
        "type": "workout",
        "title": "Upper Body Tone",
        "description": "Shoulders, arms, back sculpting.",
        "minutes": 30,
        "calories": 150,
        "category": "Strength / Tone",
      },
    ],
  ],

  // ❤️ Cardio Booster — PREMIUM
  "cardio_boost": [
    [
      {
        "type": "workout",
        "title": "Endurance Run",
        "description": "Steady pace cardio.",
        "minutes": 35,
        "calories": 230,
        "category": "Cardio",
      },
    ],
    [
      {
        "type": "workout",
        "title": "Tempo Intervals",
        "description": "Moderate-hard run sections.",
        "minutes": 30,
        "calories": 210,
        "category": "Cardio",
      },
    ],
  ],
};

class WorkoutDataService extends ChangeNotifier {
  // ======================================================
  // 🔥 Firebase References
  // ======================================================
  String? get uid => FirebaseAuth.instance.currentUser?.uid;
  final userRef = FirebaseFirestore.instance.collection("users");

  String _dateKey(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  // ======================================================
  // ⭐ PREMIUM USER
  // ======================================================
  bool isPremiumUser = false;

  void setPremium(bool v) {
    isPremiumUser = v;
    saveUserProfileToFirebase();
    notifyListeners();
  }

  // ======================================================
  // 👤 USER PROFILE
  // ======================================================
  String userName = "User";
  String gender = "Not set";
  double height = 170;
  double currentWeight = 60;
  int age = 18;
  String imageUrl = "";

  Future<void> updateUserProfile({
    required String newName,
    required String newGender,
    required double newHeight,
    required double newWeight,
    required int newAge,
    String? newImageUrl,
  }) async {
    userName = newName;
    gender = newGender;
    height = newHeight;
    currentWeight = newWeight;
    age = newAge;
    if (newImageUrl != null) imageUrl = newImageUrl;

    await saveUserProfileToFirebase();
    notifyListeners();
  }

  // ======================================================
  // 📸 Profile Image
  // ======================================================
  Future<void> uploadProfileImage() async {
    if (uid == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final ref = FirebaseStorage.instance.ref("profile_images/$uid.jpg");
    await ref.putData(await picked.readAsBytes());

    imageUrl = await ref.getDownloadURL();

    await saveUserProfileToFirebase();
    notifyListeners();
  }

  // ======================================================
  // 🎯 GOALS
  // ======================================================
  int calorieGoal = 2000;
  int proteinGoal = 120;
  int carbsGoal = 250;
  int fatsGoal = 60;

  Future<void> updateGoals({
    required int newCalories,
    required int newProtein,
    required int newCarbs,
    required int newFats,
  }) async {
    calorieGoal = newCalories;
    proteinGoal = newProtein;
    carbsGoal = newCarbs;
    fatsGoal = newFats;

    await saveUserProfileToFirebase();
    notifyListeners();
  }

  // ======================================================
  // 🧩 PROGRAM STATE
  // ======================================================
  String activeGoal = "none";
  String? activeProgramId;
  DateTime? programStartDate;

  /// 🔥 Returns the list of workouts/meals planned for today
  List<Map<String, dynamic>> get todayPlanItems {
    if (activeProgramId == null) return [];
    final program = kPrograms[activeProgramId];
    if (program == null || program.isEmpty) return [];
    if (programStartDate == null) return [];

    final today = DateTime.now();
    final diff = today
        .difference(DateTime(
          programStartDate!.year,
          programStartDate!.month,
          programStartDate!.day,
        ))
        .inDays;

    if (diff < 0) return [];

    return program[diff % program.length];
  }

  Future<void> startProgram(String id) async {
    activeProgramId = id;
    activeGoal = id;
    programStartDate = DateTime.now();

    await saveUserProfileToFirebase();
    notifyListeners();
  }

  Future<void> clearProgram() async {
    activeProgramId = null;
    activeGoal = "none";
    programStartDate = null;

    await saveUserProfileToFirebase();
    notifyListeners();
  }

  /// Log one program-generated item into workout/meal logs
  Future<void> logPlanItem(Map<String, dynamic> item) async {
    if ((item["type"] ?? "workout") == "workout") {
      await addWorkout(
        name: item["title"] ?? "Workout",
        minutes: item["minutes"] ?? 20,
        calories: item["calories"] ?? 100,
        category: item["category"] ?? "Workout",
      );
    } else {
      await addMeal(
        name: item["title"] ?? "Meal",
        category: item["category"] ?? "Program Meal",
        calories: item["calories"] ?? 300,
        protein: item["protein"] ?? 10,
        carbs: item["carbs"] ?? 20,
        fats: item["fats"] ?? 5,
      );
    }

    await _updateDailySummary();
    notifyListeners();
  }

  /// (OPTIONAL) Program day status log – can be called from UI (Skip / Log all)
  Future<void> recordProgramDayStatus({
    required String status, // "completed" / "skipped"
    List<String>? items,
  }) async {
    if (uid == null || activeProgramId == null || programStartDate == null) {
      return;
    }

    final now = DateTime.now();
    final key = _dateKey(now);

    final baseStart = DateTime(
      programStartDate!.year,
      programStartDate!.month,
      programStartDate!.day,
    );
    final dayNumber = now.difference(baseStart).inDays + 1;

    await userRef.doc(uid).collection("programLogs").doc(key).set(
      {
        "programId": activeProgramId,
        "dayNumber": dayNumber,
        "status": status, // "completed" / "skipped"
        "items": items ?? [],
        "timestamp": now.toIso8601String(),
      },
      SetOptions(merge: true),
    );
  }

  // ======================================================
  // DAILY RESET
  // ======================================================
  String lastResetDate =
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

  void checkForNewDay() {
    final now = DateTime.now();
    final today = "${now.year}-${now.month}-${now.day}";

    if (today != lastResetDate) {
      resetDailyStats();
      lastResetDate = today;
      saveUserProfileToFirebase();
      notifyListeners();
    }
  }

  void resetDailyStats() {
    totalCaloriesConsumed = 0;
    totalCaloriesBurned = 0;
    totalProtein = 0;
    totalCarbs = 0;
    totalFats = 0;
    totalActiveMinutes = 0;
    totalWorkouts = 0;
    mealsToday.clear();
    todayLogs.clear();
  }

  // ======================================================
  // TODAY DATA (in-memory for the current date)
  // ======================================================
  int totalCaloriesConsumed = 0;
  int totalCaloriesBurned = 0;
  int totalProtein = 0;
  int totalCarbs = 0;
  int totalFats = 0;
  int totalActiveMinutes = 0;
  int totalWorkouts = 0;

  List<Map<String, dynamic>> mealsToday = [];
  List<Map<String, dynamic>> todayLogs = [];

  Map<String, List<Map<String, dynamic>>> mealHistory = {};
  Map<String, List<Map<String, dynamic>>> workoutHistory = {};

  List<Map<String, dynamic>> bodyLogs = [];

  // ======================================================
  // 🏋 WORKOUT LOG
  // ======================================================
  Future<void> addWorkout({
    required String name,
    required int minutes,
    required int calories,
    required String category,
  }) async {
    final now = DateTime.now();
    final key = _dateKey(now);

    totalActiveMinutes += minutes;
    totalCaloriesBurned += calories;
    totalWorkouts++;

    final entry = {
      "name": name,
      "minutes": minutes,
      "calories": calories,
      "category": category,
      "timestamp": now.toIso8601String(),
      "dateKey": key,
    };

    todayLogs.insert(0, entry);
    workoutHistory.putIfAbsent(key, () => []).add(entry);

    if (uid != null) {
      await userRef.doc(uid).collection("workouts").add(entry);
    }

    await _updateDailySummary();
    notifyListeners();
  }

  // ======================================================
  // 🍽 MEAL LOG
  // ======================================================
  Future<void> addMeal({
    required String name,
    required String category,
    required int calories,
    required int protein,
    required int carbs,
    required int fats,
  }) async {
    final now = DateTime.now();
    final key = _dateKey(now);

    totalCaloriesConsumed += calories;
    totalProtein += protein;
    totalCarbs += carbs;
    totalFats += fats;

    final entry = {
      "name": name,
      "calories": calories,
      "protein": protein,
      "carbs": carbs,
      "fats": fats,
      "category": category,
      "timestamp": now.toIso8601String(),
      "dateKey": key,
    };

    mealsToday.insert(0, entry);
    mealHistory.putIfAbsent(key, () => []).add(entry);

    if (uid != null) {
      await userRef.doc(uid).collection("meals").add(entry);
    }

    await _updateDailySummary();
    notifyListeners();
  }

  // ======================================================
  // 📏 BODY LOGS
  // ======================================================
  Future<void> addBodyLog({required double weight, String? note}) async {
    final now = DateTime.now();
    final bmi = weight / ((height / 100) * (height / 100));

    final entry = {
      "weight": weight,
      "bmi": double.parse(bmi.toStringAsFixed(1)),
      "note": note ?? "",
      "timestamp": now.toIso8601String(),
    };

    bodyLogs.insert(0, entry);

    if (uid != null) {
      await userRef.doc(uid).collection("bodyLogs").add(entry);
    }

    currentWeight = weight;
    await saveUserProfileToFirebase();
    notifyListeners();
  }

  Future<void> loadBodyLogs() async {
    if (uid == null) return;

    try {
      final snap = await userRef
          .doc(uid)
          .collection("bodyLogs")
          .orderBy("timestamp", descending: true)
          .get();

      bodyLogs = snap.docs.map((d) => d.data()).toList();
    } catch (_) {}

    notifyListeners();
  }

  // ======================================================
  // LOAD HISTORIES (meals + workouts)
  // ======================================================
  Future<void> loadMealLogs() async {
    if (uid == null) return;

    try {
      final snap = await userRef
          .doc(uid)
          .collection("meals")
          .orderBy("timestamp", descending: true)
          .get();

      mealHistory.clear();

      for (var doc in snap.docs) {
        final m = doc.data();
        final dk = m["dateKey"] ?? (m["timestamp"] as String).substring(0, 10);
        mealHistory.putIfAbsent(dk, () => []).add(m);
      }
    } catch (_) {}

    notifyListeners();
  }

  Future<void> loadWorkoutLogs() async {
    if (uid == null) return;

    try {
      final snap = await userRef
          .doc(uid)
          .collection("workouts")
          .orderBy("timestamp", descending: true)
          .get();

      workoutHistory.clear();

      for (var doc in snap.docs) {
        final w = doc.data();
        final dk = w["dateKey"] ?? (w["timestamp"] as String).substring(0, 10);
        workoutHistory.putIfAbsent(dk, () => []).add(w);
      }
    } catch (_) {}

    notifyListeners();
  }

  // ======================================================
  // REBUILD TODAY TOTALS FROM HISTORY
  // ======================================================
  void _rebuildTodayFromHistory() {
    final key = _dateKey(DateTime.now());

    totalCaloriesConsumed = 0;
    totalCaloriesBurned = 0;
    totalProtein = 0;
    totalCarbs = 0;
    totalFats = 0;
    totalActiveMinutes = 0;
    totalWorkouts = 0;

    mealsToday = List<Map<String, dynamic>>.from(mealHistory[key] ?? []);
    todayLogs = List<Map<String, dynamic>>.from(workoutHistory[key] ?? []);

    for (final m in mealsToday) {
      totalCaloriesConsumed += (m["calories"] ?? 0) as int;
      totalProtein += (m["protein"] ?? 0) as int;
      totalCarbs += (m["carbs"] ?? 0) as int;
      totalFats += (m["fats"] ?? 0) as int;
    }

    for (final w in todayLogs) {
      totalCaloriesBurned += (w["calories"] ?? 0) as int;
      totalActiveMinutes += (w["minutes"] ?? 0) as int;
      totalWorkouts += 1;
    }
  }

  // ======================================================
  // LOAD ALL
  // ======================================================
  Future<void> loadAllData() async {
    await loadUserData();

    // 🔁 Handle new day reset before loading today's logs
    checkForNewDay();

    await loadMealLogs();
    await loadWorkoutLogs();
    await loadBodyLogs();

    // 🔄 Rebuild today's summary from history
    _rebuildTodayFromHistory();

    // 🔥 Persist daily summary to Firestore
    await _updateDailySummary();

    notifyListeners();
  }

  // ======================================================
  // USER DATA
  // ======================================================
  Future<void> loadUserData() async {
    if (uid == null) return;

    final doc = await userRef.doc(uid).get();
    if (!doc.exists) return;

    final d = doc.data()!;

    userName = d["name"] ?? userName;
    gender = d["gender"] ?? gender;

    try {
      age = d["age"] ?? age;
    } catch (_) {}

    try {
      height = (d["height"] ?? height).toDouble();
    } catch (_) {}

    try {
      currentWeight = (d["weight"] ?? currentWeight).toDouble();
    } catch (_) {}

    calorieGoal = d["calorieGoal"] ?? calorieGoal;
    proteinGoal = d["proteinGoal"] ?? proteinGoal;
    carbsGoal = d["carbsGoal"] ?? carbsGoal;
    fatsGoal = d["fatsGoal"] ?? fatsGoal;

    isPremiumUser = d["isPremium"] ?? false;
    imageUrl = d["imageUrl"] ?? imageUrl;

    activeGoal = d["activeGoal"] ?? "none";
    activeProgramId = d["activeProgramId"];

    try {
      final raw = d["programStartDate"];
      if (raw is String) programStartDate = DateTime.tryParse(raw);
      if (raw is Timestamp) programStartDate = raw.toDate();
    } catch (_) {
      programStartDate = null;
    }

    lastResetDate = d["lastResetDate"] ?? lastResetDate;

    notifyListeners();
  }

  // ======================================================
  // SAVE USER PROFILE (and program state)
  // ======================================================
  Future<void> saveUserProfileToFirebase() async {
    if (uid == null) return;

    await userRef.doc(uid).set(
      {
        "name": userName,
        "gender": gender,
        "height": height,
        "weight": currentWeight,
        "age": age,
        "isPremium": isPremiumUser,
        "calorieGoal": calorieGoal,
        "proteinGoal": proteinGoal,
        "carbsGoal": carbsGoal,
        "fatsGoal": fatsGoal,
        "imageUrl": imageUrl,
        "activeGoal": activeGoal,
        "activeProgramId": activeProgramId,
        "programStartDate": programStartDate?.toIso8601String(),
        "lastResetDate": lastResetDate,
      },
      SetOptions(merge: true),
    );
  }

  // ======================================================
  // DAILY SUMMARY PERSISTENCE
  // ======================================================
  Future<void> _updateDailySummary() async {
    if (uid == null) return;

    final now = DateTime.now();
    final key = _dateKey(now);

    await userRef
        .doc(uid)
        .collection("dailySummary")
        .doc(key)
        .set(
      {
        "dateKey": key,
        "caloriesConsumed": totalCaloriesConsumed,
        "caloriesBurned": totalCaloriesBurned,
        "protein": totalProtein,
        "carbs": totalCarbs,
        "fats": totalFats,
        "activeMinutes": totalActiveMinutes,
        "workoutsDone": totalWorkouts,
        "netCalories": netCalories,
        "lastUpdated": FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  // ======================================================
  // UI HELPERS
  // ======================================================
  int get netCalories => totalCaloriesConsumed - totalCaloriesBurned;

  int get caloriesLeft =>
      (calorieGoal - totalCaloriesConsumed).clamp(0, calorieGoal);

  String get suggestionMessage {
    if (totalCaloriesConsumed > calorieGoal) return "You've exceeded 💧";
    if (totalCaloriesConsumed >= calorieGoal * 0.8) return "Go light 🥗";
    return "Keep going! 🥦";
  }

  String formatTime(DateTime t) =>
      "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
}
