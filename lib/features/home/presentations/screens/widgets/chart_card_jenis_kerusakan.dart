import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:panoramicai/utils/constant/colors.dart';

class ChartCardJenisKerusakan extends StatelessWidget {
  const ChartCardJenisKerusakan({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('histori_deteksi')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        int kariesCount = 0;
        int numberingCount = 0;

        if (snapshot.hasData) {
          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final type = data['type'] as String?;
            if (type == 'Karies') {
              kariesCount++;
            } else if (type == 'Numbering') {
              numberingCount++;
            }
          }
        }

        final totalCount = kariesCount + numberingCount;

        return SizedBox(
          height: 240, // Tinggi disamakan dengan kartu sebelahnya
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            // Sedikit dikurangi agar lebih proporsional
            color: const Color(0xFFE3F2FD),
            child: Padding(
              padding: const EdgeInsets.all(12.0), // Padding dikurangi sedikit
              child: Column(
                // UBAH KE COLUMN
                children: [
                  const Text(
                    'Your Detection Type',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Chart Section (di atas)
                  Expanded(
                    flex: 3,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$totalCount',
                              style: const TextStyle(
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
                            centerSpaceRadius: 35, // Diperkecil lagi agar fit
                            sectionsSpace: 2,
                            startDegreeOffset: 270,
                            sections: [
                              PieChartSectionData(
                                color: const Color(0xFFFF1493),
                                value: kariesCount == 0 && numberingCount == 0
                                    ? 1
                                    : kariesCount.toDouble(),
                                radius: 12,
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                color: const Color(0xFFFFA500),
                                value: kariesCount == 0 && numberingCount == 0
                                    ? 0
                                    : numberingCount.toDouble(),
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

                  // Legend Section (di bawah)
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegendItem(
                          const Color(0xFFFFA500),
                          'Dental Caries',
                          kariesCount,
                        ),
                        const SizedBox(height: 6),
                        _buildLegendItem(
                          const Color(0xFFFF1493),
                          'Tooth Numbering',
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
      },
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
