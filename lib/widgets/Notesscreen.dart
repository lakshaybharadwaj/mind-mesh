import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final Map<String, List<TextEditingController>> controllersMap = {};
  final Map<String, List<FocusNode>> focusNodesMap = {};
  final Map<String, List<String>> notes = {};
  final LiquidController liquidController = LiquidController();

  void setupControllersForDate(String date) {
    if (!controllersMap.containsKey(date)) {
      final totalHeight = MediaQuery.of(context).size.height;
      final reservedHeight = 220;
      final lineHeight = 32;
      final lineCount = ((totalHeight - reservedHeight) / lineHeight).floor();

      final savedNotes = notes.putIfAbsent(
        date,
            () => List.generate(lineCount, (index) => ''),
      );

      controllersMap[date] = List.generate(
        savedNotes.length,
            (index) => TextEditingController(text: savedNotes[index]),
      );
      focusNodesMap[date] =
          List.generate(savedNotes.length, (_) => FocusNode());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        final today = DateFormat('dd/MM/yyyy').format(DateTime.now());
        setupControllersForDate(today);
      });
    });
  }

  @override
  void dispose() {
    for (var controllerList in controllersMap.values) {
      for (var controller in controllerList) {
        controller.dispose();
      }
    }
    for (var focusList in focusNodesMap.values) {
      for (var focus in focusList) {
        focus.dispose();
      }
    }
    super.dispose();
  }

  void _moveToNextField(String date, int currentIndex) {
    final nodes = focusNodesMap[date]!;
    if (currentIndex + 1 < nodes.length) {
      FocusScope.of(context).requestFocus(nodes[currentIndex + 1]);
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  Widget buildNotePage(String formattedDate, int index) {
    setupControllersForDate(formattedDate);
    final controllers = controllersMap[formattedDate]!;
    final focusNodes = focusNodesMap[formattedDate]!;

    final List<Color> lineColors = [
      Colors.brown,
      Colors.deepOrange,
      Colors.teal,
      Colors.blueGrey,
      Colors.green,
      Colors.indigo,
      Colors.purple
    ];
    final Color lineColor = lineColors[index % lineColors.length];

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(3, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DancingScript',
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Page ${index + 1}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'DancingScript',
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: lineColor, thickness: 1),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(controllers.length, (lineIndex) {
                        return Container(
                          height: 32,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: lineColor, width: 0.4),
                            ),
                          ),
                          child: TextField(
                            controller: controllers[lineIndex],
                            focusNode: focusNodes[lineIndex],
                            maxLines: 1,
                            onChanged: (text) {
                              notes[formattedDate]![lineIndex] = text;
                            },
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'DancingScript',
                              color: Colors.black87,
                            ),
                            textInputAction: lineIndex + 1 <
                                controllers.length
                                ? TextInputAction.next
                                : TextInputAction.done,
                            onSubmitted: (_) {
                              _moveToNextField(formattedDate, lineIndex);
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 12),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Media Picker Icon (Left of the + button)
                    IconButton(
                      icon: Icon(Icons.image, size: 32, color: Color(0xFF0D0D0D)),
                      onPressed: () {
                        // Media picker functionality
                      },
                    ),
                    // Plus Button
                    IconButton(
                      icon: Icon(Icons.add_circle, size: 32, color: lineColor),
                      onPressed: () {
                        setState(() {
                          notes[formattedDate]!.add('');
                          controllers.add(TextEditingController());
                          focusNodes.add(FocusNode());
                        });
                      },
                    ),
                    // Voice Recorder Icon (Right of the + button)
                    IconButton(
                      icon: Icon(Icons.mic, size: 32, color: Color(0xFF0D0D0D)),
                      onPressed: () {
                        // Voice recorder functionality
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 30),
                    ),
                  ),
                  const Text(
                    'NOTES',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.settings,
                          color: Colors.white, size: 30),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(color: Colors.white, thickness: 1),
            ],
          ),
        ),
      ),
      body: LiquidSwipe(
        liquidController: liquidController,
        enableLoop: true,
        waveType: WaveType.liquidReveal,
        fullTransitionValue: 600,
        slideIconWidget: const Icon(Icons.arrow_back_ios, color: Colors.brown),
        positionSlideIcon: 0.5,
        pages: List.generate(365, (index) {
          final pageDate = DateTime.now().add(Duration(days: index));
          final formattedDate = DateFormat('dd/MM/yyyy').format(pageDate);
          return buildNotePage(formattedDate, index);
        }),
      ),
    );
  }
}