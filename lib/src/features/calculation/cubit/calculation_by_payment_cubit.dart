import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:tomsoft_app/src/api/api.dart';
import 'package:tomsoft_app/src/data/data.dart';
import 'package:tomsoft_app/src/features/calculation/cubit/calculation_by_payment_state.dart';
import 'package:tomsoft_app/src/utils/connectivity_service.dart';

@Injectable()
class CalculationByPaymentCubit extends Cubit<CalculationByPaymentState> {
  CalculationByPaymentCubit({required this.api})
      : super(CalculationByPaymentInitial());
  final DateFormat dateFormat = DateFormat('dd.MM.yyyy');

  final Api api;

  Future<void> loadItems({String? searchText}) async {
    emit(CalculationByPaymentLoading(
      vrstaPlacanjaList: state.vrstaPlacanjaList,
      selectedVrstaPlacanja: state.selectedVrstaPlacanja,
      startDate: state.startDate,
      endDate: state.endDate,
      obracunPlacanjaList: [],
      obracunProizvodaList: [],
    ));
    if (!await ConnectivityService.isNetworkConnected()) {
      emit(CalculationByPaymentError(
        errorMessage: 'No network connection',
        vrstaPlacanjaList: state.vrstaPlacanjaList,
        selectedVrstaPlacanja: state.selectedVrstaPlacanja,
        startDate: state.startDate,
        endDate: state.endDate,
        obracunPlacanjaList: [],
        obracunProizvodaList: [],
      ));
      return;
    }
    try {
      var vrstaPlacanjaList = await api.getSkladista();
      emit(CalculationByPaymentLoaded(
        vrstaPlacanjaList: vrstaPlacanjaList,
        selectedVrstaPlacanja: state.selectedVrstaPlacanja,
        startDate: state.startDate,
        endDate: state.endDate,
        obracunPlacanjaList: [],
        obracunProizvodaList: [],
      ));
    } catch (e) {
      emit(CalculationByPaymentError(
        errorMessage: e.toString(),
        vrstaPlacanjaList: state.vrstaPlacanjaList,
        selectedVrstaPlacanja: state.selectedVrstaPlacanja,
        startDate: state.startDate,
        endDate: state.endDate,
        obracunPlacanjaList: [],
        obracunProizvodaList: [],
      ));
    }
  }

  void toggleErrorState() {
    emit(CalculationByPaymentLoaded(
      vrstaPlacanjaList: state.vrstaPlacanjaList,
      selectedVrstaPlacanja: state.selectedVrstaPlacanja,
      startDate: state.startDate,
      endDate: state.endDate,
      obracunPlacanjaList: [],
      obracunProizvodaList: [],
    ));
  }

  void updateVrstaPlacanjaList(List<Skladista> vrstaPlacanjaList) {
    emit(CalculationByPaymentLoaded(
      vrstaPlacanjaList: vrstaPlacanjaList,
      selectedVrstaPlacanja: state.selectedVrstaPlacanja,
      startDate: state.startDate,
      endDate: state.endDate,
      obracunPlacanjaList: [],
      obracunProizvodaList: [],
    ));
  }

  void updateSelectedVrstaPlacanja(Skladista? selectedVrstaPlacanja) {
    emit(CalculationByPaymentLoaded(
      vrstaPlacanjaList: state.vrstaPlacanjaList,
      selectedVrstaPlacanja: selectedVrstaPlacanja,
      startDate: state.startDate,
      endDate: state.endDate,
      obracunPlacanjaList: state.obracunPlacanjaList,
      obracunProizvodaList: [],
    ));
  }

  void updateStartDate(DateTime startDate) {
    emit(CalculationByPaymentLoaded(
      vrstaPlacanjaList: state.vrstaPlacanjaList,
      selectedVrstaPlacanja: state.selectedVrstaPlacanja,
      startDate: startDate,
      endDate: state.endDate,
      obracunPlacanjaList: state.obracunPlacanjaList,
      obracunProizvodaList: [],
    ));
  }

