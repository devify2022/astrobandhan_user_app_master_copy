import 'package:astrobandhan/screens/user/user_editProfile_screen.dart';
import 'package:flutter/material.dart';
import 'package:astrobandhan/datasource/model/auth/user_model.dart'; // Import your user model

class UserDetailsScreen extends StatelessWidget {
  final UserModel userModel;

  const UserDetailsScreen({Key? key, required this.userModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Details",
          style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.white60),
        ),
        backgroundColor: const Color.fromARGB(
            0, 248, 248, 248), // Change this to match your design
        iconTheme:
            const IconThemeData(color: Colors.white), // Make back button white
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Photo
            CircleAvatar(
              radius: 60,
              backgroundImage: userModel.photo != null
                  ? NetworkImage(userModel.photo!)
                  : const AssetImage('assets/default_avatar.png')
                      as ImageProvider,
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 20),

            // User Details
            _buildDetailRow("Name", userModel.name),
            _buildDetailRow("Email", userModel.email),
            _buildDetailRow("Phone", userModel.phone),
            _buildDetailRow(
                "Date of Birth",
                userModel.dateOfBirth?.toLocal().toString().split(' ')[0] ??
                    'N/A'),
            _buildDetailRow("Place of Birth", userModel.placeOfBirth),
            _buildDetailRow("Gender", userModel.gender),
            _buildDetailRow("Wallet Balance",
                userModel.walletBalance?.toStringAsFixed(2) ?? '0.00'),

            const SizedBox(height: 20),

            // Edit Profile Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditProfileScreen(userModel: userModel),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                "Edit Profile",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build detail rows
  Widget _buildDetailRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              "$title:",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 14, color: Color.fromARGB(137, 255, 255, 255)),
            ),
          ),
        ],
      ),
    );
  }
}
