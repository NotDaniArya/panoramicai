import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:panoramicai/utils/constant/colors.dart';

class ChartCardJumlahDeteksi extends StatelessWidget {
  const ChartCardJumlahDeteksi({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('histori_deteksi')
          .snapshots(),
      builder: (context, snapshot) {
        int totalUsers = 0; // Ubah nama variabel agar lebih relevan

        if (snapshot.hasData) {
          // Gunakan Set untuk menyaring userId yang duplikat
          Set<String> uniqueUserIds = {};

          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final String? userId = data['userId'] as String?;

            // Masukkan userId ke dalam Set jika tidak null/kosong
            if (userId != null && userId.isNotEmpty) {
              uniqueUserIds.add(userId);
            }
          }

          // Panjang dari Set ini adalah jumlah orang/user yang unik
          totalUsers = uniqueUserIds.length;
        }

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
                        Text(
                          '$totalUsers', // Tampilkan variabel yang baru
                          style: const TextStyle(
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
                                value: totalUsers == 0
                                    ? 1
                                    : totalUsers.toDouble(),
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
                    'Number of People Detecting', // Label disesuaikan agar lebih logis
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
      },
    );
  }
}
