import 'package:flutter/material.dart';

void main() {
  runApp(PeriodTrackerApp());
}

class PeriodTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Period Tracker',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? selectedDate;
  int cycleLength = 28;

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void calculateNextPeriod() {
    if (selectedDate != null) {
      DateTime nextPeriod =
          selectedDate!.add(Duration(days: cycleLength));

      DateTime fertileStart =
          nextPeriod.subtract(Duration(days: 14));

      DateTime fertileEnd =
          fertileStart.add(Duration(days: 5));

      String result =
          "🌸 Next Period\n${nextPeriod.day}/${nextPeriod.month}/${nextPeriod.year}\n\n"
          "💖 Fertile Window\n${fertileStart.day}/${fertileStart.month} - ${fertileEnd.day}/${fertileEnd.month}";

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(result: result),
        ),
      );
    }
  }

  Widget buildCard({required Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF9AA2), Color(0xFFFFDDE1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "🌸 Period Tracker",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 20),

                buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Last Period Date",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(
                        selectedDate == null
                            ? "No date selected"
                            : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => pickDate(context),
                        child: Text("Pick Date"),
                      ),
                    ],
                  ),
                ),

                buildCard(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Cycle Length (days)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      cycleLength = int.tryParse(value) ?? 28;
                    },
                  ),
                ),

                SizedBox(height: 10),

                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: calculateNextPeriod,
                    child: Text(
                      "Calculate",
                      style: TextStyle(fontSize: 16),
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
}

class ResultPage extends StatelessWidget {
  final String result;

  ResultPage({required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Prediction"),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFDDE1), Color(0xFFFF9AA2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 8,
            margin: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                result,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink[800],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}