import 'package:flutter/material.dart';

class CariesDescriptionTable extends StatelessWidget {
  const CariesDescriptionTable({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withOpacity(0.5), width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Table(
          border: TableBorder(
            verticalInside: BorderSide(
              color: Colors.black.withOpacity(0.5),
              width: 0.5,
            ),
            horizontalInside: BorderSide(
              color: Colors.black.withOpacity(0.5),
              width: 0.5,
            ),
          ),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              children: [
                _buildCell(
                  'RA\nInitial Stage',
                  isHeader: true,
                  textTheme: textTheme,
                ),
                _buildCell(
                  'RB\nModerate Stage',
                  isHeader: true,
                  textTheme: textTheme,
                ),
                _buildCell(
                  'RC\nExtensive Stage',
                  isHeader: true,
                  textTheme: textTheme,
                ),
              ],
            ),
            TableRow(
              children: [
                _buildCell(
                  'Radiolucency in the enamel ± EDJ (enamel–dentin junction)',
                  textTheme: textTheme,
                ),
                _buildCell(
                  'Radiolucency in the outer or middle 1/3 of dentin',
                  textTheme: textTheme,
                ),
                _buildCell(
                  'Radiolucency in the inner 1/3 of dentin or into the pulp',
                  textTheme: textTheme,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCell(
      String text, {
        bool isHeader = false,
        required TextTheme textTheme,
      }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: textTheme.bodySmall!.copyWith(
          fontSize: 10,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: Colors.black,
        ),
      ),
    );
  }
}