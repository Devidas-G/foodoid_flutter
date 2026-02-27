import 'package:latlong2/latlong.dart';
import '../../../../core/utils/typedef.dart';

abstract class HomeRepository {
  ResultFuture<LatLng> fetchCurrentLocation();
}
