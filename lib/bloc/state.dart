import 'package:parking_app/models/tile.dart';

abstract class AppState {}

class IntialState implements AppState {}

class SearchCompletedState implements AppState {
  final Tile tile;
  final String tileUrl;

  SearchCompletedState({
    required this.tile,
    required this.tileUrl,
  });
}

class LoadingState implements AppState {}

class NotFoundState implements AppState {
  final String latitude;
  final String longitude;
  final String zoom;

  NotFoundState({
    required this.latitude,
    required this.longitude,
    required this.zoom,
  });
}

class ErrorState implements AppState {
  final String errorMessage;

  const ErrorState({required this.errorMessage});
}
