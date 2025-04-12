import 'package:astrobandhan/utils/text.styles.dart';
import 'package:astrobandhan/widgets/custom_textfield.dart';
import 'package:easy_localization/easy_localization.dart' show DateFormat;
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emalController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController placeOfBirthController = TextEditingController();
  final TextEditingController timeOfBirthController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode dobFocusNode = FocusNode();
  final FocusNode placeOfBirthFocusNode = FocusNode();
  final FocusNode timeOfBirthFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
        
             CustomTextField(
            hintText: 'Your Name',
            labelText: 'Name',
            controller: nameController,
            focusNode: nameFocusNode,
            nextFocusNode: emailFocusNode,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Your Phone Number',
            labelText: 'Phone Number',
            controller: phoneController,
            focusNode: phoneFocusNode,
            nextFocusNode: dobFocusNode,
          ),

Row(
  children: [
    Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate != null
                            ? _dateFormat.format(_selectedDate!)
                            : "Select Date",
                        style: poppinsStyle400Regular.copyWith(
                            fontSize: 15.0,
                            color: _selectedDate != null
                                ? Colors.white
                                : Colors.white.withAlpha(100)),
                      ),
                    ),
                    Icon(Icons.calendar_month, color: Colors.white, size: 20),
                  ],
                ),
              ),
  ],
)

        ],
      ),
    );
  }
    DateTime? _selectedDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd','en_US');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      // Minimum date
      lastDate: DateTime.now(),
      // Maximum date
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.orange, // Header background color
            hintColor: Colors.orange, // Active control color
            colorScheme: ColorScheme.light(primary: Colors.orange),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}