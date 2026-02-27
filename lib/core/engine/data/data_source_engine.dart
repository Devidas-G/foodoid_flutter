class DataSourceEngine {
  Future<dynamic> resolve(Map<String, dynamic> config) async {
    switch (config['type']) {
      case 'api':
        // Call your existing API client here
        return {}; 
      default:
        return null;
    }
  }
}