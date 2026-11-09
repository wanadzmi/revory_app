import 'package:flutter/material.dart';
import 'package:revory/controllers/reminder_form_controller.dart';
import 'package:revory/models/vehicle.dart';
import 'package:revory/utils/formatters.dart';

class ServiceReminderSheet extends StatefulWidget {
  const ServiceReminderSheet({super.key, required this.vehicle});
  final Vehicle vehicle;
  @override
  State<ServiceReminderSheet> createState() => _ServiceReminderSheetState();
}

class _ServiceReminderSheetState extends State<ServiceReminderSheet> {
  final controller = ReminderFormController();
  late final label = TextEditingController(
    text: widget.vehicle.nextServiceLabel,
  );
  late final mileage = TextEditingController(
    text: widget.vehicle.nextServiceMileage?.toString() ?? '',
  );
  DateTime? date;
  @override
  void initState() {
    super.initState();
    date = widget.vehicle.nextServiceDate;
  }

  @override
  void dispose() {
    label.dispose();
    mileage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      20,
      0,
      20,
      MediaQuery.of(context).viewInsets.bottom + 28,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming service',
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        const Text('A date is required. We will notify you one week before.'),
        const SizedBox(height: 20),
        TextField(
          controller: label,
          decoration: const InputDecoration(labelText: 'Service name'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: mileage,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Target mileage (optional)',
            suffixText: 'km',
          ),
        ),
        const SizedBox(height: 12),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.calendar_today_outlined),
          title: Text(date == null ? 'Target date *' : dateText(date!)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 3650)),
              initialDate: date ?? DateTime.now(),
            );
            if (picked != null) setState(() => date = picked);
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: date == null
                ? null
                : () {
                    final valid = controller.apply(
                      widget.vehicle,
                      label: label.text,
                      mileage: mileage.text,
                      date: date,
                    );
                    if (!valid) return;
                    Navigator.pop(context, true);
                  },
            child: const Text('Save reminder'),
          ),
        ),
      ],
    ),
  );
}
