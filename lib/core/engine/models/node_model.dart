class NodeModel {
  final String type;
  final Map<String, dynamic> props;
  final List<NodeModel> children;

  NodeModel({
    required this.type,
    required this.props,
    required this.children,
  });

  factory NodeModel.fromJson(Map<String, dynamic> json) {
    return NodeModel(
      type: json['type'],
      props: json,
      children: (json['children'] as List?)
              ?.map((e) => NodeModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}