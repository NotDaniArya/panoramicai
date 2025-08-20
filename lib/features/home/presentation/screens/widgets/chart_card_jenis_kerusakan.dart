import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartCardJenisKerusakan extends StatefulWidget {
  const ChartCardJenisKerusakan({super.key});

  @override
  State<ChartCardJenisKerusakan> createState() => _ChartCardJenisKerusakan();
}

class _ChartCardJenisKerusakan extends State<ChartCardJenisKerusakan> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: const Color(0xFFE3F2FD), // Warna latar belakang kartu
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            color: Colors.purple.shade300,
                            value: 10, // Nilai untuk Karies
                            title: '',
                            radius: 20,
                          ),
                          PieChartSectionData(
                            color: Colors.orange.shade400,
                            value: 40, // Nilai untuk Karies 1
                            title: '',
                            radius: 20,
                          ),
                          PieChartSectionData(
                            color: Colors.lightBlue.shade400,
                            value: 50, // Nilai untuk Karies 2
                            title: '',
                            radius: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Buat Legenda secara manual
              _buildJenisKerusakan(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget untuk membuat legenda
  Widget _buildJenisKerusakan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLegendItem(Colors.purple.shade300, 'Karies'),
        const SizedBox(height: 4),
        _buildLegendItem(Colors.orange.shade400, 'Karies 1'),
        const SizedBox(height: 4),
        _buildLegendItem(Colors.lightBlue.shade400, 'Karies 2'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
