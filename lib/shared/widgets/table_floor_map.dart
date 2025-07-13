import 'package:flutter/material.dart';
import 'package:flutter_fiksi/features/restaurant/domain/entities/table.dart';
import 'dart:math' as math;

class TableFloorMap extends StatelessWidget {
  final List<RestaurantTable> tables;
  final RestaurantTable? selectedTable;
  final Function(RestaurantTable) onTableSelected;

  const TableFloorMap({
    super.key,
    required this.tables,
    required this.onTableSelected,
    this.selectedTable,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;

        // Calculate responsive table size based on available space
        final tableSize = _calculateTableSize(availableWidth, availableHeight);

        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200, width: 1),
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFFF8F9FA),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background elements (static) - Keep only Kitchen
              Positioned(
                right: availableWidth * 0.02,
                bottom: availableHeight * 0.02,
                child: _buildStaticElement('Kitchen', Colors.orange.shade100),
              ),

              // Dynamic tables based on API data
              ...tables.asMap().entries.map((entry) {
                final index = entry.key;
                final table = entry.value;
                return _buildTableWidget(
                  table,
                  index,
                  context,
                  availableWidth,
                  availableHeight,
                  tableSize,
                );
              }),
            ],
          ),
        );
      },
    );
  }

  double _calculateTableSize(double availableWidth, double availableHeight) {
    // Calculate table size based on available space
    // More conservative approach to prevent overflow
    final widthBasedSize =
        (availableWidth - 60) / 3.5; // 3 columns with generous padding
    final heightBasedSize =
        (availableHeight - 80) / 4.5; // 4 rows with generous padding

    // Use the smaller dimension and clamp to safer bounds
    final calculatedSize = math.min(widthBasedSize, heightBasedSize);
    return math.max(
      35,
      math.min(calculatedSize, 55),
    ); // Smaller max size to prevent overflow
  }

  Widget _buildStaticElement(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.7), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF495057),
        ),
      ),
    );
  }

  Widget _buildTableWidget(
    RestaurantTable table,
    int index,
    BuildContext context,
    double availableWidth,
    double availableHeight,
    double tableSize,
  ) {
    final positions = _getTablePositions();
    final position = positions[index % positions.length];

    final isSelected = selectedTable?.id == table.id;
    final canSelect = table.isAvailable;

    Color tableColor;
    Color borderColor;
    Color textColor;

    if (table.isAvailable) {
      tableColor =
          isSelected ? const Color(0xFF343A40) : const Color(0xFF495057);
      borderColor =
          isSelected ? const Color(0xFF212529) : const Color(0xFF343A40);
      textColor = Colors.white;
    } else if (table.isOccupied) {
      tableColor = const Color(0xFFDC3545);
      borderColor = const Color(0xFFC82333);
      textColor = Colors.white;
    } else {
      // reserved
      tableColor = const Color(0xFFFF6B35);
      borderColor = const Color(0xFFE55A2B);
      textColor = Colors.white;
    }

    return Positioned(
      left:
          (position['x']! * (availableWidth - tableSize)) +
          (tableSize * 0.05), // Slight padding adjustment
      top:
          (position['y']! * (availableHeight - tableSize)) +
          (tableSize * 0.05), // Slight padding adjustment
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: GestureDetector(
          onTap: canSelect ? () => onTableSelected(table) : null,
          child: Container(
            width: tableSize, // Dynamic size
            height: tableSize, // Dynamic size
            decoration: BoxDecoration(
              color: tableColor,
              borderRadius: BorderRadius.circular(
                tableSize * 0.2,
              ), // Proportional radius
              border: Border.all(color: borderColor, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color:
                      isSelected
                          ? Colors.black.withValues(alpha: 0.3)
                          : Colors.black.withValues(alpha: 0.15),
                  blurRadius: isSelected ? 12 : 8,
                  spreadRadius: isSelected ? 2 : 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${table.id}',
                  style: TextStyle(
                    fontSize: (tableSize * 0.25).clamp(
                      12.0,
                      20.0,
                    ), // Proportional font size
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: tableSize * 0.05),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: tableSize * 0.1,
                    vertical: tableSize * 0.025,
                  ),
                  decoration: BoxDecoration(
                    color: textColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(tableSize * 0.1),
                  ),
                  child: Text(
                    '${table.capacity ?? 2}p',
                    style: TextStyle(
                      fontSize: (tableSize * 0.15).clamp(
                        9.0,
                        12.0,
                      ), // Proportional font size
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, double>> _getTablePositions() {
    // Conservative positions to prevent overflow
    return [
      {'x': 0.10, 'y': 0.10}, // Table 1 - safer margins
      {'x': 0.40, 'y': 0.10}, // Table 2 - center column
      {'x': 0.70, 'y': 0.10}, // Table 3 - safer margins
      {'x': 0.10, 'y': 0.35}, // Table 4 - better spacing
      {'x': 0.40, 'y': 0.35}, // Table 5 - center
      {'x': 0.70, 'y': 0.35}, // Table 6 - better spacing
      {'x': 0.10, 'y': 0.60}, // Table 7 - better spacing
      {'x': 0.40, 'y': 0.60}, // Table 8 - center
      {'x': 0.70, 'y': 0.60}, // Table 9 - better spacing
      {'x': 0.25, 'y': 0.80}, // Table 10 - centered bottom row
      {'x': 0.55, 'y': 0.80}, // Table 11+ - centered bottom row
    ];
  }
}

class TableStatusLegend extends StatelessWidget {
  const TableStatusLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9ECEF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLegendItem('Available', const Color(0xFF495057)),
          _buildLegendItem('Occupied', const Color(0xFFDC3545)),
          _buildLegendItem('Reserved', const Color(0xFFFF6B35)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withValues(alpha: 0.8), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 3,
                spreadRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF495057),
          ),
        ),
      ],
    );
  }
}
