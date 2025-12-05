import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int userId = 1; 
  int level = 1;
  int xp = 0;
  int xpNeeded = 100;

  List<bool> completed = [false, false, false];

  final List<Map<String, dynamic>> quests = [
    {"id": 1, "title": "Cek Lahan Hari Ini", "desc": "Isi kondisi lahan", "xp": 10, "type": "Harian"},
    {"id": 2, "title": "Input Data Panen", "desc": "Laporkan hasil panen", "xp": 5, "type": "Harian"},
    {"id": 3, "title": "Laporan Pertumbuhan Mingguan", "desc": "Laporkan pertumbuhan tanaman", "xp": 30, "type": "Mingguan"},
  ];

  // ============================================
  // LOAD DATA USER + QUEST PROGRESS
  // ============================================
  Future<void> loadUserData() async {
    try {
      final url = Uri.parse("http://10.121.167.10/api/get_user_data.php?user_id=$userId");
      final response = await http.get(url);

      if (response.statusCode != 200) return;

      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        setState(() {
          xp = int.parse(data["user"]["xp"]);
          level = int.parse(data["user"]["level"]);
          xpNeeded = int.parse(data["user"]["xp_needed"]);

          for (int i = 0; i < quests.length; i++) {
            int qid = quests[i]["id"];
            completed[i] = data["progress"][qid.toString()] == 1;
          }
        });
      }
    } catch (e) {
      print("Error loadUserData: $e");
    }
  }

  // ============================================
  // UPDATE QUEST + XP USER
  // ============================================
  Future<void> updateQuest(int questIndex) async {
    int questId = quests[questIndex]["id"];
    int xpReward = quests[questIndex]["xp"];

    try {
      final url = Uri.parse("http://10.121.167.10/api/update_quest.php");

      final response = await http.post(url, body: {
        "user_id": userId.toString(),
        "quest_id": questId.toString(),
        "xp_reward": xpReward.toString(),
      });

      if (response.statusCode != 200) return;

      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        setState(() {
          xp = data["new_xp"];
          level = data["new_level"];
          xpNeeded = data["next_xp_needed"];
          completed[questIndex] = true;
        });
      }
    } catch (e) {
      print("Error updateQuest: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
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
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text("XP: $xp / $xpNeeded",
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 6),

                LinearProgressIndicator(
                  value: xpNeeded > 0 ? xp / xpNeeded : 0,
                  minHeight: 10,
                  backgroundColor: Colors.white,
                  color: Colors.green.shade800,
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
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
                          child: const Icon(Icons.eco,
                              color: Colors.green, size: 30),
                        ),
                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(quest["title"],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),

                              Text(
                                quest["desc"],
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 10),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("+${quest["xp"]} XP",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(quest["type"],
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                  )
                                ],
                              ),
                              const SizedBox(height: 12),

                              // ================= BUTTON FIXED ==================
                              ElevatedButton(
                                onPressed: completed[index]
                                    ? null
                                    : () => updateQuest(index),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: completed[index]
                                      ? Colors.grey
                                      : Colors.green,
                                  minimumSize:
                                      const Size(double.infinity, 40),
                                ),
                                child: Text(
                                  completed[index]
                                      ? "Completed"
                                      : "Accept Quest",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
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
