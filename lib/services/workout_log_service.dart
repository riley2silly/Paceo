class WorkoutLogService {
  static final List<Map<String, dynamic>> todayLogs = [];

  static void addLog({
    required String name,
    required String details,
  }) {
    todayLogs.add({
      "name": name,
      "details": details,
    });
  }
}
