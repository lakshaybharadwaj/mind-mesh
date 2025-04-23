import 'package:flutter/material.dart';
import 'package:mind_mesh/widgets/water.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Import the new WaterDetailScreen

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _nameController = TextEditingController();
  String? selectedUnit = 'days'; // Default unit selection

  // Function to calculate progress as a percentage
  double calculateProgress(int completedCount, int goal) {
    if (goal == 0) return 0; // Prevent division by zero
    return (completedCount / goal).clamp(0.0, 1.0); // Return progress as a fraction (0 to 1)
  }

  // Show a dialog for creating a new habit
  void _showCreateHabitDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Habit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Habit Name'),
              ),
              DropdownButton<String>(
                value: selectedUnit,
                onChanged: (value) {
                  setState(() {
                    selectedUnit = value;
                  });
                },
                items: ['days', 'hours', 'minutes']
                    .map((unit) => DropdownMenuItem(
                  value: unit,
                  child: Text(unit),
                ))
                    .toList(),
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Goal Duration'),
                onChanged: (value) {
                  setState(() {
                    // Optionally update the duration dynamically
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final name = _nameController.text;
                if (name.isNotEmpty) {
                  // Create habit logic (omitted for brevity)
                  Navigator.pop(context); // Close the dialog
                }
              },
              child: const Text('Create'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text("Dashboard", style: TextStyle(fontSize: 20, color: Colors.white)),
            const Spacer(),
            GestureDetector(
              onTap: _showCreateHabitDialog, // Show the dialog for creating a new habit
              child: const Icon(Icons.add, size: 36, color: Colors.white),
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(  // Listen to the habits table
        stream: supabase
            .from('habits')
            .stream(primaryKey: ['id'])  // Listen for changes to the habits table
            .order('created_at', ascending: false)
            .map((event) => List<Map<String, dynamic>>.from(event)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final habits = snapshot.data ?? [];

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },  // Trigger the refresh logic when the user pulls to refresh
            child: ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                final completedCount = habit['completed_count'] ?? 0;
                final goal = habit['duration'] ?? 1; // Default goal is 1 to prevent division by zero
                final progress = calculateProgress(completedCount, goal);

                return ListTile(
                  title: Text(habit['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${completedCount} / ${goal} ${habit['tracking_unit']}'),
                      const SizedBox(height: 10),
                      // Displaying the Progress Bar
                      LinearProgressIndicator(
                        value: progress, // Progress value (0 to 1)
                        color: Colors.blueAccent,
                        backgroundColor: Colors.grey[700],
                      ),
                      const SizedBox(height: 10),
                      // Display message when the habit is completed
                      if (progress == 1)
                        const Text(
                          'Goal Completed!',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                  onTap: () {
                    // Navigate to WaterDetailScreen when the habit is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WaterDetailScreen(
                          // habitName: habit['name'],
                          // trackingUnit: habit['tracking_unit'],
                          // duration: habit['duration'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
