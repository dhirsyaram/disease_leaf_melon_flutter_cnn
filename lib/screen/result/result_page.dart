import 'dart:io';

import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:detection_disease_leaf_melon_fruits/data/prediction_result.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResultPage extends StatelessWidget {
  final PredictionResult result;
  final File imageFile;

  const ResultPage({super.key, required this.result, required this.imageFile});

  // Function to format numbers to 4 decimal places and replace "." with ","
  String formatNumber(dynamic value) {
    // Check if the value is a double
    if (value is double) {
      // If it's a double, format it to 4 decimal places and replace the dot with a comma
      String formatted = value.toStringAsFixed(4);

      if (formatted.endsWith('.0000')) {
        formatted = formatted.substring(0, formatted.indexOf('.'));
      } else {
        formatted = formatted.replaceAll('.', ',');
      }
      return formatted;
    } else if (value is int) {
      // If it's an integer, return it as it is (no decimals)
      return value.toString();
    } else {
      // Default case: if the value is neither double nor int, return an empty string
      return '';
    }
  }

  String formatConfidence(double value) {
    // Jika value 0-1, dikali 100. Jika sudah dalam persen, biarkan.
    double percentage = value <= 1.0 ? value * 100 : value;
    // Gunakan 2/3/4 desimal sesuai selera, biasanya 2 sudah cukup
    String formatted = percentage.toStringAsFixed(2).replaceAll('.', ',');
    return formatted;
  }

  String formatProbability(double value) {
    if (value > 1.0) {
      // Sudah persen
      return '${value.toStringAsFixed(2).replaceAll('.', ',')}%';
    } else {
      // Masih proporsi
      return '${(value).toStringAsFixed(2).replaceAll('.', ',')}%';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (result.className.isEmpty || result.confidence == 0.0) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Hasil Deteksi", style: TextStyle(fontSize: 160)),
        ),
        body: const Center(child: Text("Tidak ada hasil deteksi yang valid")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hasil Deteksi",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            // 1. Hapus file gambar jika ada
            try {
              if (await imageFile.exists()) {
                await imageFile.delete();
                debugPrint('✅ File dihapus: ${imageFile.path}');
              }
            } catch (e) {
              debugPrint('⚠️ Gagal menghapus file: $e');
            }
            // 2. Navigasi kembali ke halaman utama
            context.go('/');
          },
        ),
        backgroundColor: Colors.green[800],
        elevation: 4.0,
        centerTitle: true,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InteractiveViewer(
              panEnabled: true,
              minScale: 1,
              maxScale: 4,
              child: Image.file(
                imageFile,
                height: 250,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            CupertinoCard(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(212, 215, 0, 1.0),
                    Color.fromRGBO(128, 185, 24, 1.0),
                    Color.fromRGBO(170, 204, 0, 1.0),
                    Color.fromRGBO(191, 210, 0, 1.0),
                    Color.fromRGBO(212, 215, 0, 1.0),
                  ],
                ),
              ),
              elevation: 2.0,
              radius: const BorderRadius.all(Radius.circular(50.0)),
              margin: const EdgeInsets.symmetric(
                horizontal: 70,
                vertical: 10.0,
              ),
              child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${result.className} :",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "${formatConfidence(result.confidence)}%",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Table for displaying features
            const SizedBox(height: 20),
            const Text(
              "Probabilitas Semua Kelas:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Table(
              border: TableBorder.all(color: Colors.grey),
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Kelas",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Keyakinan (%)",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ...result.allProbabilities.entries.map((entry) {
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(entry.key),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(formatProbability(entry.value)),
                      ),
                    ],
                  );
                }),
              ],
            ),
            const SizedBox(height: 20),

            // Modal for Features
            FilledButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "Fitur Bentuk:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Table(
                                border: TableBorder.all(color: Colors.grey),
                                children: [
                                  ...result.features['bentuk'].entries.map((
                                    entry,
                                  ) {
                                    return TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(entry.key),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            formatNumber(entry.value),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Fitur Tekstur:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Table(
                                border: TableBorder.all(color: Colors.grey),
                                children: [
                                  ...result.features['tekstur'].entries.map((
                                    entry,
                                  ) {
                                    return TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(entry.key),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            formatNumber(entry.value),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Fitur Warna:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Table(
                                border: TableBorder.all(color: Colors.grey),
                                children: [
                                  ...result.features['warna'].entries.map((
                                    entry,
                                  ) {
                                    return TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(entry.key),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            formatNumber(entry.value),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(Size(double.infinity, 50)),
                backgroundColor: WidgetStateProperty.all(
                  Color.fromRGBO(212, 215, 0, 1.0),
                ),
              ),
              child: const Text(
                "Lihat Fitur Lengkap",
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
