import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../models/department.dart';
import '../../../models/club.dart';

class CreateClubPage extends StatefulWidget {
  final List<Department>? departments;

  const CreateClubPage({
    super.key,
    this.departments,
  });

  @override
  State<CreateClubPage> createState() => _CreateClubPageState();
}

class _CreateClubPageState extends State<CreateClubPage> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  final _nameController = TextEditingController();
  final _taglineController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _logoUrlController = TextEditingController();
  final _primaryColorController = TextEditingController(text: '#4F46E5');
  final _secondaryColorController = TextEditingController(text: '#818CF8');
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();

  String? _selectedDepartmentId;
  bool _isSubmitting = false;
  List<Department> _departments = [];
  bool _isLoadingDepartments = false;

  @override
  void initState() {
    super.initState();
    if (widget.departments != null) {
      _departments = widget.departments!;
    } else {
      _loadDepartments();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _taglineController.dispose();
    _descriptionController.dispose();
    _logoUrlController.dispose();
    _primaryColorController.dispose();
    _secondaryColorController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _loadDepartments() async {
    setState(() => _isLoadingDepartments = true);
    try {
      final data = await _apiService.getDepartments();
      setState(() {
        _departments = data.map((json) => Department.fromJson(json)).toList();
        _isLoadingDepartments = false;
      });
    } catch (e) {
      setState(() => _isLoadingDepartments = false);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await _apiService.createClub(
        departmentId: _selectedDepartmentId,
        name: _nameController.text.trim(),
        tagline: _taglineController.text.trim().isNotEmpty
            ? _taglineController.text.trim()
            : null,
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        logoUrl: _logoUrlController.text.trim().isNotEmpty
            ? _logoUrlController.text.trim()
            : null,
        primaryColor: _primaryColorController.text.trim(),
        secondaryColor: _secondaryColorController.text.trim(),
        email: _emailController.text.trim().isNotEmpty
            ? _emailController.text.trim()
            : null,
        phone: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        website: _websiteController.text.trim().isNotEmpty
            ? _websiteController.text.trim()
            : null,
        socialLinks: {},
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Club created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Club'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_isLoadingDepartments)
              const Center(child: CircularProgressIndicator())
            else if (_departments.isNotEmpty)
              DropdownButtonFormField<String>(
                value: _selectedDepartmentId,
                decoration: const InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(),
                ),
                items: _departments.map((dept) {
                  return DropdownMenuItem(
                    value: dept.id,
                    child: Text('${dept.code} - ${dept.name}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedDepartmentId = value);
                },
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Club Name *',
                hintText: 'e.g., BITBLAZE',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter club name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _taglineController,
              decoration: const InputDecoration(
                labelText: 'Tagline',
                hintText: 'e.g., Innovation Through Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Brief description of the club',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _logoUrlController,
              decoration: const InputDecoration(
                labelText: 'Logo URL',
                hintText: 'https://example.com/logo.png',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _primaryColorController,
                    decoration: InputDecoration(
                      labelText: 'Primary Color',
                      hintText: '#4F46E5',
                      border: const OutlineInputBorder(),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(8),
                        width: 30,
                        decoration: BoxDecoration(
                          color: _parseColor(_primaryColorController.text),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey),
                        ),
                      ),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _secondaryColorController,
                    decoration: InputDecoration(
                      labelText: 'Secondary Color',
                      hintText: '#818CF8',
                      border: const OutlineInputBorder(),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(8),
                        width: 30,
                        decoration: BoxDecoration(
                          color: _parseColor(_secondaryColorController.text),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey),
                        ),
                      ),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'club@college.edu',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                hintText: '+91 1234567890',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _websiteController,
              decoration: const InputDecoration(
                labelText: 'Website',
                hintText: 'https://clubwebsite.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 24),
            const Text(
              '* Required fields',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Create Club',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return Colors.blue;
    }
  }
}
