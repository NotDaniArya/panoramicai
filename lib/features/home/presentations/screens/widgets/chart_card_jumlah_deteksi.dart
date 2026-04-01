import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:panoramicai/utils/constant/colors.dart';

class ChartCardJumlahDeteksi extends StatelessWidget {
  const ChartCardJumlahDeteksi({super.key});

  @override
  Widget build(BuildContext context) {
    // Mocking data instead of StreamBuilder with Firebase
    const int totalUsers = 125; 

    return SizedBox(
      height: 240,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: const Color(0xFFE3F2FD),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 12.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Text(
                      '$totalUsers', 
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: TColors.primaryColor,
                      ),
                    ),
                    PieChart(
                      PieChartData(
                        centerSpaceRadius: 40,
                        sectionsSpace: 0,
                        sections: [
                          PieChartSectionData(
                            color: TColors.primaryColor.withOpacity(0.8),
                            value: totalUsers.toDouble(),
                            title: '',
                            radius: 12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              const Text(
                'Orang Mendeteksi', 
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
