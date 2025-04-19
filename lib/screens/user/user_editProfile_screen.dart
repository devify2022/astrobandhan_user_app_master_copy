import 'package:flutter/material.dart';
import 'package:astrobandhan/datasource/model/auth/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel userModel;

  const EditProfileScreen({Key? key, required this.userModel})
      : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController placeOfBirthController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userModel.name);
    emailController = TextEditingController(text: widget.userModel.email);
    phoneController = TextEditingController(text: widget.userModel.phone);
    placeOfBirthController =
        TextEditingController(text: widget.userModel.placeOfBirth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Edit Photo
              CircleAvatar(
                radius: 60,
                backgroundImage: widget.userModel.photo != null
                    ? NetworkImage(widget.userModel.photo!)
                    : const AssetImage('assets/default_avatar.png')
                        as ImageProvider,
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement photo upload logic here
                  print("Edit Photo Button Pressed");
                },
                child: const Text("Change Profile Photo"),
              ),
              const SizedBox(height: 20),

              // Editable Fields
              _buildTextField("Name", nameController),
              _buildTextField("Email", emailController),
              _buildTextField("Phone", phoneController),
              _buildTextField("Place of Birth", placeOfBirthController),

              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  print("Updated Name: ${nameController.text}");
                  print("Updated Email: ${emailController.text}");
                  print("Updated Phone: ${phoneController.text}");
                  print(
                      "Updated Place of Birth: ${placeOfBirthController.text}");
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text("Submit", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build text fields
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
