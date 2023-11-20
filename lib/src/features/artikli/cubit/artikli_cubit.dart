// artikli_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tomsoft_app/src/api/api.dart';
import 'package:tomsoft_app/src/features/artikli/cubit/artikli_state.dart';
import 'package:tomsoft_app/src/utils/connectivity_service.dart';

@Injectable()
class ArtikliCubit extends Cubit<ArtikliState> {
  ArtikliCubit({required this.api}) : super(ArtikliLoading());

  final Api api;

  Future<void> loadItems({String? searchText}) async {
    if (searchText?.trim() == '' && searchText != '') {
      emit(ArtikliError('Please enter something to search.'));
      return;
    }
    if (!await ConnectivityService.isNetworkConnected()) {
      emit(ArtikliError('No network connection'));
      return;
    }
    emit(ArtikliLoading());
    try {
      var items = await Api().getArtikls(searchText: searchText);
      emit(ArtikliLoaded(items));
    } catch (e) {
      emit(ArtikliError(e.toString()));
    }
  }

  void toggleErrorState() {
    emit(ArtikliLoaded([]));
  }
}
