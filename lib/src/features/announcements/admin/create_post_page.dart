import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/api_service.dart';
import '../../../shared/models/post.dart';
import '../../../shared/services/posts_api_service.dart';
import '../../../shared/utils/theme_colors.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _hashtagController = TextEditingController();
  
  final ImagePicker _imagePicker = ImagePicker();
  final ApiService _apiService = ApiService();
  late PostsApiService _postsApiService;
  
  File? _selectedImage;
  ContentType _contentType = ContentType.image;
  String? _selectedClubId;
  String? _selectedHouseId;
  List<String> _hashtags = [];
  bool _isLoading = false;
  bool _isUploadingImage = false;
  String? _uploadedImageUrl;
  
  // Available clubs and houses for tagging
  List<Map<String, dynamic>> _clubs = [];
  List<Map<String, dynamic>> _houses = [];
  bool _isLoadingOptions = true;

  @override
  void initState() {
    super.initState();
    _postsApiService = PostsApiService(
      baseUrl: ApiService.baseUrl,
      authToken: null, // Will be set from auth service
    );
    _loadClubsAndHouses();
    _descriptionController.addListener(_parseHashtags);
  }

  @override
  void dispose() {
    _descriptionController.removeListener(_parseHashtags);
    _descriptionController.dispose();
    _hashtagController.dispose();
    super.dispose();
  }

  void _parseHashtags() {
    final text = _descriptionController.text;
    final regex = RegExp(r'#(\w+)');
    final matches = regex.allMatches(text);
    final extracted = matches.map((m) => m.group(1)!).toList();
    
    setState(() {
      _hashtags = extracted.toSet().toList(); // Remove duplicates
    });
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
                    color: ThemeColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.camera_alt, color: ThemeColors.primary),
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
                    color: ThemeColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.photo_library, color: ThemeColors.primary),
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
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _uploadedImageUrl = null;
        });
        
        // Upload image immediately
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
    });
  }

  void _addHashtag() {
    final tag = _hashtagController.text.trim().replaceAll('#', '');
    if (tag.isNotEmpty && !_hashtags.contains(tag)) {
      setState(() {
        _hashtags.add(tag);
      });
      _hashtagController.clear();
    }
  }

  void _removeHashtag(String tag) {
    setState(() {
      _hashtags.remove(tag);
    });
  }

  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image for your post'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    if (_uploadedImageUrl == null) {
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
      final request = CreatePostRequest(
        contentType: _contentType,
        imageUrl: _uploadedImageUrl,
        description: _descriptionController.text.trim(),
        hashtags: _hashtags,
        clubId: _selectedClubId,
        houseId: _selectedHouseId,
      );
      
      await _postsApiService.createPost(request);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post created successfully!'),
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
            content: Text('Failed to create post: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background(context),
      appBar: AppBar(
        backgroundColor: ThemeColors.surface(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: ThemeColors.text(context)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'New Post',
          style: GoogleFonts.urbanist(
            color: ThemeColors.text(context),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isLoading || _isUploadingImage ? null : _submitPost,
            child: Text(
              'Share',
              style: GoogleFonts.urbanist(
                color: _isLoading || _isUploadingImage 
                    ? Colors.grey 
                    : ThemeColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Image Upload Section
            _buildImageSection(),
            
            const SizedBox(height: 24),
            
            // Caption/Description
            _buildDescriptionSection(),
            
            const SizedBox(height: 20),
            
            // Hashtags Section
            _buildHashtagsSection(),
            
            const SizedBox(height: 20),
            
            // Tag Association Section
            _buildTaggingSection(),
            
            const SizedBox(height: 32),
            
            // Submit Button
            _buildSubmitButton(),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📸 Add Photo',
          style: GoogleFonts.urbanist(
            color: ThemeColors.text(context),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: ThemeColors.surface(context),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: ThemeColors.cardBorder(context),
                width: 1,
              ),
            ),
            child: _selectedImage != null
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(19),
                        child: Image.file(
                          _selectedImage!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Upload progress overlay
                      if (_isUploadingImage)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(19),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(color: Colors.white),
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
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      // Remove button
                      Positioned(
                        top: 12,
                        left: 12,
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
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: ThemeColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 48,
                          color: ThemeColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tap to add a photo',
                        style: GoogleFonts.urbanist(
                          color: ThemeColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Recommended: 1080×1080px (1:1)',
                        style: GoogleFonts.urbanist(
                          color: ThemeColors.textSecondary(context),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '✍️ Caption',
          style: GoogleFonts.urbanist(
            color: ThemeColors.text(context),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: ThemeColors.surface(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ThemeColors.cardBorder(context),
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            maxLength: 2200, // Instagram's caption limit
            style: GoogleFonts.urbanist(
              color: ThemeColors.text(context),
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: 'Write a caption... Use #hashtags to categorize',
              hintStyle: GoogleFonts.urbanist(
                color: ThemeColors.textSecondary(context),
                fontSize: 15,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              counterStyle: GoogleFonts.urbanist(
                color: ThemeColors.textSecondary(context),
                fontSize: 12,
              ),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please add a caption';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHashtagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '# Hashtags',
              style: GoogleFonts.urbanist(
                color: ThemeColors.text(context),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (_hashtags.isNotEmpty)
              Text(
                '${_hashtags.length} tags',
                style: GoogleFonts.urbanist(
                  color: ThemeColors.textSecondary(context),
                  fontSize: 14,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Manual hashtag input
        Container(
          decoration: BoxDecoration(
            color: ThemeColors.surface(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ThemeColors.cardBorder(context),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _hashtagController,
                  style: GoogleFonts.urbanist(
                    color: ThemeColors.text(context),
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Add a hashtag...',
                    hintStyle: GoogleFonts.urbanist(
                      color: ThemeColors.textSecondary(context),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    prefixText: '# ',
                    prefixStyle: GoogleFonts.urbanist(
                      color: ThemeColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onSubmitted: (_) => _addHashtag(),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle, color: ThemeColors.primary),
                onPressed: _addHashtag,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Hashtag chips
        if (_hashtags.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _hashtags.map((tag) => Chip(
              label: Text(
                '#$tag',
                style: GoogleFonts.urbanist(
                  color: ThemeColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: ThemeColors.primary.withOpacity(0.1),
              deleteIcon: Icon(
                Icons.close,
                size: 18,
                color: ThemeColors.primary,
              ),
              onDeleted: () => _removeHashtag(tag),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: BorderSide.none,
            )).toList(),
          )
        else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeColors.surface(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ThemeColors.cardBorder(context),
                style: BorderStyle.solid,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: ThemeColors.textSecondary(context),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Type #hashtags in your caption or add them manually',
                    style: GoogleFonts.urbanist(
                      color: ThemeColors.textSecondary(context),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTaggingSection() {
    if (_isLoadingOptions) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🏷️ Tag (Optional)',
          style: GoogleFonts.urbanist(
            color: ThemeColors.text(context),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Associate this post with a club or house',
          style: GoogleFonts.urbanist(
            color: ThemeColors.textSecondary(context),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        
        Row(
          children: [
            // Club dropdown
            if (_clubs.isNotEmpty)
              Expanded(
                child: _buildDropdown(
                  label: 'Club',
                  value: _selectedClubId,
                  items: _clubs,
                  icon: Icons.groups,
                  onChanged: (value) {
                    setState(() {
                      _selectedClubId = value;
                      if (value != null) _selectedHouseId = null;
                    });
                  },
                ),
              ),
            
            if (_clubs.isNotEmpty && _houses.isNotEmpty)
              const SizedBox(width: 12),
            
            // House dropdown
            if (_houses.isNotEmpty)
              Expanded(
                child: _buildDropdown(
                  label: 'House',
                  value: _selectedHouseId,
                  items: _houses,
                  icon: Icons.home,
                  onChanged: (value) {
                    setState(() {
                      _selectedHouseId = value;
                      if (value != null) _selectedClubId = null;
                    });
                  },
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<Map<String, dynamic>> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.surface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeColors.cardBorder(context),
          width: 1,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.urbanist(
            color: ThemeColors.textSecondary(context),
            fontSize: 14,
          ),
          prefixIcon: Icon(icon, color: ThemeColors.icon(context), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        style: GoogleFonts.urbanist(
          color: ThemeColors.text(context),
          fontSize: 14,
        ),
        dropdownColor: ThemeColors.surface(context),
        items: [
          DropdownMenuItem<String>(
            value: null,
            child: Text(
              'None',
              style: GoogleFonts.urbanist(
                color: ThemeColors.textSecondary(context),
              ),
            ),
          ),
          ...items.map((item) => DropdownMenuItem<String>(
            value: item['id'],
            child: Text(
              item['name'],
              style: GoogleFonts.urbanist(
                color: ThemeColors.text(context),
              ),
            ),
          )),
        ],
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading || _isUploadingImage ? null : _submitPost,
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          disabledBackgroundColor: Colors.grey[300],
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
                  const Icon(Icons.send_rounded, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Share Post',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
