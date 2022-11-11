import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptgua_flutter/data/model/pokemon_details_model.dart';

class MyPokemonBloc extends Bloc<AddPokemonRequest, ListPokemonState> {
  MyPokemonBloc() : super(PokemonInitial());

  @override
  Stream<ListPokemonState> mapEventToState(AddPokemonRequest event) async* {
    try {
      yield AddPokemonSuccess(
        pokemonList: event.pokemonDetails,
      );
    } catch (e) {
      yield AddPokemonFailed(error: e);
    }
  }
}

//POKEMON EVENT
abstract class AddPokemonEvent {}

class AddPokemonInitial extends AddPokemonEvent {
  final List<dynamic> initialPokemon = [];
}

class AddPokemonRequest extends AddPokemonEvent {
  final List<PokemonDetails> pokemonDetails;

  AddPokemonRequest({required this.pokemonDetails});
}

//POKEMON STATE
abstract class ListPokemonState {}

class PokemonInitial extends ListPokemonState {
  final List initialPokemon = [];
}

class AddPokemonSuccess extends ListPokemonState {
  final List<PokemonDetails> pokemonList;

  AddPokemonSuccess({required this.pokemonList});
}

class AddPokemonFailed extends ListPokemonState {
  final Object error;

  AddPokemonFailed({required this.error});
}
