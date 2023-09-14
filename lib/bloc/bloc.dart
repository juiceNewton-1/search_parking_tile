import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_app/bloc/events.dart';
import 'package:parking_app/bloc/state.dart';
import 'package:parking_app/models/tile.dart';
import 'package:parking_app/utils/tile_calculator.dart';

class SearchBloc extends Bloc<AppEvent, AppState> {
  SearchBloc() : super(IntialState()) {
    on<SearchEvent>(_onSearchEvent);
    on<RestartEvent>(_onRestartEvent);
  }

  void _onSearchEvent(SearchEvent searchEvent, Emitter<AppState> emit) {
    emit(LoadingState());
    try {
      final tile = _calculateTile(
        double.parse(searchEvent.latitude),
        double.parse(searchEvent.longitude),
        int.parse(searchEvent.zoom),
      );
      final tileUrl = _getParksTileUrl(tile.x, tile.y, tile.z);
      emit(SearchCompletedState(tile: tile, tileUrl: tileUrl));
    } catch (e) {
      emit(ErrorState(errorMessage: e.toString()));
    }
  }

  void _onRestartEvent(RestartEvent restartEvent, Emitter<AppState> emit) =>
      emit(IntialState());

  Tile _calculateTile(double latitude, double longitude, int zoom) =>
      TileCalculator().calculateTile(latitude, longitude, zoom);

  String _getParksTileUrl(int x, int y, int z) =>
      'https://core-carparks-renderer-lots.maps.yandex.net/maps-rdr-carparks/tiles?l=carparks&x=$x&y=$y&z=$z&scale=1&lang=ru_RU';
}
