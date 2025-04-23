import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class WaterDetailScreen extends StatefulWidget {
  const WaterDetailScreen({super.key});

  @override
  State<WaterDetailScreen> createState() => _WaterDetailScreenState();
}

class _WaterDetailScreenState extends State<WaterDetailScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Example progress data for each day (can be dynamic)
  Map<DateTime, double> progressData = {
    DateTime.now(): 0.9, // 90% progress for today
    DateTime.now().subtract(Duration(days: 1)): 0.5, // 50% progress for yesterday
    DateTime.now().subtract(Duration(days: 2)): 0.3, // 30% progress for the day before
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Column(
        children: [
          // First Half with Water Box Color
          Container(
            height: MediaQuery.of(context).size.height / 2,
            decoration: BoxDecoration(
              color: const Color(0xFFDDF3F6),
              border: const Border(
                top: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            child: Column(
              children: [
                // Icons Row with Text Centered
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.arrow_back, color: Colors.black, size: 30),
                        ),
                      ),
                      const Text(
                        "WATER",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.settings, color: Colors.black, size: 30),
                        ),
                      ),
                    ],
                  ),
                ),

                // Separator Line
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 2,
                  color: Colors.black,
                ),
                const SizedBox(height: 30),

                // Number and +/- Icons with equal gaps
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.remove_circle_outline, color: Colors.black, size: 40),
                    SizedBox(width: 50),
                    Text(
                      "9",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 160,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 50),
                    Icon(Icons.add_circle_outline, color: Colors.black, size: 40),
                  ],
                ),

                const SizedBox(height: 10),

                // Subtext
                const Text(
                  "of 10 glasses / day",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Second Half - Calendar
          Expanded(
            child: Container(
              color: const Color(0xFF0D0D0D),
              padding: const EdgeInsets.all(16),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: const CalendarStyle(
                  defaultTextStyle: TextStyle(color: Colors.white),
                  weekendTextStyle: TextStyle(color: Colors.white),
                  todayDecoration: BoxDecoration(
                    color: Colors.cyan,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
                  leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                  rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.white),
                  weekendStyle: TextStyle(color: Colors.white),
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, date, focusedDay) {
                    // Get progress for the date (default to 0 if no data)
                    double progress = progressData[date] ?? 0.0;

                    return Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Circular progress indicator (white background)
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: CircularProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                              strokeWidth: 5,
                            ),
                          ),
                          // Day text
                          Text(
                            "${date.day}",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}