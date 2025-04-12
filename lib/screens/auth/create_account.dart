import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/provider/auth_provider.dart';
import 'package:astrobandhan/screens/auth/LoginScreen.dart';
import 'package:astrobandhan/screens/dashboard/dashboard_screen.dart';
import 'package:astrobandhan/screens/home/home_scrren.dart';
import 'package:astrobandhan/utils/app_colors.dart';
import 'package:astrobandhan/utils/images.dart';
import 'package:astrobandhan/utils/text.styles.dart';
import 'package:astrobandhan/widgets/custom_app_bar_widget.dart';
import 'package:astrobandhan/widgets/custom_button.dart';
import 'package:astrobandhan/widgets/custom_textfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
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

  String selectedGender = 'Male';
  List<String> genders = ['Male', 'Female', 'Other'];

  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;

  List<String> days = List.generate(31, (index) => (index + 1).toString());

  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  List<String> years =
      List.generate(100, (index) => (DateTime.now().year - index).toString());

  DateTime? _selectedDate;
  late DateFormat _dateFormat;

  @override
  void initState() {
    super.initState();
    // Initialize the date formatting for the locale
    initializeDateFormatting().then((_) {
      setState(() {
        _dateFormat = DateFormat('yyyy-MM-dd','en_US');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset(ImageResources.screenBG,
                  fit: BoxFit.cover,
                  cacheWidth: MediaQuery.of(context).size.width.toInt())),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) => SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const AppBarWidget(
                      title: 'CREATE ACCOUNT', textAlignCenter: true),
                  SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0,
                            MediaQuery.of(context).viewInsets.bottom + 24.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height -
                                  MediaQuery.of(context).padding.top -
                                  MediaQuery.of(context).padding.bottom),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildForm(context, authProvider),
                                  const SizedBox(height: 30),
                                  CustomButtons.saveButton(
                                    onPressed: () {
                                      if (nameController.text.isEmpty) {
                                        showToastMessage("Name is required",
                                            isError: true);
                                        return;
                                      } else if (emalController.text.isEmpty) {
                                        showToastMessage("Email is required",
                                            isError: true);
                                        return;
                                      } else if (phoneController.text.isEmpty) {
                                        showToastMessage(
                                            "Phone number is required",
                                            isError: true);
                                        return;
                                      } else if (_selectedDate == null) {
                                        showToastMessage(
                                            "Date of Birth is required",
                                            isError: true);
                                        return;
                                      } else if (selectedGender == "") {
                                        showToastMessage("Gender is required",
                                            isError: true);
                                        return;
                                      } else if (placeOfBirthController
                                          .text.isEmpty) {
                                        showToastMessage(
                                            "Place of Birth is required",
                                            isError: true);
                                        return;
                                      } else if (passwordController
                                          .text.isEmpty) {
                                        showToastMessage("Password is required",
                                            isError: true);
                                        return;
                                      } else if (authProvider.profileImageUrl ==
                                              null ||
                                          authProvider
                                              .profileImageUrl!.isEmpty) {
                                        showToastMessage(
                                            "Profile image is required",
                                            isError: true);
                                        return;
                                      } else {
                                        authProvider.signUP(
                                            nameController.text,
                                            emalController.text,
                                            phoneController.text,
                                            authProvider.formatDateTime(
                                                _selectedDate ??
                                                    DateTime.now()),
                                            selectedGender,
                                            "${authProvider.selectedHour} : ${authProvider.selectedMinute} ${authProvider.selectedPeriod}",
                                            placeOfBirthController.text,
                                            passwordController.text,
                                            authProvider.profileImageUrl ??
                                                "empty", (value) {
                                          if (value) {
                                            Helper.pushRemoveScreen(
                                                context, DashboardScreen());
                                          }
                                        }, context);
                                      }
                                    },
                                    text: 'CREATE NOW',
                                  ),
                                  const SizedBox(height: 40),
                                  _buildLoginLink(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

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

  Widget _buildForm(BuildContext context, AuthProvider authProvider) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProfileImageSection(context, authProvider),
          CustomTextField(
            hintText: 'Your Name',
            labelText: 'Name',
            controller: nameController,
            focusNode: nameFocusNode,
            nextFocusNode: emailFocusNode,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Your Email',
            labelText: 'Email',
            controller: emalController,
            focusNode: emailFocusNode,
            nextFocusNode: phoneFocusNode,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            maxLength: 10,
            hintText: 'Your Phone Number',
            labelText: 'Phone Number',
            controller: phoneController,
            focusNode: phoneFocusNode,
            nextFocusNode: dobFocusNode,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 10),
                        child: _buildLabel('D.O.B')),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 12),
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
                            Icon(Icons.calendar_month,
                                color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 10),
                          child: _buildLabel('Gender')),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(color: Colors.white, width: 1)),
                        child: _buildDropdownField(
                            hint: 'Gender',
                            items: genders,
                            value: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value!;
                              });
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Place of Birth',
            labelText: 'Place of Birth',
            controller: placeOfBirthController,
            focusNode: placeOfBirthFocusNode,
            nextFocusNode: timeOfBirthFocusNode,
          ),
          const SizedBox(height: 4),
          _buildTimeOfBirthCheckbox(context, authProvider),
          _buildTimeOfBirth(authProvider, context),
          const SizedBox(height: 16),
          CustomTextField(
              hintText: 'Password',
              labelText: 'Password',
              isPassword: true,
              textInputAction: TextInputAction.done,
              controller: passwordController,
              focusNode: passwordFocusNode),
        ],
      ),
    );
  }

  Widget _buildTimeOfBirthCheckbox(
      BuildContext context, AuthProvider authProvider) {
    return Row(
      children: [
        Checkbox(
          value: authProvider.isTimeOfBirthEnabled,
          onChanged: (bool? value) {
            authProvider.changeTimeOfBirth(value ?? false);
          },
          side: const BorderSide(color: Colors.white, width: 1),
        ),
        Text('Time of Birth (Optional)',
            style: poppinsStyle500Medium.copyWith(fontSize: 12)),
      ],
    );
  }

  Widget _buildTimeOfBirth(AuthProvider authProvider, BuildContext context) {
    final List<String> hours =
        List.generate(12, (i) => (i + 1).toString().padLeft(2, '0'));
    final List<String> minutes =
        List.generate(60, (i) => i.toString().padLeft(2, '0'));
    final List<String> periods = ['AM', 'PM'];

    return Visibility(
      visible: authProvider.isTimeOfBirthEnabled,
      child: Row(
        children: [
          Expanded(
            child: _buildDropdownField(
              hint: 'Hour',
              items: hours,
              value: authProvider.selectedHour,
              // Provide a default value
              onChanged: (value) => authProvider.updateTimeOfBirth(
                value,
                authProvider.selectedMinute,
                authProvider.selectedPeriod,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildDropdownField(
              hint: 'Minute',
              items: minutes,
              value: authProvider.selectedMinute, // Provide a default value
              onChanged: (value) => authProvider.updateTimeOfBirth(
                authProvider.selectedHour,
                value,
                authProvider.selectedPeriod,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildDropdownField(
                hint: 'Period',
                items: periods,
                value: authProvider.selectedPeriod,
                onChanged: (value) => authProvider.updateTimeOfBirth(
                      authProvider.selectedHour,
                      authProvider.selectedMinute,
                      value,
                    )),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImageSection(
      BuildContext context, AuthProvider authProvider) {
    return Column(
      children: [
        _buildLabel('Profile Image', fontSize: 16),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            authProvider.selectProfileImage(context);
          },
          child: authProvider.isLoading
              ? CircularProgressIndicator()
              : CircleAvatar(
                  radius: 50,
                  backgroundImage: authProvider.profileImageUrl != null
                      ? NetworkImage(authProvider.profileImageUrl!)
                      : null,
                  child: authProvider.profileImageUrl == null
                      ? Icon(Icons.add_a_photo,
                          size: 50, color: Colors.grey[700])
                      : null,
                ),
        ),
        const SizedBox(height: 10),
        authProvider.profileImageUrl != null
            ? TextButton(
                onPressed: () {
                  authProvider.removeProfileImage();
                },
                child: Text('Remove Image',
                    style: poppinsStyle500Medium.copyWith(color: Colors.red)),
              )
            : SizedBox.shrink(),
      ],
    );
  }

  Widget _buildLabel(String label, {double fontSize = 14}) {
    return Text(label, style: poppinsStyle500Medium.copyWith(fontSize: fontSize));
  }

  Widget _buildDropdownField(
      {required String hint,
      required List<String> items,
      String? value,
      ValueChanged<String?>? onChanged}) {
    return DropdownButton<String>(
      value: items.contains(value) ? value : items.first,
      hint: Text(hint, style: TextStyle(color: Colors.white.withAlpha(128))),
      isExpanded: true,
      underline: const SizedBox(),
      dropdownColor: kPrimaryColor,
      icon: Icon(Icons.keyboard_arrow_down, color: Colors.white.withAlpha(128)),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
            value: item,
            child: Text(item,
                style: poppinsStyle500Medium.copyWith(
                    fontSize: 15, color: Colors.white)));
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildLoginLink() {
    return GestureDetector(
      onTap: () {
        // Navigate to login screen
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      },
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: 'Already have an account? ',
              style: poppinsStyle400Regular.copyWith(
                  fontSize: 16, color: Colors.white.withOpacity(0.8)),
              children: [
                TextSpan(
                    text: 'Sign In',
                    style: interStyle600SemiBold.copyWith(
                        fontSize: 16, color: Colors.white))
              ])),
    );
  }

  @override
  void dispose() {
    // Dispose of controllers and focus nodes
    nameController.dispose();
    emalController.dispose();
    phoneController.dispose();
    dobController.dispose();
    placeOfBirthController.dispose();
    timeOfBirthController.dispose();
    passwordController.dispose();

    nameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    dobFocusNode.dispose();
    placeOfBirthFocusNode.dispose();
    timeOfBirthFocusNode.dispose();
    passwordFocusNode.dispose();

    super.dispose();
  }
}
