import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ptgua_flutter/data/model/pokemon_details_model.dart';

class MyPokemonBloc extends Bloc<AddPokemonRequest, ListPokemonState> {
  MyPokemonBloc() : super(PokemonInitial());

  @override
  Stream<ListPokemonState> mapEventToState(AddPokemonRequest event) async* {
    try {
      // final LocalStorage storage = LocalStorage('catched_pokemon');
      // final json = event.pokemonDetails.map((item) {
      //   return item.toJSONEncodable();
      // }).toList();
      // storage.setItem('todos', json);
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
