import 'package:flutter/material.dart';
import '../models/node_model.dart';

/// A central registry responsible for mapping a string `type`
/// to a concrete Flutter `Widget` builder.
///
/// This registry enables dynamic UI rendering by allowing widgets
/// to be registered at runtime and instantiated based on a
/// `NodeModel` configuration.
///
/// ## How It Works
///
/// 1. Each widget type is registered using a string key.
/// 2. The key maps to a `WidgetBuilderFn`.
/// 3. When building UI, the registry looks up the builder
///    using `node.type`.
/// 4. If found, it builds the widget.
/// 5. If not found, it returns a fallback widget.
///
/// This pattern allows:
/// - Dynamic UI composition
/// - Pluggable widget systems
/// - Server-driven UI architectures
/// - Feature-based modular rendering
///
/// Example usage:
///
/// ```dart
/// WidgetRegistry.register('text', (node) {
///   return Text(node.props['value'] ?? '');
/// });
///
/// final widget = WidgetRegistry.build(node);
/// ```
///
/// This is commonly used in:
/// - JSON-driven UI engines
/// - RFW hybrid systems
/// - Low-code platforms
/// - Plugin-based UI architectures
///
typedef WidgetBuilderFn = Widget Function(NodeModel node);

class WidgetRegistry {
  /// Internal map that stores widget builders
  /// keyed by their string type.
  static final Map<String, WidgetBuilderFn> _registry = {};

  /// Registers a widget builder under a specific type key.
  ///
  /// If the type already exists, it will be overwritten.
  ///
  /// Example:
  /// ```dart
  /// WidgetRegistry.register('container', (node) {
  ///   return Container();
  /// });
  /// ```
  static void register(String type, WidgetBuilderFn builder) {
    _registry[type] = builder;
  }

  /// Builds a widget from the given [NodeModel].
  ///
  /// The method looks up the builder using `node.type`.
  ///
  /// Returns:
  /// - The constructed widget if the type exists.
  /// - A fallback `SizedBox` if no builder is found.
  ///
  /// This ensures the UI does not crash when encountering
  /// an unregistered widget type.
  static Widget build(NodeModel node) {
    final builder = _registry[node.type];

    if (builder == null) {
      // Fallback widget to prevent runtime crashes
      return const SizedBox();
    }

    return builder(node);
  }
}