  Future<void> getObracunPlacanja() async {
    if (state.startDate.isAfter(state.endDate)) {
      emit(CalculationByPaymentError(
        errorMessage: 'Start date must be before end date',
        vrstaPlacanjaList: state.vrstaPlacanjaList,
        selectedVrstaPlacanja: state.selectedVrstaPlacanja,
        startDate: state.startDate,
        endDate: state.endDate,
        obracunPlacanjaList: [],
        obracunProizvodaList: [],
      ));
      return;
    }

    if (state.selectedVrstaPlacanja == null) {
      emit(CalculationByPaymentError(
        errorMessage: 'Please select a warehouse',
        vrstaPlacanjaList: state.vrstaPlacanjaList,
        selectedVrstaPlacanja: state.selectedVrstaPlacanja,
        startDate: state.startDate,
        endDate: state.endDate,
        obracunPlacanjaList: [],
        obracunProizvodaList: [],
      ));
      return;
    }
    if (!await ConnectivityService.isNetworkConnected()) {
      emit(CalculationByPaymentError(
        errorMessage: 'No network connection',
        vrstaPlacanjaList: state.vrstaPlacanjaList,
        selectedVrstaPlacanja: state.selectedVrstaPlacanja,
        startDate: state.startDate,
        endDate: state.endDate,
        obracunPlacanjaList: [],
        obracunProizvodaList: [],
      ));
      return;
    }
    emit(CalculationByPaymentLoading(
      vrstaPlacanjaList: state.vrstaPlacanjaList,
      selectedVrstaPlacanja: state.selectedVrstaPlacanja,
      startDate: state.startDate,
      endDate: state.endDate,
      obracunPlacanjaList: [],
      obracunProizvodaList: [],
    ));
    try {
      var items = await api.getObracunPlacanja(
        startDate: dateFormat.format(state.startDate.toLocal()),
        paymentId: state.selectedVrstaPlacanja?.id ?? '',
        endDate: dateFormat.format(state.endDate.toLocal()),
      );
      emit(CalculationByPaymentLoaded(
        vrstaPlacanjaList: state.vrstaPlacanjaList,
        selectedVrstaPlacanja: state.selectedVrstaPlacanja,
        startDate: state.startDate,
        endDate: state.endDate,
        obracunPlacanjaList: items,
        obracunProizvodaList: [],
      ));
    } catch (e) {
      emit(CalculationByPaymentError(
        vrstaPlacanjaList: state.vrstaPlacanjaList,
        selectedVrstaPlacanja: state.selectedVrstaPlacanja,
        startDate: state.startDate,
        endDate: state.endDate,
        errorMessage: e.toString(),
        obracunPlacanjaList: [],
        obracunProizvodaList: [],
      ));
    }
  }

  Future<void> getObracunProizvoda() async {
    if (state.startDate.isAfter(state.endDate)) {
      emit(CalculationByPaymentError(
        errorMessage: 'Start date must be before end date',
        vrstaPlacanjaList: state.vrstaPlacanjaList,
        selectedVrstaPlacanja: state.selectedVrstaPlacanja,
        startDate: state.startDate,
        endDate: state.endDate,
        obracunPlacanjaList: [],
        obracunProizvodaList: [],
      ));
      return;
    }

    if (state.selectedVrstaPlacanja == null) {
      emit(CalculationByPaymentError(
        errorMessage: 'Please select a payment date',
        vrstaPlacanjaList: state.vrstaPlacanjaList,
        selectedVrstaPlacanja: state.selectedVrstaPlacanja,
        startDate: state.startDate,
        endDate: state.endDate,
        obracunPlacanjaList: [],
        obracunProizvodaList: [],
      ));
      return;
    }
    if (!await ConnectivityService.isNetworkConnected()) {
      emit(CalculationByPaymentError(
        errorMessage: 'No network connection',
        vrstaPlacanjaList: state.vrstaPlacanjaList,
        selectedVrstaPlacanja: state.selectedVrstaPlacanja,
        startDate: state.startDate,
        endDate: state.endDate,
        obracunPlacanjaList: [],
        obracunProizvodaList: [],
      ));
      return;
    }
    emit(CalculationByPaymentLoading(
      vrstaPlacanjaList: state.vrstaPlacanjaList,
      selectedVrstaPlacanja: state.selectedVrstaPlacanja,
      startDate: state.startDate,
      endDate: state.endDate,
      obracunPlacanjaList: [],
      obracunProizvodaList: [],
    ));
    try {
      var items = await api.getObracunProizvoda(
        startDate: dateFormat.format(state.startDate.toLocal()),
        paymentId: state.selectedVrstaPlacanja?.id ?? '',
        endDate: dateFormat.format(state.endDate.toLocal()),
      );
      emit(CalculationByPaymentLoaded(
        vrstaPlacanjaList: state.vrstaPlacanjaList,
        selectedVrstaPlacanja: state.selectedVrstaPlacanja,
        startDate: state.startDate,
        endDate: state.endDate,
        obracunProizvodaList: items,
        obracunPlacanjaList: [],
      ));
    } catch (e) {
      emit(CalculationByPaymentError(
        errorMessage: e.toString(),
        vrstaPlacanjaList: state.vrstaPlacanjaList,
        selectedVrstaPlacanja: state.selectedVrstaPlacanja,
        startDate: state.startDate,
        endDate: state.endDate,
        obracunPlacanjaList: [],
        obracunProizvodaList: [],
      ));
    }
  }

  void updateEndDate(DateTime endDate) {
    emit(CalculationByPaymentLoaded(
      vrstaPlacanjaList: state.vrstaPlacanjaList,
      selectedVrstaPlacanja: state.selectedVrstaPlacanja,
      startDate: state.startDate,
      endDate: endDate,
      obracunPlacanjaList: [],
      obracunProizvodaList: [],
    ));
  }
}
