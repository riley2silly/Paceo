import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'activity_screen.dart';
import 'meals_screen.dart';
import 'body_screen.dart';
import 'history_screen.dart';


class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  // Temporary placeholder screens
 final List<Widget> screens = const [
  HomeScreen(),
  ActivityScreen(), // 👈 replace Workout placeholder
  MealsScreen(),
  BodyScreen(),
  HistoryScreen(),

];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: "Activity",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_rounded),
            label: "Meals",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_weight_rounded),
            label: "Body",
          ),
          BottomNavigationBarItem(
  icon: Icon(Icons.analytics_outlined),
  label: "History",
),

        ],
      ),
    );
  }
}
