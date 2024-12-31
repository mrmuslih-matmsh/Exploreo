import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? _selectedCategory;
  XFile? _coverImage;
  List<XFile> _galleryImages = [];
  String? _currentUserEmail;

  final List<String> _categories = [
    'Local Tours',
    'Food Sharing',
    'Skills Exchange',
  ];

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserEmail = prefs.getString('email');
    });
  }

  Future<void> _pickCoverImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _coverImage = image;
      });
    }
  }

  Future<void> _pickGalleryImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      setState(() {
        _galleryImages = images;
      });
    }
  }

  Future<String> _uploadImageToCloudinary(XFile image) async {
    const String cloudinaryUrl =
        "https://api.cloudinary.com/v1_1/dr9oixybv/image/upload";
    const String uploadPreset = "flutter_upload";

    final file = File(image.path);

    final request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl))
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    debugPrint('Sending request to: ${request.url}');
    debugPrint('Upload preset: ${uploadPreset}');
    debugPrint('File path: ${file.path}');

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final Map<String, dynamic> data = json.decode(responseData.body);
        return data['secure_url'];
      } else {
        debugPrint(
            'Image upload failed with status code: ${response.statusCode}');
        return Future.error(
            'Image upload failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Image upload failed: $e');
      return Future.error('Image upload failed: $e');
    }
  }

  Future<List<String>> _uploadMultipleImagesToCloudinary(
      List<XFile> images) async {
    List<String> uploadedUrls = [];
    for (var image in images) {
      final url = await _uploadImageToCloudinary(image);
      uploadedUrls.add(url);
    }
    return uploadedUrls;
  }

  Future<void> _submitPost() async {
    if (_coverImage == null ||
        _galleryImages.isEmpty ||
        _titleController.text.isEmpty ||
        _selectedCategory == null ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all fields and select images.'),
        ),
      );
      return;
    }

    try {
      // Upload images to Cloudinary
      final String coverImageUrl = await _uploadImageToCloudinary(_coverImage!);
      final List<String> galleryImageUrls =
          await _uploadMultipleImagesToCloudinary(_galleryImages);

      // Get the current date without time
      String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Prepare post details with a timestamp and postid
      Map<String, dynamic> postDetails = {
        "category": _selectedCategory,
        "coverimage": coverImageUrl,
        "description": _descriptionController.text,
        "images": galleryImageUrls,
        "location": _locationController.text,
        "posted_by": _currentUserEmail ?? "anonymous",
        "price": _priceController.text,
        "rating": 0.0,
        "timestamp": formattedDate,
        "title": _titleController.text,
      };

      // Save to Firestore and retrieve the document reference
      DocumentReference postRef =
          await FirebaseFirestore.instance.collection('posts').add(postDetails);

      String postid = postRef.id;

      // Update the post with the postid (set it to match the document id)
      await postRef.update({
        "postid": postid,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post added successfully!')),
      );

      // Clear fields after submission
      setState(() {
        _coverImage = null;
        _galleryImages = [];
        _titleController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _locationController.clear();
        _selectedCategory = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('New Post'),
        backgroundColor: Colors.grey[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickCoverImage,
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _coverImage == null
                        ? const Center(
                            child: Text('Tap to select a cover image'))
                        : Image.file(
                            File(_coverImage!.path),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _pickGalleryImages,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Select Gallery Images'),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _galleryImages.map((image) {
                  return Image.file(
                    File(image.path),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select Category',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: screenWidth,
                child: ElevatedButton(
                  onPressed: _submitPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Add Post',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
