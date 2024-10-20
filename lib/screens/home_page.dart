import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/jitsi_helper.dart';
import '../helpers/network_helper.dart';
import '../helpers/notification_service.dart';
import '../helpers/shared_pref_helper.dart';

class HomePage extends StatefulWidget {
  final String? meetId;
  const HomePage({super.key, this.meetId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _meetIdInputTextController = TextEditingController();
  final SharedPrefHelper _sharedPrefHelper = SharedPrefHelper();
  String? email;
  String? name;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    if (widget.meetId != null) {
      _meetIdInputTextController.text = widget.meetId!;
    }
  }

  Future<void> _loadUserData() async {
    email = await _sharedPrefHelper.getEmail();
    name = await _sharedPrefHelper.getName();

    if (email == null || name == null) {
      _showUserInputDialog();
    }
  }

  Future<void> _showUserInputDialog() async {
    String tempEmail = '';
    String tempName = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter your details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: 'Email'),
                onChanged: (value) => tempEmail = value,
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'Name'),
                onChanged: (value) => tempName = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_isValidEmail(tempEmail) && tempName.isNotEmpty) {
                  await _sharedPrefHelper.saveUserDetails(tempEmail, tempName); // Save user details
                  email = tempEmail;
                  name = tempName;
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  _showSnackbar('Please enter valid email and name.');
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _meetIdInputTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: TextField(
                controller: _meetIdInputTextController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: 'Enter meeting ID',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                String meetId = _meetIdInputTextController.text.trim();
                if (meetId.isEmpty) {
                  _showSnackbar('All fields are required.');
                } else {
                  _checkConnectionAndProceed(() {
                    JitsiHelper().joinMeeting(
                      meetId: meetId,
                      email: email!,
                      name: name!,
                    );
                    NotificationService.sendNotification(context, meetId, email!);
                  });
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Join",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _checkConnectionAndProceed(Function action) async {
    NetworkHelper networkHelper = NetworkHelper();
    if (await networkHelper.isConnected()) {
      action();
    } else {
      _showSnackbar('No internet connection. Please try again.');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

}