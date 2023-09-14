import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_app/bloc/bloc.dart';
import 'package:parking_app/bloc/events.dart';
import 'package:parking_app/bloc/state.dart';
import 'package:parking_app/models/tile.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _zoomController = TextEditingController();

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    _zoomController.dispose();
    super.dispose();
  }

  void _clearAllTextControllers() {
    setState(() {
      _latitudeController.clear();
      _longitudeController.clear();
      _zoomController.clear();
    });
  }

  final _formKey = GlobalKey<FormState>();

  String? _latitudeValidator(String? query) {
    final latitudeRegExp =RegExp(r'^-?((\d|[1-8]\d|90)(\.\d+)?)$');
    if (query == null || !latitudeRegExp.hasMatch(query.trim())) {
      return 'Введите корректное значение широты';
    }
    return null;
  }

  String? _longitudeValidator(String? query) {
    final longitudeRegExp =
        RegExp(r'^-?((\d|[1-9]\d|1[0-7]\d|180)(\.\d+)?)$');

    if (query == null || !longitudeRegExp.hasMatch(query.trim())) {
      return 'Введите корректно значение долготы';
    }

    return null;
  }

  String? _zoomValidator(String? query) {
    final zoomRegExp = RegExp(r'^(1[4-9]|20)$');
    if (query == null || !zoomRegExp.hasMatch(query.trim())) {
      return 'Значение приближения должно быть в диапазоне от 14 до 20';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocBuilder(
            bloc: context.read<SearchBloc>(),
            builder: (context, state) {
              if (state is LoadingState) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is SearchCompletedState) {
                return _SearchCompletedColumn(
                    tile: state.tile,
                    tileUrl: state.tileUrl,
                    onPressed: () {
                      _clearAllTextControllers();
                      context.read<SearchBloc>().add(RestartEvent());
                    });
              }
              if (state is ErrorState) {
                return _ErrorColumn(
                    errorMessage: state.errorMessage,
                    onPressed: () {
                      _clearAllTextControllers();
                      context.read<SearchBloc>().add(RestartEvent());
                    });
              }
              if (state is IntialState) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _latitudeController,
                        validator: _latitudeValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(hintText: 'Широта'),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _longitudeController,
                        validator: _longitudeValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(hintText: 'Долгота'),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _zoomController,
                        validator: _zoomValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration:
                            const InputDecoration(hintText: 'Приближение'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<SearchBloc>().add(
                                  SearchEvent(
                                    latitude: _latitudeController.text,
                                    longitude: _longitudeController.text,
                                    zoom: _zoomController.text,
                                  ),
                                );
                          }
                        },
                        child: const Text('Рассчитать'),
                      )
                    ],
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}

class _SearchCompletedColumn extends StatelessWidget {
  final Tile tile;
  final String tileUrl;
  final VoidCallback onPressed;
  const _SearchCompletedColumn({
    required this.tile,
    required this.tileUrl,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Полученные значения плитки: x=${tile.x}, y= ${tile.y}, z=${tile.z}',
        ),
        const SizedBox(height: 20),
        SelectableText('URL плитки: $tileUrl'),
        const SizedBox(height: 20),
        Image.network(tileUrl),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: onPressed,
          child: const Text('Назад'),
        )
      ],
    );
  }
}

class _ErrorColumn extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onPressed;

  const _ErrorColumn({
    required this.errorMessage,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Ошибка: $errorMessage'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onPressed,
          child: const Text('Назад'),
        )
      ],
    );
  }
}
