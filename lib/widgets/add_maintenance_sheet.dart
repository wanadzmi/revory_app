import 'package:flutter/material.dart';
import 'package:revory/controllers/maintenance_form_controller.dart';
import 'package:revory/models/vehicle.dart';

class AddMaintenance extends StatefulWidget {
  const AddMaintenance({
    super.key,
    required this.mileage,
    required this.vehicles,
    required this.selectedVehicleId,
  });
  final int mileage;
  final List<Vehicle> vehicles;
  final String selectedVehicleId;
  @override
  State<AddMaintenance> createState() => _AddMaintenanceState();
}

class _AddMaintenanceState extends State<AddMaintenance> {
  final form = MaintenanceFormController();
  final service = TextEditingController();
  final workshop = TextEditingController();
  final cost = TextEditingController();
  late final odometer = TextEditingController(text: widget.mileage.toString());
  late String vehicleId = widget.selectedVehicleId;
  String? receiptName;
  @override
  void dispose() {
    service.dispose();
    workshop.dispose();
    cost.dispose();
    odometer.dispose();
    super.dispose();
  }

  void save() {
    final record = form.create(
      service: service.text,
      workshop: workshop.text,
      mileage: odometer.text,
      fallbackMileage: widget.mileage,
      cost: cost.text,
      vehicleId: vehicleId,
      receiptName: receiptName,
    );
    if (record != null) Navigator.pop(context, record);
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      20,
      0,
      20,
      MediaQuery.of(context).viewInsets.bottom + 28,
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add maintenance',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text('Record only what you need to remember.'),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            initialValue: vehicleId,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Vehicle'),
            items: widget.vehicles
                .map(
                  (vehicle) => DropdownMenuItem(
                    value: vehicle.id,
                    child: Text('${vehicle.name} · ${vehicle.registration}'),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() {
              vehicleId = value!;
              odometer.text = form
                  .mileageFor(widget.vehicles, vehicleId)
                  .toString();
            }),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: service,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Service or part',
              hintText: 'e.g. Engine oil & filter',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: odometer,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Mileage',
                    suffixText: 'km',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: cost,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Total cost',
                    prefixText: 'RM ',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: workshop,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Workshop (optional)'),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: pickReceipt,
            borderRadius: BorderRadius.circular(14),
            child: Ink(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(
                    receiptName != null
                        ? Icons.check_circle
                        : Icons.add_a_photo_outlined,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      receiptName ?? 'Attach receipt',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Text('Image or PDF'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: !form.canSave(service.text) ? null : save,
              child: const Text('Save maintenance'),
            ),
          ),
        ],
      ),
    ),
  );

  Future<void> pickReceipt() async {
    final receipt = await form.pickReceipt();
    if (receipt != null && mounted) setState(() => receiptName = receipt);
  }
}
