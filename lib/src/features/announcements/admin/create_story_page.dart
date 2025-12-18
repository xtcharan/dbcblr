import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/api_service.dart';
import '../../../shared/models/post.dart';
import '../../../shared/services/posts_api_service.dart';
import '../../../shared/utils/theme_colors.dart';

class CreateStoryPage extends StatefulWidget {
  const CreateStoryPage({super.key});

  @override
  State<CreateStoryPage> createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends State<CreateStoryPage> {
  final _descriptionController = TextEditingController();
  
  final ImagePicker _imagePicker = ImagePicker();
  final ApiService _apiService = ApiService();
  late PostsApiService _postsApiService;
  
  File? _selectedImage;
  ContentType _contentType = ContentType.image;
  String? _selectedClubId;
  String? _selectedHouseId;
  bool _isLoading = false;
  bool _isUploadingImage = false;
  String? _uploadedImageUrl;
  String? _uploadedThumbnailUrl;
  
  // Available clubs and houses for tagging
  List<Map<String, dynamic>> _clubs = [];
  List<Map<String, dynamic>> _houses = [];
  bool _isLoadingOptions = true;

  @override
  void initState() {
    super.initState();
    _postsApiService = PostsApiService(
      baseUrl: ApiService.baseUrl,
      authToken: null,
    );
    _loadClubsAndHouses();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadClubsAndHouses() async {
    try {
      final clubs = await _apiService.getClubs();
      final houses = await _apiService.getHouses();
      
      if (mounted) {
        setState(() {
          _clubs = clubs.map((c) => {'id': c['id'], 'name': c['name']}).toList();
          _houses = houses.map((h) => {'id': h['id'], 'name': h['name']}).toList();
          _isLoadingOptions = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingOptions = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeColors.surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.purple),
                ),
                title: Text(
                  'Take Photo',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _selectImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.photo_library, color: Colors.purple),
                ),
                title: Text(
                  'Choose from Gallery',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _selectImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1920, // Stories are typically vertical
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _uploadedImageUrl = null;
          _uploadedThumbnailUrl = null;
        });
        
        await _uploadImage();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;
    
    setState(() {
      _isUploadingImage = true;
    });
    
    try {
      final url = await _apiService.uploadImage(_selectedImage!);
      if (mounted) {
        setState(() {
          _uploadedImageUrl = url;
          _uploadedThumbnailUrl = url; // Using same image as thumbnail
          _isUploadingImage = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _uploadedImageUrl = null;
      _uploadedThumbnailUrl = null;
    });
  }

  Future<void> _submitStory() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image for your story'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    if (_uploadedImageUrl == null || _uploadedThumbnailUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please wait for the image to finish uploading'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      await _postsApiService.createStory(
        contentType: _contentType,
        imageUrl: _uploadedImageUrl,
        thumbnailUrl: _uploadedThumbnailUrl!,
        description: _descriptionController.text.trim().isNotEmpty 
            ? _descriptionController.text.trim() 
            : null,
        clubId: _selectedClubId,
        houseId: _selectedHouseId,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Story created! It will expire in 24 hours.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create story: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'New Story',
          style: GoogleFonts.urbanist(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isLoading || _isUploadingImage ? null : _submitStory,
            child: Text(
              'Share',
              style: GoogleFonts.urbanist(
                color: _isLoading || _isUploadingImage 
                    ? Colors.grey 
                    : Colors.purple,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Image Preview Area
          Expanded(
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.grey[800]!,
                    width: 1,
                  ),
                ),
                child: _selectedImage != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(23),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Upload progress overlay
                          if (_isUploadingImage)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(23),
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(color: Colors.purple),
                                    SizedBox(height: 12),
                                    Text(
                                      'Uploading...',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          // Upload success indicator
                          if (_uploadedImageUrl != null)
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          // Remove button
                          Positioned(
                            top: 16,
                            left: 16,
                            child: GestureDetector(
                              onTap: _removeImage,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          // Expiry badge
                          Positioned(
                            bottom: 16,
                            left: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Expires in 24h',
                                    style: GoogleFonts.urbanist(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 56,
                              color: Colors.purple,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Tap to add a story',
                            style: GoogleFonts.urbanist(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Stories disappear after 24 hours',
                            style: GoogleFonts.urbanist(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          
          // Bottom section with caption and tag options
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Caption input
                  TextField(
                    controller: _descriptionController,
                    style: GoogleFonts.urbanist(color: Colors.white),
                    maxLength: 150,
                    decoration: InputDecoration(
                      hintText: 'Add a caption...',
                      hintStyle: GoogleFonts.urbanist(color: Colors.grey[600]),
                      border: InputBorder.none,
                      counterStyle: GoogleFonts.urbanist(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ),
                  
                  const Divider(color: Colors.grey),
                  
                  // Tag options row
                  if (!_isLoadingOptions && (_clubs.isNotEmpty || _houses.isNotEmpty))
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // Club chips
                          ..._clubs.take(3).map((club) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(
                                club['name'],
                                style: GoogleFonts.urbanist(
                                  color: _selectedClubId == club['id'] 
                                      ? Colors.white 
                                      : Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                              selected: _selectedClubId == club['id'],
                              selectedColor: Colors.purple,
                              backgroundColor: Colors.grey[800],
                              onSelected: (selected) {
                                setState(() {
                                  _selectedClubId = selected ? club['id'] : null;
                                  _selectedHouseId = null;
                                });
                              },
                            ),
                          )),
                          // House chips
                          ..._houses.take(3).map((house) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(
                                house['name'],
                                style: GoogleFonts.urbanist(
                                  color: _selectedHouseId == house['id'] 
                                      ? Colors.white 
                                      : Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                              selected: _selectedHouseId == house['id'],
                              selectedColor: Colors.blue,
                              backgroundColor: Colors.grey[800],
                              onSelected: (selected) {
                                setState(() {
                                  _selectedHouseId = selected ? house['id'] : null;
                                  _selectedClubId = null;
                                });
                              },
                            ),
                          )),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Share button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading || _isUploadingImage || _selectedImage == null 
                          ? null 
                          : _submitStory,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        disabledBackgroundColor: Colors.grey[700],
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add_circle_outline, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Add to Your Story',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
