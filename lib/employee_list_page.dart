import 'dart:async';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'speaker.dart';
import 'custom_header.dart';
import 'dialogs.dart';
import 'idle_screen_page.dart'; // ✅ Import IdleScreenPage

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  _EmployeeListPageState createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  List<dynamic> employees = [];
  bool isLoading = true;
  Timer? _inactivityTimer; // ✅ Inactivity timer

  @override
  void initState() {
    super.initState();
    fetchEmployees();
    speakText("Please choose the employee you want to request to meet.");
    _startInactivityTimer();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  void _startInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 45), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const IdleScreenPage()),
      );
    });
  }

  void _resetInactivityTimer() {
    _startInactivityTimer();
  }

  Future<void> fetchEmployees() async {
    try {
      final data = await ApiService.fetchEmployees();

      final filtered = data
          .where((e) => (e['status']?.toLowerCase() ?? '') != 'resigned')
          .toList();

      filtered.sort((a, b) {
        final aStatus = (a['status'] ?? '').toLowerCase();
        final bStatus = (b['status'] ?? '').toLowerCase();

        if (aStatus == 'available' && bStatus != 'available') return -1;
        if (aStatus != 'available' && bStatus == 'available') return 1;
        return 0;
      });

      setState(() {
        employees = filtered;
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
    _inactivityTimer?.cancel();

    speakText("Are you sure you want to request an appointment with $employeeName?");
    final bool? confirmed =
        await showConfirmationDialog(context, employeeName, 'appointment');

    if (confirmed != true) {
      _startInactivityTimer();
      return;
    }

    speakText("A request to meet with $employeeName has been made. Please wait");

    try {
      await ApiService.submitAppointment(employeeId: employeeId);
      await showSuccessScreen(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save appointment: $e')),
      );
    }
  }

  Widget buildEmployeeButton(
      BuildContext context, dynamic employee, double scale) {
    final name = employee['nickname'] ?? 'Unknown';
    final id = employee['id'];
    final status = (employee['status'] ?? 'available').toLowerCase();
    final isUnavailable = status == 'unavailable';

    return GestureDetector(
      onTap: isUnavailable
          ? () {
              _resetInactivityTimer();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Employee unavailable. Please choose another employee.',
                  ),
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                ),
              );
            }
          : () {
              confirmAndSubmitAppointment(context, id, name);
            },
      child: Opacity(
        opacity: isUnavailable ? 0.4 : 1.0,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 14 * scale),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16 * scale),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 6 * scale,
                offset: Offset(0, 4 * scale),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 24 * scale,
                height: 24 * scale,
                child: Image.asset('assets/logos/mis_logo_loading.png'),
              ),
              SizedBox(width: 10 * scale),
              Flexible(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 20 * scale,
                    fontFamily: 'OpenSans',
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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final scale = ((width + height) / 2) / 800;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _resetInactivityTimer,
      onPanDown: (_) => _resetInactivityTimer(),
      child: Scaffold(
        backgroundColor: const Color(0xFFBE0002),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  const CustomHeader(),
                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05,
                              vertical: 35 * scale,
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 6),
                                Text(
                                  'PLEASE SELECT AN EMPLOYEE',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 28 * scale.clamp(0.9, 1.4),
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Montserrat',
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: Center(
                                    child: employees.length <= 4
                                        ? GridView.count(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 20 * scale,
                                            crossAxisSpacing: 20 * scale,
                                            childAspectRatio: 4.0,
                                            children: employees
                                                .map((e) => buildEmployeeButton(context, e, scale))
                                                .toList(),
                                          )
                                        : LayoutBuilder(
                                            builder: (context, constraints) {
                                              int crossAxisCount = 2;
                                              double maxWidth = constraints.maxWidth;

                                              if (maxWidth >= 1200) {
                                                crossAxisCount = 5;
                                              } else if (maxWidth >= 900) {
                                                crossAxisCount = 4;
                                              } else if (maxWidth >= 600) {
                                                crossAxisCount = 3;
                                              }

                                              return GridView.builder(
                                                padding: const EdgeInsets.only(top: 8),
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: crossAxisCount,
                                                  mainAxisSpacing: 20 * scale,
                                                  crossAxisSpacing: 30 * scale,
                                                  childAspectRatio: 4.5,
                                                ),
                                                itemCount: employees.length,
                                                itemBuilder: (context, index) {
                                                  return buildEmployeeButton(
                                                      context, employees[index], scale);
                                                },
                                              );
                                            },
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      _inactivityTimer?.cancel();
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.arrow_back,
                                        size: 20 * scale, color: Colors.black),
                                    label: Text(
                                      'Back',
                                      style: TextStyle(
                                        fontSize: 15 * scale.clamp(0.9, 1.1),
                                        color: Colors.black,
                                        fontFamily: 'OpenSans',
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      elevation: 6,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20 * scale,
                                        vertical: 12 * scale,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14 * scale),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15 * scale),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '© 2025 University of Mindanao. All Rights Reserved.',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12 * scale.clamp(0.8, 1.1),
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
