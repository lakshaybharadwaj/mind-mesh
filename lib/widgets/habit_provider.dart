import 'package:flutter/material.dart';
import 'habit_model.dart';

class HabitProvider with ChangeNotifier {
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  void addHabit(Habit habit) {
    _habits.add(habit);
    notifyListeners();
  }

  void deleteHabit(int id) {
    _habits.removeWhere((habit) => habit.id == id);
    notifyListeners();
  }

  void setHabits(List<Habit> newHabits) {
    _habits = newHabits;
    notifyListeners();
  }
}
