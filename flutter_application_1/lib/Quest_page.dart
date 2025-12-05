import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class QuestPage extends StatefulWidget {
  const QuestPage({super.key});

  @override
  State<QuestPage> createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> with TickerProviderStateMixin {
  int userId = 1;
  int level = 1;
  int xp = 0;
  int xpNeeded = 100;

  List<bool> completed = [false, false, false];

  final List<Map<String, dynamic>> quests = [
    {"id": 1, "title": "Cek Lahan Hari Ini", "desc": "Isi kondisi lahan", "xp": 10, "type": "Harian"},
    {"id": 2, "title": "Input Data Panen", "desc": "Laporkan hasil panen", "xp": 5, "type": "Harian"},
    {"id": 3, "title": "Laporan Pertumbuhan Mingguan", "desc": "Laporkan tinggi tanaman", "xp": 30, "type": "Mingguan"},
  ];

  late AnimationController _controller;
  late Animation<double> _xpAnimation;

  @override
  void initState() {
    super.initState();
    loadUserData();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _xpAnimation = Tween<double>(begin: 0, end: 0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ======================= LOAD USER =======================
  Future<void> loadUserData() async {
    // Dummy initial data
    setState(() {
      xp = 20;
      level = 1;
      xpNeeded = 100;
      completed = [false, false, false];
    });
  }

  // ======================= ACCEPT QUEST =======================
  Future<void> updateQuest(int index) async {
    if (completed[index]) return;

    int xpReward = quests[index]["xp"];
    int newXp = xp + xpReward;
    int newLevel = level;
    int newXpNeeded = xpNeeded;

    // Simulasi level up jika XP melebihi xpNeeded
    if (newXp >= xpNeeded) {
      newLevel += 1;
      newXp = newXp - xpNeeded;
      newXpNeeded += 50 + Random().nextInt(50); // XP needed meningkat random
    }

    // Animation XP
    _xpAnimation = Tween<double>(begin: xp.toDouble(), end: newXp.toDouble()).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward(from: 0);

    // Update state setelah animasi selesai
    Timer(const Duration(milliseconds: 800), () {
      setState(() {
        xp = newXp;
        level = newLevel;
        xpNeeded = newXpNeeded;
        completed[index] = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text("Quest Pertanian"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // =================== PLAYER STATUS ====================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.green.shade200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Level $level",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                AnimatedBuilder(
                  animation: _xpAnimation,
                  builder: (context, child) {
                    return Text(
                      "XP: ${_xpAnimation.value.toInt()} / $xpNeeded",
                      style: const TextStyle(fontSize: 16),
                    );
                  },
                ),
                const SizedBox(height: 6),
                AnimatedBuilder(
                  animation: _xpAnimation,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: xpNeeded > 0 ? _xpAnimation.value / xpNeeded : 0,
                      minHeight: 10,
                      backgroundColor: Colors.white,
                      color: Colors.green.shade800,
                    );
                  },
                ),
              ],
            ),
          ),

          // ==================== QUEST LIST ======================
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: quests.length,
              itemBuilder: (context, index) {
                final quest = quests[index];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.eco, color: Colors.green, size: 30),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(quest["title"],
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text(quest["desc"], style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("+${quest["xp"]} XP",
                                      style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(quest["type"], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  )
                                ],
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: completed[index] ? null : () => updateQuest(index),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: completed[index] ? Colors.grey : Colors.green,
                                  minimumSize: const Size(double.infinity, 40),
                                ),
                                child: Text(
                                  completed[index] ? "Completed" : "Accept Quest",
                                  style: const TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
