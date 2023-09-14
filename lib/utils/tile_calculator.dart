import 'dart:math';

import 'package:parking_app/models/tile.dart';

class TileCalculator {
  static const double e = 0.0818191908426;

  Tile calculateTile(double latitude, double longitude, int zoom) {
    final p = _calculateP(zoom);
    final B = _calculateB(latitude);
    final f = _calculateF(B);
    final O = _calculateO(B, f);
    final x_p = _calculateXp(longitude, p);
    final y_p = _calculateYp(O, p);
    final x = _calculateX(x_p);
    final y = _calculateY(y_p);

    return Tile(x: x, y: y, z: zoom);
  }

  double _calculateP(int zoom) {
    return pow(2, zoom + 8) / 2;
  }

  double _calculateB(double latitude) {
    return pi * latitude / 180;
  }

  double _calculateF(double B) {
    return (1 - (e * sin(B))) / (1 + (e * sin(B)));
  }

  double _calculateO(double B, double f) {
    return tan(pi / 4 + B / 2) * pow(f, e / 2);
  }

  double _calculateXp(double longitude, double p) {
    return p * (1 + longitude / 180);
  }

  double _calculateYp(double O, double p) {
    return p * (1 - log(O) / pi);
  }

  int _calculateX(double x_p) {
    return (x_p / 256).floor();
  }

  int _calculateY(double y_p) {
    return (y_p / 256).floor();
  }
}
