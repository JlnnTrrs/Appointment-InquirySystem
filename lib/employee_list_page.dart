import 'package:flutter/material.dart';
import 'api_service.dart';
import 'speaker.dart';
import 'transaction_type_page.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  _EmployeeListPageState createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  List<dynamic> employees = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEmployees();
    speakText("Please choose the employee you want to request to meet");
  }

  Future<void> fetchEmployees() async {
    try {
      final data = await ApiService.fetchEmployees();
      setState(() {
        employees = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching employees: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> confirmAndSubmitAppointment(
      BuildContext context, int employeeId, String employeeName) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Appointment"),
        content: Text("Do you want to request an appointment with $employeeName?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            child: const Text("Confirm"),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (result == true) {
      await submitAppointment(context, employeeId, employeeName);
    }
  }

  Future<void> submitAppointment(
      BuildContext context, int employeeId, String employeeName) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(
          children: const [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text("Submitting..."),
          ],
        ),
      ),
    );

    try {
      await ApiService.submitAppointment(employeeId: employeeId);
      Navigator.of(context).pop(); // Close loading

      // Speak confirmation
      speakText("A request to meet with $employeeName has been made. Please wait");

      // Show 'Please wait' dialog
      await Future.delayed(const Duration(milliseconds: 1500));
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.hourglass_bottom, size: 60, color: Colors.orange),
              SizedBox(height: 16),
              Text(
                "Please wait",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const TransactionTypePage()),
        (route) => false,
      );
    } catch (e) {
      Navigator.of(context).pop(); // Close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save appointment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.shortestSide / 400).clamp(0.75, 1.4);
    final double screenWidth = size.width;
    final int crossAxisCount = (screenWidth / (220 * scale)).floor().clamp(1, 4);

    return Scaffold(
      backgroundColor: const Color(0xFFDE1923),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDE1923),
        elevation: 0,
        title: Text(
          'Select Employee for Appointment',
          style: TextStyle(
            fontSize: 20 * scale,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        toolbarHeight: 60 * scale,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24 * scale, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16 * scale),
                    child: GridView.builder(
                      itemCount: employees.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 24 * scale,
                        mainAxisSpacing: 24 * scale,
                        childAspectRatio: 2.8,
                      ),
                      itemBuilder: (context, index) {
                        final employee = employees[index];
                        final name = employee['nickname'] ?? 'Unknown';

                        return GestureDetector(
                          onTap: () => confirmAndSubmitAppointment(
                              context, employee['id'], name),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16 * scale),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16 * scale),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 20 * scale,
                                  spreadRadius: 4 * scale,
                                  offset: Offset(0, 10 * scale),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.person,
                                      color: Colors.black, size: 24 * scale),
                                  SizedBox(width: 10 * scale),
                                  Flexible(
                                    child: Text(
                                      name,
                                      style: TextStyle(
                                        fontSize: 18 * scale,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20 * scale, right: 20 * scale),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back,
                          size: 20 * scale, color: Colors.black),
                      label: Text(
                        'Back',
                        style:
                            TextStyle(fontSize: 16 * scale, color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 6,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24 * scale,
                          vertical: 14 * scale,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16 * scale),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
