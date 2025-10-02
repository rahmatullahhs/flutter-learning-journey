import 'dart:io';
import 'dart:typed_data';
import 'package:date_field/date_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:radio_group_v2/radio_group_v2.dart' as v2;
import 'package:test_and_learn/pages/loginpage.dart';
import '../service/authservice.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});
  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool _obscurePassword = true;

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController cell = TextEditingController();
  final TextEditingController address = TextEditingController();

  final v2.RadioGroupController genderController = v2.RadioGroupController();

  final DateTimeFieldPickerPlatform dobPlatform =
      DateTimeFieldPickerPlatform.material;

  String? selectedGender;
  DateTime? selectedDOB;

  XFile? selectedImage;
  Uint8List? webImage;
  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    cell.dispose();
    address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Full Name
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (val) =>
                  (val == null || val.isEmpty) ? 'Enter your name' : null,
                ),
                const SizedBox(height: 20),

                // Email
                TextFormField(
                  controller: email,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.alternate_email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => (val == null || val.isEmpty)
                      ? 'Enter email'
                      : (!val.contains('@') ? 'Invalid email' : null),
                ),
                const SizedBox(height: 20),

                // Password
                TextFormField(
                  controller: password,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (val) =>
                  (val == null || val.length < 6)
                      ? 'Password must be >= 6 chars'
                      : null,
                ),
                const SizedBox(height: 20),

                // Confirm Password
                TextFormField(
                  controller: confirmPassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (val) => (val != password.text)
                      ? 'Passwords do not match'
                      : null,
                ),
                const SizedBox(height: 20),

                // Cell number
                TextFormField(
                  controller: cell,
                  decoration: const InputDecoration(
                    labelText: 'Cell Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (val) =>
                  (val == null || val.isEmpty) ? 'Enter phone' : null,
                ),
                const SizedBox(height: 20),

                // Address
                TextFormField(
                  controller: address,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.home),
                  ),
                  validator: (val) =>
                  (val == null || val.isEmpty) ? 'Enter address' : null,
                ),
                const SizedBox(height: 20),

                // DOB
                DateTimeFormField(
                  decoration:
                  const InputDecoration(labelText: 'Date of Birth'),
                  mode: DateTimeFieldPickerMode.date,
                  pickerPlatform: dobPlatform,
                  onChanged: (DateTime? v) {
                    selectedDOB = v;
                  },
                  validator: (val) =>
                  (val == null) ? 'Select your DOB' : null,
                ),
                const SizedBox(height: 20),

                // Gender
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Gender:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      v2.RadioGroup(
                        controller: genderController,
                        values: const ["Male", "Female", "Other"],
                        indexOfDefault: 0,
                        orientation: v2.RadioGroupOrientation.horizontal,
                        onChanged: (newValue) {
                          selectedGender = newValue;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Upload Image
                TextButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text('Upload Image'),
                  onPressed: pickImage,
                ),
                const SizedBox(height: 8),
                if (kIsWeb && webImage != null)
                  Image.memory(
                    webImage!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  )
                else if (!kIsWeb && selectedImage != null)
                  Image.file(
                    File(selectedImage!.path),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _register,
                  child: const Text("Register"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text(
                    'Already have an account? Login',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
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

  Future<void> pickImage() async {
    if (kIsWeb) {
      var picked = await ImagePickerWeb.getImageAsBytes();
      if (picked != null) {
        setState(() {
          webImage = picked;
        });
      }
    } else {
      final XFile? picked =
      await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          selectedImage = picked;
        });
      }
    }
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!kIsWeb && selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image.')),
      );
      return;
    }
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image upload not supported on Web yet.')),
      );
      // Or handle web image differently
      return;
    }

    final user = {
      "name": name.text,
      "email": email.text,
      "phone": cell.text,
      "password": password.text,
    };
    final jobSeeker = {
      "name": name.text,
      "email": email.text,
      "phone": cell.text,
      "gender": selectedGender ?? "Other",
      "address": address.text,
      "dateOfBirth": selectedDOB?.toIso8601String() ?? "",
    };

    final api = AuthService();
    bool success = await api.registerJobSeeker(
      user: user,
      jobSeeker: jobSeeker,
      photo: File(selectedImage!.path),
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Failed')),
      );
    }
  }
}
