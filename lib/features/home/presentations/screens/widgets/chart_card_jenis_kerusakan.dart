import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:panoramicai/utils/constant/colors.dart';

class ChartCardJenisKerusakan extends StatelessWidget {
  const ChartCardJenisKerusakan({super.key});

  @override
  Widget build(BuildContext context) {
    // Mocking data instead of StreamBuilder with Firebase
    const int kariesCount = 10;
    const int numberingCount = 5;
    const int totalCount = kariesCount + numberingCount;

    return SizedBox(
      height: 240, 
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: const Color(0xFFE3F2FD),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const Text(
                'Jenis Deteksi Anda',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Expanded(
                flex: 3,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '$totalCount',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: TColors.primaryColor,
                          ),
                        ),
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    PieChart(
                      PieChartData(
                        centerSpaceRadius: 35,
                        sectionsSpace: 2,
                        startDegreeOffset: 270,
                        sections: [
                          PieChartSectionData(
                            color: const Color(0xFFFF1493),
                            value: kariesCount.toDouble(),
                            radius: 12,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            color: const Color(0xFFFFA500),
                            value: numberingCount.toDouble(),
                            radius: 12,
                            showTitle: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem(
                      const Color(0xFFFFA500),
                      'Karies',
                      kariesCount,
                    ),
                    const SizedBox(height: 6),
                    _buildLegendItem(
                      const Color(0xFFFF1493),
                      'Numbering',
                      numberingCount,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text, int count) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
