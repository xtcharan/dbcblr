import 'package:flutter/material.dart';
import '../../../services/api_service.dart';

class CreateAwardDialog extends StatefulWidget {
  final String clubId;

  const CreateAwardDialog({
    super.key,
    required this.clubId,
  });

  @override
  State<CreateAwardDialog> createState() => _CreateAwardDialogState();
}

class _CreateAwardDialogState extends State<CreateAwardDialog> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  final _awardNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _positionController = TextEditingController();
  final _prizeAmountController = TextEditingController();
  final _eventNameController = TextEditingController();
  final _certificateUrlController = TextEditingController();

  DateTime? _awardedDate;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _awardNameController.dispose();
    _descriptionController.dispose();
    _positionController.dispose();
    _prizeAmountController.dispose();
    _eventNameController.dispose();
    _certificateUrlController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _awardedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => _awardedDate = picked);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await _apiService.createClubAward(
        clubId: widget.clubId,
        awardName: _awardNameController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        position: _positionController.text.trim().isNotEmpty
            ? _positionController.text.trim()
            : null,
        prizeAmount: _prizeAmountController.text.trim().isNotEmpty
            ? double.tryParse(_prizeAmountController.text.trim())
            : null,
        eventName: _eventNameController.text.trim().isNotEmpty
            ? _eventNameController.text.trim()
            : null,
        awardedDate: _awardedDate,
        certificateUrl: _certificateUrlController.text.trim().isNotEmpty
            ? _certificateUrlController.text.trim()
            : null,
      );

      if (mounted) {
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
    return AlertDialog(
      title: const Text('Add Award'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _awardNameController,
                decoration: const InputDecoration(
                  labelText: 'Award Name *',
                  hintText: 'e.g., Best Innovation Award',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter award name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _positionController,
                decoration: const InputDecoration(
                  labelText: 'Position',
                  hintText: '1st, 2nd, Winner, etc.',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _prizeAmountController,
                decoration: const InputDecoration(
                  labelText: 'Prize Amount (₹)',
                  border: OutlineInputBorder(),
                  prefixText: '₹ ',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _eventNameController,
                decoration: const InputDecoration(
                  labelText: 'Event Name',
                  hintText: 'Name of the competition/event',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Awarded Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _awardedDate != null
                        ? '${_awardedDate!.day}/${_awardedDate!.month}/${_awardedDate!.year}'
                        : 'Select date',
                    style: TextStyle(
                      color: _awardedDate != null ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _certificateUrlController,
                decoration: const InputDecoration(
                  labelText: 'Certificate URL',
                  hintText: 'https://example.com/certificate.pdf',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitForm,
          child: _isSubmitting
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Add Award'),
        ),
      ],
    );
  }
}
