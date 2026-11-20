import 'package:flutter/material.dart';
import 'renderer/widget_registry.dart';
import 'renderer/dynamic_renderer.dart';
import 'actions/action_registry.dart';

class EngineInitializer {
  static void init() {
    WidgetRegistry.register('column', (node) {
      return Column(
        children: node.children
            .map((child) => DynamicRenderer(node: child))
            .toList(),
      );
    });

    WidgetRegistry.register('text', (node) {
      return Text(node.props['value'] ?? '');
    });

    WidgetRegistry.register('button', (node) {
      return ElevatedButton(
        onPressed: () =>
            ActionRegistry.handle(node.props['action']),
        child: Text(node.props['label'] ?? ''),
      );
    });
  }
}