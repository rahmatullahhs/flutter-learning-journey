import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String? _gender = 'Male'; // Default selected
  DateTime? _dateOfBirth;
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  void _pickDateOfBirth() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  void _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // or ImageSource.camera
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _register() {
    // For now, just go back to login
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Radio<String>(
                  value: 'Male',
                  groupValue: _gender,
                  onChanged: (value) => setState(() => _gender = value),
                ),
                const Text('Male'),
                Radio<String>(
                  value: 'Female',
                  groupValue: _gender,
                  onChanged: (value) => setState(() => _gender = value),
                ),
                const Text('Female'),
                Radio<String>(
                  value: 'Other',
                  groupValue: _gender,
                  onChanged: (value) => setState(() => _gender = value),
                ),
                const Text('Other'),
              ],
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickDateOfBirth,
                  child: const Text('Select Date of Birth'),
                ),
                const SizedBox(width: 10),
                Text(
                  _dateOfBirth != null
                      ? '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'
                      : 'No date selected',
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Select Photo'),
                ),
                const SizedBox(width: 10),
                _imageFile != null
                    ? CircleAvatar(
                  backgroundImage: FileImage(_imageFile!),
                  radius: 30,
                )
                    : const Text('No photo selected'),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _register,
                child: const Text('Register'),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Already have an account? Login'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
