import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartCardJumlahDeteksi extends StatefulWidget {
  const ChartCardJumlahDeteksi({super.key});

  @override
  State<ChartCardJumlahDeteksi> createState() => _ChartCardJumlahDeteksi();
}

class _ChartCardJumlahDeteksi extends State<ChartCardJumlahDeteksi> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 300,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: const Color(0xFFE3F2FD), // Warna latar belakang kartu
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                // 1. Gunakan Stack untuk menumpuk Teks di tengah Bagan
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Teks di tengah
                    const Text(
                      '30',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    // 2. Bagan Pie dari fl_chart
                    PieChart(
                      PieChartData(
                        // Mengatur agar lubang di tengah ada (ini yang membuatnya jadi donat)
                        centerSpaceRadius: 50,

                        // Menghilangkan label di setiap bagian
                        sectionsSpace: 0, // Jarak antar bagian
                        // Data untuk setiap bagian berwarna
                        sections: [
                          PieChartSectionData(
                            color: Colors.lightBlue.shade400,
                            value: 100, // Nilai untuk Karies
                            title: '',
                            radius: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Text('Orang mendeteksi', textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
