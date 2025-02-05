import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  final VoidCallback
      onProfileUpdated; // Callback to refresh User Profile Screen
  final Map<String, String>? userData;

  const EditProfileScreen(
      {super.key, required this.onProfileUpdated, this.userData});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _image;
  bool _isSaving = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadImageLocally();

    _nameController.text = widget.userData?['name'] ?? '';
    _phoneController.text = widget.userData?['phone'] ?? '';
    _addressController.text = widget.userData?['address'] ?? '';
    _dobController.text = widget.userData?['dob'] ?? '';
    _bioController.text = widget.userData?['bio'] ?? '';
  }

  /// Function to pick image and save locally
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final savedImagePath = await _saveImageLocally(File(pickedFile.path));
      setState(() {
        _image = File(savedImagePath);
      });
    }
  }

  /// Save the image locally
  Future<String> _saveImageLocally(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/profile_image.png';
    final savedImage = await imageFile.copy(imagePath);
    return savedImage.path;
  }

  /// Load image from local storage
  Future<void> _loadImageLocally() async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/profile_image.png';
    final file = File(imagePath);
    if (file.existsSync()) {
      setState(() {
        _image = file;
      });
    }
  }

  /// Save profile details to Firestore
  Future<void> _saveProfile() async {
    setState(() {
      _isSaving = true;
    });

    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      Map<String, dynamic> updatedData = {
        'name': _nameController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'dob': _dobController.text,
        'bio': _bioController.text,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update(updatedData);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Profile updated successfully!",
              style: GoogleFonts.roboto())));

      // Notify User Profile Screen to refresh
      widget.onProfileUpdated();

      // Navigate back to User Profile Screen
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Error updating profile: $e", style: GoogleFonts.roboto())));
    }

    setState(() {
      _isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit Profile',
            style: GoogleFonts.roboto(color: Colors.white)),
        backgroundColor: const Color(0xff001c39),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Back to User Profile
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : AssetImage('assets/profile.png') as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt, color: Colors.orange),
                        onPressed: _pickImage,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField('Name', _nameController),
              _buildTextField('Phone', _phoneController),
              _buildTextField('Address', _addressController),
              _buildTextField('Date of Birth', _dobController),
              _buildTextField('Bio', _bioController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff001c39),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: _isSaving
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Save',
                        style: GoogleFonts.roboto(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Text field widget
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.roboto(color: const Color(0xff001c39)),
          filled: true,
          fillColor: Colors.grey[100],
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
        ),
      ),
    );
  }
}
