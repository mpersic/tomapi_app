// artikli_cubit.dart
import 'package:tomsoft_app/src/data/data.dart';

sealed class ArtikliState {}

class ArtikliLoading extends ArtikliState {}

class ArtikliLoaded extends ArtikliState {
  ArtikliLoaded(this.items);
  final List<Artikl> items;
}

class ArtikliError extends ArtikliState {
  ArtikliError(this.error);
  final String error;
}
