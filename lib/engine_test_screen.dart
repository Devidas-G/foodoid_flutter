import 'package:flutter/material.dart';
import 'core/engine/models/node_model.dart';
import 'core/engine/renderer/dynamic_renderer.dart';
import 'core/engine/actions/action_registry.dart';

class EngineTestScreen extends StatelessWidget {
  const EngineTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ActionRegistry.init(context);

    final json = {
      "type": "column",
      "children": [
        {
          "type": "text",
          "value": "Welcome to Runtime Engine 🚀"
        },
        {
          "type": "button",
          "label": "Show Snackbar",
          "action": {
            "type": "show_snackbar",
            "message": "Engine Working!"
          }
        },
        {
          "type": "button",
          "label": "Go To Second Screen",
          "action": {
            "type": "navigate",
            "route": "/second"
          }
        }
      ]
    };

    final node = NodeModel.fromJson(json);

    return Scaffold(
      appBar: AppBar(title: const Text("Engine Test")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DynamicRenderer(node: node),
      ),
    );
  }
}