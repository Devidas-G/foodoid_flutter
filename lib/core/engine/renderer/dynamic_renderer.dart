import 'package:flutter/material.dart';
import '../models/node_model.dart';
import 'widget_registry.dart';

class DynamicRenderer extends StatelessWidget {
  final NodeModel node;

  const DynamicRenderer({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    return WidgetRegistry.build(node);
  }
}