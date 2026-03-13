import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting
import 'package:dartz/dartz.dart' hide State;

import 'package:foodoid/core/domain/usecase.dart';
import 'package:foodoid/dependency_injection.dart';
import 'package:foodoid/features/home/domain/usecases/get_current_location.dart';
import 'package:foodoid/core/utils/typedef.dart';

import 'package:foodoid/features/home/domain/entities/user_location_entity.dart';
import 'package:foodoid/features/home/presentation/widgets/map_widget.dart';

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

  static const _defaultLocation = UserLocationEntity(
    latitude: 19.0760,
    longitude: 72.8777,
  );

  late final GetCurrentLocation _getCurrentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation = sl<GetCurrentLocation>();
    // TODO: Fetch current location from device and set _selectedLocation / _coordinates
    // For example, using geolocator package:
    // _setCurrentLocation(await _getCurrentLocation());
  }

  void _setCurrentLocation(UserLocationEntity location) {
    setState(() {
      _selectedLocation = location;
      _coordinates = [location.longitude, location.latitude];
    });
  }

  void _setCustomLocation(UserLocationEntity location) {
    setState(() {
      _selectedLocation = location;
      _coordinates = [location.longitude, location.latitude];
    });
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'E.g. "Free Food Giveaway at XYZ Cafe"',
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      hintText: 'E.g. "123 Main St, City, State"',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _foodType,
                    decoration: const InputDecoration(labelText: 'Food Type'),
                    items: ['veg', 'non-veg', 'both'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
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
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity Estimate',
                      hintText: 'E.g. "50"',
                    ),
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _startTime == null
                              ? 'Start Time: Not selected'
                              : 'Start Time: ${DateFormat('yyyy-MM-dd HH:mm').format(_startTime!)}',
                        ),
                      ),
                      ElevatedButton(
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
                        child: const Text('Select Start Time'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _endTime == null
                              ? 'End Time: Not selected'
                              : 'End Time: ${DateFormat('yyyy-MM-dd HH:mm').format(_endTime!)}',
                        ),
                      ),
                      ElevatedButton(
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
                        child: const Text('Select End Time'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Location',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 220,
                    child: MapWidget(
                      userLocation: _selectedLocation,
                      defaultLocation: _defaultLocation,
                      onMapTap: (point) {
                        _setCustomLocation(
                          UserLocationEntity(
                            latitude: point.latitude,
                            longitude: point.longitude,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _selectedLocation == null
                              ? 'Tap the map to choose a location, or use current location.'
                              : 'Selected: ${_selectedLocation!.latitude.toStringAsFixed(5)}, ${_selectedLocation!.longitude.toStringAsFixed(5)}',
                        ),
                      ),
                      IconButton(
                        style: IconButton.styleFrom(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: ()async {
                          try {
                          final result = await _getCurrentLocation(NoParams());
                          result.fold(
                            (failure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to get location: ${failure.message}',
                                  ),
                                ),
                              );
                            },
                            (location) {
                              _setCurrentLocation(location);
                            },
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Error getting location'),
                            ),
                          );
                        }
                        },
                        icon: Icon(Icons.my_location),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 70),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(double.infinity, 50), // Takes full width
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _startTime != null &&
                      _endTime != null &&
                      _selectedLocation != null &&
                      _coordinates != null) {
                    // TODO: Submit the form data
                    final Map<String, dynamic> formData = {
                      'title': _titleController.text,
                      'location': {
                        'type': 'Point',
                        'coordinates': _coordinates,
                      },
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
                child: const Text('Submit'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}
