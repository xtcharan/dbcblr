import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/schedule.dart';
import '../../../shared/utils/theme_colors.dart';

/// Dialog for creating or editing schedule items
class CreateScheduleDialog extends StatefulWidget {
  final DateTime initialDate;
  final Schedule? scheduleToEdit;
  final bool isAdmin;
  final Function(String title, String? description, DateTime date, String startTime, String? endTime, String? location, String scheduleType) onSave;

  const CreateScheduleDialog({
    super.key,
    required this.initialDate,
    this.scheduleToEdit,
    this.isAdmin = false,
    required this.onSave,
  });

  @override
  State<CreateScheduleDialog> createState() => _CreateScheduleDialogState();
}

class _CreateScheduleDialogState extends State<CreateScheduleDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late DateTime _selectedDate;
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay? _endTime;
  String _scheduleType = 'personal';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final schedule = widget.scheduleToEdit;
    
    _titleController = TextEditingController(text: schedule?.title ?? '');
    _descriptionController = TextEditingController(text: schedule?.description ?? '');
    _locationController = TextEditingController(text: schedule?.location ?? '');
    _selectedDate = schedule?.scheduleDate ?? widget.initialDate;
    _scheduleType = schedule?.scheduleType ?? 'personal';
    
    // Parse start time
    if (schedule != null) {
      final startParts = schedule.startTime.split(':');
      if (startParts.length >= 2) {
        _startTime = TimeOfDay(
          hour: int.tryParse(startParts[0]) ?? 9,
          minute: int.tryParse(startParts[1]) ?? 0,
        );
      }
      
      // Parse end time
      if (schedule.endTime != null) {
        final endParts = schedule.endTime!.split(':');
        if (endParts.length >= 2) {
          _endTime = TimeOfDay(
            hour: int.tryParse(endParts[0]) ?? 10,
            minute: int.tryParse(endParts[1]) ?? 0,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.scheduleToEdit != null;
    
    return Dialog(
      backgroundColor: ThemeColors.surface(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'Edit Schedule' : 'Add Schedule',
                      style: GoogleFonts.urbanist(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.text(context),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: ThemeColors.textSecondary(context)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Title field
                _buildTextField(
                  controller: _titleController,
                  label: 'Title *',
                  hint: 'e.g., UX Studio Class',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Date picker
                _buildDatePicker(context),
                
                const SizedBox(height: 16),
                
                // Time pickers row
                Row(
                  children: [
                    Expanded(child: _buildTimePicker(context, true)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTimePicker(context, false)),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Location field
                _buildTextField(
                  controller: _locationController,
                  label: 'Location',
                  hint: 'e.g., Room 101',
                ),
                
                const SizedBox(height: 16),
                
                // Description field
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  hint: 'Optional notes...',
                  maxLines: 2,
                ),
                
                // Schedule type (admin only)
                if (widget.isAdmin && widget.scheduleToEdit == null) ...[
                  const SizedBox(height: 16),
                  _buildScheduleTypeSelector(context),
                ],
                
                const SizedBox(height: 24),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: ThemeColors.cardBorder(context)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: ThemeColors.textSecondary(context),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeColors.primary,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(
                                isEditing ? 'Save Changes' : 'Add Schedule',
                                style: GoogleFonts.urbanist(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ThemeColors.text(context),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: GoogleFonts.urbanist(
            color: ThemeColors.text(context),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.urbanist(
              color: ThemeColors.textSecondary(context),
            ),
            filled: true,
            fillColor: ThemeColors.inputBackground(context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: ThemeColors.inputBorder(context)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: ThemeColors.inputBorder(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: ThemeColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ThemeColors.text(context),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: ThemeColors.inputBackground(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ThemeColors.inputBorder(context)),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 18, color: ThemeColors.primary),
                const SizedBox(width: 12),
                Text(
                  _formatDate(_selectedDate),
                  style: GoogleFonts.urbanist(
                    fontSize: 15,
                    color: ThemeColors.text(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker(BuildContext context, bool isStart) {
    final time = isStart ? _startTime : _endTime;
    final label = isStart ? 'Start Time *' : 'End Time';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ThemeColors.text(context),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectTime(isStart),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: ThemeColors.inputBackground(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ThemeColors.inputBorder(context)),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, size: 18, color: ThemeColors.primary),
                const SizedBox(width: 8),
                Text(
                  time != null ? _formatTime(time) : 'Optional',
                  style: GoogleFonts.urbanist(
                    fontSize: 15,
                    color: time != null 
                        ? ThemeColors.text(context) 
                        : ThemeColors.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleTypeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Schedule Type',
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ThemeColors.text(context),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTypeOption(
                context,
                'personal',
                'Personal',
                Icons.person,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTypeOption(
                context,
                'official',
                'Official',
                Icons.school,
                ThemeColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeOption(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    final isSelected = _scheduleType == value;
    
    return GestureDetector(
      onTap: () => setState(() => _scheduleType = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : ThemeColors.inputBackground(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : ThemeColors.inputBorder(context),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isSelected ? color : ThemeColors.textSecondary(context)),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? color : ThemeColors.text(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ThemeColors.primary,
              onPrimary: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(bool isStart) async {
    final initialTime = isStart 
        ? _startTime 
        : (_endTime ?? TimeOfDay(hour: _startTime.hour + 1, minute: _startTime.minute));
    
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ThemeColors.primary,
              onPrimary: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSubmitting = true);
    
    final startTimeStr = '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}';
    final endTimeStr = _endTime != null 
        ? '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}'
        : null;
    
    widget.onSave(
      _titleController.text.trim(),
      _descriptionController.text.trim().isNotEmpty ? _descriptionController.text.trim() : null,
      _selectedDate,
      startTimeStr,
      endTimeStr,
      _locationController.text.trim().isNotEmpty ? _locationController.text.trim() : null,
      _scheduleType,
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:${time.minute.toString().padLeft(2, '0')} $period';
  }
}
