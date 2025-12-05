import 'package:flutter/material.dart';

class InputPanenPage extends StatefulWidget {
  const InputPanenPage({super.key});

  @override
  State<InputPanenPage> createState() => _InputPanenPageState();
}

class _InputPanenPageState extends State<InputPanenPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();
  DateTime? selectedDate;

  void submitData() {
    if (namaController.text.isEmpty ||
        jumlahController.text.isEmpty ||
        selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap isi semua data!")),
      );
      return;
    }

    Navigator.pop(context, {
      "nama": namaController.text,
      "jumlah": int.parse(jumlahController.text),
      "tanggal": selectedDate.toString().split(" ")[0],
    });
  }

  Future pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: now,
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BB661),
        title: const Text("Input Hasil Panen", style: TextStyle(color: Colors.white)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: "Nama Tanaman",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: jumlahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Jumlah Panen (Kg)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            InkWell(
              onTap: pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  selectedDate == null
                      ? "Pilih Tanggal"
                      : "Tanggal: ${selectedDate.toString().split(" ")[0]}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7BB661),
                ),
                child: const Text("Simpan", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
