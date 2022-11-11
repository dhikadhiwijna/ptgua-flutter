import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptgua_flutter/data/model/pokemon_response.dart';
import 'package:ptgua_flutter/data/repository/pokemon_repository.dart';

class PokemonBloc extends Bloc<PokemonPageRequest, PokemonState> {
  final _pokemonRepository = PokemonRepository();
  PokemonBloc() : super(PokemonLoadInitial());

  @override
  Stream<PokemonState> mapEventToState(PokemonPageRequest event) async* {
    try {
      final pokemonResponse =
          await _pokemonRepository.getPokemonPage(event.page);
      yield PokemonLoadSuccess(
          pokemonList: pokemonResponse.pokemonData,
          canLoadNextPage: pokemonResponse.canLoadNextPage);
    } catch (e) {
      yield PokemonLoadFailed(error: e);
    }
  }
}

abstract class PokemonEvent {}

class PokemonPageRequest extends PokemonEvent {
  final int page;

  PokemonPageRequest({required this.page});
}

abstract class PokemonState {}

class PokemonLoadInitial extends PokemonState {}

class PokemonLoadInProgress extends PokemonState {}

class PokemonLoadSuccess extends PokemonState {
  final List<PokemonList> pokemonList;
  final bool canLoadNextPage;

  PokemonLoadSuccess(
      {required this.pokemonList, required this.canLoadNextPage});
}

class PokemonLoadFailed extends PokemonState {
  final Object error;

  PokemonLoadFailed({required this.error});
}
