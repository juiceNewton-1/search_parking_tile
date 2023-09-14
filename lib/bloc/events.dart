abstract class AppEvent {}


class SearchEvent implements AppEvent {
  final String latitude;
  final String longitude;
  final String zoom;

  const SearchEvent({
    required this.latitude,
    required this.longitude,
    required this.zoom,
  });
}

class RestartEvent implements AppEvent {}
