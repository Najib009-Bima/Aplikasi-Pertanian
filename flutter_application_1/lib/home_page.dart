import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> panenData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF3), // hijau soft
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Dashboard PanenX",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/");
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // ---------------- INPUT HASIL PANEN ----------------
            menuCard(
              icon: Icons.edit,
              title: "Input Hasil Panen",
              onTap: () async {
                var result = await Navigator.pushNamed(context, "/input");

                if (result != null) {
                  setState(() {
                    panenData.add(result as Map<String, dynamic>);
                  });
                }
              },
            ),

            const SizedBox(height: 15),

            // ---------------- RIWAYAT ----------------
            menuCard(
              icon: Icons.history,
              title: "Riwayat Panen",
              onTap: () {
                Navigator.pushNamed(
                  context,
                  "/riwayat",
                  arguments: panenData,
                );
              },
            ),

            const SizedBox(height: 15),

            // ---------------- GRAFIK ----------------
            menuCard(
              icon: Icons.bar_chart,
              title: "Grafik Panen",
              onTap: () {
                Navigator.pushNamed(
                  context,
                  "/grafik",
                  arguments: panenData,
                );
              },
            ),

            const SizedBox(height: 15),

            // ---------------- QUEST (GAMIFIKASI) ----------------
            menuCard(
              icon: Icons.sports_esports, // ikon Quest
              title: "Quest & Gamifikasi",
              onTap: () {
                Navigator.pushNamed(context, "/quest");
              },
            ),
          ],
        ),
      ),
    );
  }

  // ==================== WIDGET MENU ====================
  Widget menuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFDFF5D8), // hijau muda
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.green[800]),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.green[900],
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
