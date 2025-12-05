import 'package:flutter/material.dart';

class RiwayatPage extends StatefulWidget {
  final List<Map<String, dynamic>> panenData;

  const RiwayatPage({super.key, required this.panenData});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BB661),
        title: const Text("Riwayat Panen", style: TextStyle(color: Colors.white)),
      ),

      body: widget.panenData.isEmpty
          ? const Center(child: Text("Belum ada data panen"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.panenData.length,
              itemBuilder: (context, index) {
                final item = widget.panenData[index];

                return Card(
                  elevation: 3,
                  child: ListTile(
                    title: Text(item["nama"]),
                    subtitle: Text("Jumlah: ${item["jumlah"]} Kg\nTanggal: ${item["tanggal"]}"),
                    trailing: const Icon(Icons.check_circle, color: Colors.green),
                  ),
                );
              },
            ),
    );
  }
}
