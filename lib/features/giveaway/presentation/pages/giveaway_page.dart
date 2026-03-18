import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodoid/features/giveaway/presentation/bloc/giveaway_bloc.dart';
import 'package:foodoid/features/giveaway/presentation/widgets/custom_text_form_field.dart';
import 'package:foodoid/features/giveaway/presentation/widgets/date_time_picker.dart';
import 'package:foodoid/features/giveaway/presentation/widgets/food_type_dropdown.dart';
import '../../domain/entities/user_location_entity.dart';
import '../widgets/location_section.dart';
import '../widgets/submit_button.dart';

class GiveawayPage extends StatefulWidget {
  const GiveawayPage({super.key});

  @override
  State<GiveawayPage> createState() => _GiveawayPageState();
}

class _GiveawayPageState extends State<GiveawayPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  DateTime? _startTime;
  DateTime? _endTime;
  String? _foodType;

  // This is the location that will be used for submission.
  UserLocationEntity? _selectedLocation;
  List<double>? _coordinates; // [longitude, latitude]

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<GiveawayBloc>().add(const InitializeMapAndLocationEvent());
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Add Giveaway'),
      ),
      body: BlocListener<GiveawayBloc, GiveawayState>(
        listener: (context, state) {
          if (state is LocationLoaded) {
            setState(() {
              _selectedLocation = state.location;
              _coordinates = [
                state.location.longitude,
                state.location.latitude,
              ];
            });
          }
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SizedBox(height: 5),
                    CustomTextFormField(
                      controller: _titleController,
                      labelText: 'Title',
                      hintText: 'E.g. "Free Food Giveaway at XYZ Cafe"',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: _addressController,
                      labelText: 'Address',
                      hintText: 'E.g. "123 Main St, City, State"',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    FoodTypeDropdown(
                      onChanged: (newValue) {
                        setState(() {
                          _foodType = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a food type';
                        }
                        return null;
                      },
                      initialValue: _foodType,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: _quantityController,
                      labelText: 'Quantity Estimate',
                      hintText: 'E.g. "50"',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a quantity estimate';
                        }
                        final int? quantity = int.tryParse(value);
                        if (quantity == null || quantity <= 0) {
                          return 'Please enter a valid positive number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DateTimePicker(
                      selectedDateTime: _startTime,
                      label: 'Start Time',
                      onPressed: () async {
                        if (!mounted) return;
                        final dialogContext = context;

                        // ignore: use_build_context_synchronously
                        final DateTime? date = await showDatePicker(
                          context: dialogContext,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          if (!mounted) return;

                          // ignore: use_build_context_synchronously
                          final TimeOfDay? time = await showTimePicker(
                            context: dialogContext,
                            initialTime: TimeOfDay.now(),
                          );
                          if (!mounted) return;

                          if (time != null) {
                            setState(() {
                              _startTime = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        }
                      },
                    ),

                    const SizedBox(height: 16),
                    DateTimePicker(
                      selectedDateTime: _endTime,
                      label: 'End Time',
                      onPressed: () async {
                        if (!mounted) return;
                        final dialogContext = context;

                        // ignore: use_build_context_synchronously
                        final DateTime? date = await showDatePicker(
                          context: dialogContext,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          if (!mounted) return;

                          // ignore: use_build_context_synchronously
                          final TimeOfDay? time = await showTimePicker(
                            context: dialogContext,
                            initialTime: TimeOfDay.now(),
                          );
                          if (!mounted) return;

                          if (time != null) {
                            setState(() {
                              _endTime = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    LocationSection(),

                    SizedBox(height: 70),
                  ],
                ),
              ),
            ),
            SubmitButton(
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    _startTime != null &&
                    _endTime != null &&
                    _selectedLocation != null &&
                    _coordinates != null) {
                  // TODO: Submit the form data
                  final Map<String, dynamic> formData = {
                    'title': _titleController.text,
                    'location': {'type': 'Point', 'coordinates': _coordinates},
                    'startTime': _startTime!.toUtc().toIso8601String(),
                    'endTime': _endTime!.toUtc().toIso8601String(),
                    'foodType': _foodType,
                    'address': _addressController.text,
                    'quantityEstimate': int.parse(_quantityController.text),
                  };
                  // For example, print or send to API
                  print(formData);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Form submitted')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
