import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Progress", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[700],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Add the new "Quick View" section here
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.supervisor_account, size: 50, color: Colors.blue),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Quick View", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text("Here are your porgress", style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Existing report cards
            _buildReportCard("Caloric Progress", _buildPieChart()),
            _buildReportCard("Progress", _buildLineChart()),
          ],
        ),
      ),
    );
  }

  /// 🔹 **Report Card UI**
  Widget _buildReportCard(String title, Widget chart) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800])),
            SizedBox(height: 10),
            chart,
          ],
        ),
      ),
    );
  }

  /// 🔹 **Pie Chart (Service Completion)**
  Widget _buildPieChart() {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(value: 120, title: "Completed", color: Colors.green, radius: 65),
                PieChartSectionData(value: 25, title: "Pending", color: Colors.red, radius: 55),
              ],
              centerSpaceRadius: 45,
              sectionsSpace: 3,
            ),
          ),
        ),
        _buildLegend([
          _legendItem("Completed", Colors.green),
          _legendItem("Pending", Colors.red),
        ]),
      ],
    );
  }

  /// 🔹 **Line Chart (Waste Collection Trend)**
  Widget _buildLineChart() {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              spots: [
                FlSpot(1, 200), FlSpot(2, 400), FlSpot(3, 500),
                FlSpot(4, 700), FlSpot(5, 650), FlSpot(6, 800),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 **Legend Widget (Fixed)**
  Widget _buildLegend(List<Widget> items) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        children: items,
      ),
    );
  }

  /// 🔹 **Legend Item (Fixed)**
  Widget _legendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}// yea i have to add this part will do it in the near future after the DB