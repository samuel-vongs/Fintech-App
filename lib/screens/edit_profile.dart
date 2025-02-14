import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  final VoidCallback onProfileUpdated;

  const EditProfileScreen({super.key, required this.onProfileUpdated});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  File? _image;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchUserProfile();
  }

  void _fetchUserProfile() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      setState(() {
        _imageUrl =
            userDoc['profileImage'] ?? ''; // Fetch the latest profile image
      });
    }
  }

  Future<void> _fetchUserData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      setState(() {
        _nameController.text = userDoc['name'] ?? '';
        _phoneController.text = userDoc['phone'] ?? '';
        _addressController.text = userDoc['address'] ?? '';
        _dobController.text = userDoc['dob'] ?? '';
        _bioController.text = userDoc['bio'] ?? '';
        _imageUrl = userDoc['profileImage'];
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Choose from Gallery", style: GoogleFonts.roboto()),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Take a Photo", style: GoogleFonts.roboto()),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Automatically upload after selecting the image
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      Reference storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');

      UploadTask uploadTask = storageRef.putFile(_image!);
      TaskSnapshot snapshot = await uploadTask;

      String imageUrl = await snapshot.ref.getDownloadURL();

      // Save the new image URL to Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'profileImage': imageUrl,
      });

      // Fetch the updated image URL immediately
      setState(() {
        _imageUrl = imageUrl; // Update the UI with the new image
      });

      print("✅ Image uploaded and updated successfully: $imageUrl");
    } catch (e) {
      print("❌ Image upload failed: $e");
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'bio': _bioController.text,
        'profileImage': _imageUrl,
      });

      widget.onProfileUpdated();
      Navigator.pop(context);

      // Show a Snackbar to indicate successful profile update
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!',
              style: GoogleFonts.roboto()),
          backgroundColor: Colors.green, // Green color for success
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print("Profile update failed: $e");

      // Show an error Snackbar in case of failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile. Please try again.',
              style: GoogleFonts.roboto()),
          backgroundColor: Colors.red, // Red color for failure
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xff001c39),
          title: Text(
            'Edit Profile',
            style: GoogleFonts.roboto()
                .copyWith(color: Colors.white, fontSize: 20),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/user-profile');
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage:
                              _imageUrl != null && _imageUrl!.isNotEmpty
                                  ? NetworkImage(_imageUrl!)
                                  : AssetImage('assets/profile.png')
                                      as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor:
                                Colors.orange, // Orange color for the edit icon
                            child: Icon(Icons.camera_alt, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(_nameController, 'Full Name', Icons.person),
                _buildTextField(_phoneController, 'Phone Number', Icons.phone),
                _buildTextField(_addressController, 'Address', Icons.home),
                _buildBioField(_bioController, 'Bio'),
                const SizedBox(height: 20),
                _isUploading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Color(0xff001c39), // Orange color for the button
                        ),
                        child: Text('Save Changes',
                            style: GoogleFonts.roboto()
                                .copyWith(color: Colors.white)),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.roboto(), // Apply Roboto font to input text
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.roboto(), // Apply Roboto font to label
          prefixIcon: Icon(
            icon,
            color: Colors.orange,
          ),
          fillColor: Colors.grey[100], // Grey fill color
          filled: true,
          border: InputBorder.none, // No border
        ),
      ),
    );
  }

  Widget _buildBioField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.roboto(), // Apply Roboto font to input text
        maxLines: 3, // Larger field for bio
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            Icons.info,
            color: Colors.orange,
          ),
          labelStyle: GoogleFonts.roboto(), // Apply Roboto font to label
          fillColor: Colors.grey[100],
          filled: true,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
