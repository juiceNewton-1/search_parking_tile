import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_app/bloc/events.dart';
import 'package:parking_app/bloc/state.dart';
import 'package:parking_app/models/tile.dart';
import 'package:parking_app/utils/tile_calculator.dart';
import 'package:http/http.dart' as http;

class SearchBloc extends Bloc<AppEvent, AppState> {
  SearchBloc() : super(IntialState()) {
    on<SearchEvent>(_onSearchEvent);
    on<RestartEvent>(_onRestartEvent);
  }

  void _onSearchEvent(SearchEvent searchEvent, Emitter<AppState> emit) async {
    emit(LoadingState());
    try {
      final tile = _calculateTile(
        double.parse(searchEvent.latitude),
        double.parse(searchEvent.longitude),
        int.parse(searchEvent.zoom),
      );
      final tileUrl = _getParksTileUrl(tile.x, tile.y, tile.z);

      final urlResponse = await http
          .get(Uri.parse(tileUrl))
          .timeout(const Duration(seconds: 10));

      if (urlResponse.statusCode == 200) {
        emit(SearchCompletedState(tile: tile, tileUrl: tileUrl));
      } else {
        emit(
          NotFoundState(
            latitude: searchEvent.latitude,
            longitude: searchEvent.longitude,
            zoom: searchEvent.zoom,
          ),
        );
      }
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
