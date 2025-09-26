import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/models/event.dart';
import '../../../shared/utils/theme_colors.dart';

class CreateEventPage extends StatefulWidget {
  final Event? event; // For editing existing events
  
  const CreateEventPage({
    super.key,
    this.event,
  });

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _imageUrlController = TextEditingController();
  
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(hours: 2));
  TimeOfDay _startTime = TimeOfDay.now();
  late TimeOfDay _endTime;
  
  String _selectedCategory = 'Academic';
  bool _isHouseEvent = false;
  bool _isLoading = false;

  final List<String> _categories = [
    'Academic',
    'Cultural',
    'Sports',
    'Social',
    'Workshop',
    'Seminar',
    'Competition',
    'Festival',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize end time to 2 hours after current time
    final now = TimeOfDay.now();
    final endHour = (now.hour + 2) % 24;
    _endTime = TimeOfDay(hour: endHour, minute: now.minute);
    
    if (widget.event != null) {
      _populateFormWithEvent(widget.event!);
    }
  }

  void _populateFormWithEvent(Event event) {
    _titleController.text = event.title;
    _descriptionController.text = event.description;
    _locationController.text = event.location;
    _imageUrlController.text = event.eventImage ?? '';
    _startDate = event.startDate;
    _endDate = event.endDate;
    _startTime = TimeOfDay.fromDateTime(event.startDate);
    _endTime = TimeOfDay.fromDateTime(event.endDate);
    _selectedCategory = event.category;
    _isHouseEvent = event.isHouseEvent;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ThemeColors.primary,
              onPrimary: Colors.white,
              surface: ThemeColors.surface(context),
              onSurface: ThemeColors.text(context),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // If start date is after end date, update end date
          if (_startDate.isAfter(_endDate)) {
            _endDate = _startDate.add(const Duration(hours: 2));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ThemeColors.primary,
              onPrimary: Colors.white,
              surface: ThemeColors.surface(context),
              onSurface: ThemeColors.text(context),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  DateTime _combineDateTime(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final startDateTime = _combineDateTime(_startDate, _startTime);
      final endDateTime = _combineDateTime(_endDate, _endTime);

      // Validate that end time is after start time
      if (!endDateTime.isAfter(startDateTime)) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('End time must be after start time'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final event = Event(
        id: widget.event?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        startDate: startDateTime,
        endDate: endDateTime,
        location: _locationController.text.trim(),
        category: _selectedCategory,
        isHouseEvent: _isHouseEvent,
        eventImage: _imageUrlController.text.trim().isEmpty 
            ? null 
            : _imageUrlController.text.trim(),
      );

      // Simulate API call
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          
          Navigator.of(context).pop(event);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.event != null 
                    ? 'Event updated successfully!' 
                    : 'Event created successfully!'
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.event != null;
    
    return Scaffold(
      backgroundColor: ThemeColors.background(context),
      appBar: AppBar(
        backgroundColor: ThemeColors.surface(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: ThemeColors.text(context),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          isEditing ? 'Edit Event' : 'Create Event',
          style: GoogleFonts.urbanist(
            color: ThemeColors.text(context),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _submitForm,
            child: Text(
              isEditing ? 'Update' : 'Create',
              style: GoogleFonts.urbanist(
                color: _isLoading ? Colors.grey : ThemeColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Title Field
            _buildSectionTitle('Event Details'),
            const SizedBox(height: 16),
            _buildTextFormField(
              controller: _titleController,
              label: 'Event Title',
              hint: 'Enter event title',
              icon: Icons.event,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter event title';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Description Field
            _buildTextFormField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Enter event description',
              icon: Icons.description,
              maxLines: 4,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter event description';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Location Field
            _buildTextFormField(
              controller: _locationController,
              label: 'Location',
              hint: 'Enter event location',
              icon: Icons.location_on,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter event location';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 24),
            
            // Date & Time Section
            _buildSectionTitle('Date & Time'),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildDateTimeCard(
                    title: 'Start Date',
                    date: _formatDate(_startDate),
                    time: _formatTime(_startTime),
                    onDateTap: () => _selectDate(context, true),
                    onTimeTap: () => _selectTime(context, true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateTimeCard(
                    title: 'End Date',
                    date: _formatDate(_endDate),
                    time: _formatTime(_endTime),
                    onDateTap: () => _selectDate(context, false),
                    onTimeTap: () => _selectTime(context, false),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Category Section
            _buildSectionTitle('Category & Type'),
            const SizedBox(height: 16),
            
            _buildDropdownField(
              label: 'Category',
              value: _selectedCategory,
              items: _categories,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            _buildSwitchCard(
              title: 'House Event',
              subtitle: 'This event is specific to houses',
              value: _isHouseEvent,
              onChanged: (value) {
                setState(() {
                  _isHouseEvent = value;
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // Optional Fields
            _buildSectionTitle('Optional'),
            const SizedBox(height: 16),
            
            _buildTextFormField(
              controller: _imageUrlController,
              label: 'Event Image URL',
              hint: 'Enter image URL (optional)',
              icon: Icons.image,
            ),
            
            const SizedBox(height: 40),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
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
                    : Text(
                        isEditing ? 'Update Event' : 'Create Event',
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.urbanist(
        color: ThemeColors.text(context),
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ThemeColors.cardBorder(context),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: maxLines,
        style: GoogleFonts.urbanist(
          color: ThemeColors.text(context),
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: GoogleFonts.urbanist(
            color: ThemeColors.textSecondary(context),
            fontSize: 14,
          ),
          hintStyle: GoogleFonts.urbanist(
            color: ThemeColors.textSecondary(context),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: ThemeColors.icon(context),
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeCard({
    required String title,
    required String date,
    required String time,
    required VoidCallback onDateTap,
    required VoidCallback onTimeTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ThemeColors.cardBorder(context),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.urbanist(
                color: ThemeColors.textSecondary(context),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: onDateTap,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: ThemeColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: ThemeColors.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      date,
                      style: GoogleFonts.urbanist(
                        color: ThemeColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: onTimeTap,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: ThemeColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: ThemeColors.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: GoogleFonts.urbanist(
                        color: ThemeColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ThemeColors.cardBorder(context),
          width: 1,
        ),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.urbanist(
            color: ThemeColors.textSecondary(context),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.category,
            color: ThemeColors.icon(context),
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: GoogleFonts.urbanist(
          color: ThemeColors.text(context),
          fontSize: 16,
        ),
        dropdownColor: ThemeColors.surface(context),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.urbanist(
                color: ThemeColors.text(context),
                fontSize: 16,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSwitchCard({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ThemeColors.cardBorder(context),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              Icons.home,
              color: ThemeColors.icon(context),
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.urbanist(
                      color: ThemeColors.text(context),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.urbanist(
                      color: ThemeColors.textSecondary(context),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeTrackColor: ThemeColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}