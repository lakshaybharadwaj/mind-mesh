import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewHabitScreen extends StatefulWidget {
  const NewHabitScreen({super.key});

  @override
  _NewHabitScreenState createState() => _NewHabitScreenState();
}

class _NewHabitScreenState extends State<NewHabitScreen> {
  final TextEditingController nameController = TextEditingController();
  String trackingUnit = 'Days';
  double duration = 1;
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> addHabitToSupabase() async {
    final name = nameController.text;
    if (name.isEmpty) {
      _showAnimatedSnackbar('Please enter a habit name!', false);
      return;
    }

    try {
      final response = await supabase.from('habits').upsert([{
        'name': name,
        'tracking_unit': trackingUnit,
        'duration': duration.round(),
      }]);

      _showAnimatedSnackbar('Habit added successfully!', true);

      // Wait for the snackbar animation before popping the screen
      await Future.delayed(const Duration(milliseconds: 1500));

      // Pop back to the previous screen (DashboardScreen)
      if (mounted) {
        Navigator.pop(context);  // This will pop the current screen (NewHabitScreen) off the stack
      }
    } catch (e) {
      _showAnimatedSnackbar('Error: ${e.toString()}', false);
    }
  }

  void _showAnimatedSnackbar(String message, bool isSuccess) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).viewInsets.top + 50,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: isSuccess ? Colors.green[700] : Colors.red[700],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  isSuccess ? Icons.check_circle : Icons.error,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove(); // Ensure snackbar is removed after 3 seconds
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.add_circle_outline, size: 30, color: Colors.white),
            SizedBox(width: 12),
            Text('New Habit', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Divider(color: Colors.white, thickness: 1),

            // Habit Name Field
            const SizedBox(height: 20),
            const Text("Habit Name", style: TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "e.g. Meditation",
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            // Tracking Unit Dropdown
            const SizedBox(height: 20),
            const Text("Tracking Unit", style: TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: trackingUnit,
                onChanged: (String? newValue) {
                  setState(() {
                    trackingUnit = newValue!;
                    duration = 1;
                  });
                },
                dropdownColor: Colors.grey[850],
                isExpanded: true,
                underline: Container(),
                items: <String>['Days', 'Hours', 'Minutes', 'Months']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(color: Colors.white)));
                }).toList(),
              ),
            ),

            // Duration Slider
            const SizedBox(height: 20),
            Text("Duration (${duration.round()} $trackingUnit)", style: const TextStyle(color: Colors.white70, fontSize: 16)),
            Slider(
              value: duration,
              min: 1,
              max: trackingUnit == 'Days' ? 30
                  : trackingUnit == 'Hours' ? 24
                  : trackingUnit == 'Minutes' ? 60
                  : 12,
              divisions: trackingUnit == 'Days' ? 30
                  : trackingUnit == 'Hours' ? 24
                  : trackingUnit == 'Minutes' ? 60
                  : 12,
              activeColor: Colors.blueAccent,
              inactiveColor: Colors.grey[700],
              label: duration.round().toString(),
              onChanged: (value) => setState(() => duration = value),
            ),

            const Spacer(),

            // Add Habit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: addHabitToSupabase,
                child: const Text("Add Habit", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
