import 'package:tomsoft_app/src/data/data.dart';

sealed class CalculationByPaymentState {
  CalculationByPaymentState({
    required this.vrstaPlacanjaList,
    this.selectedVrstaPlacanja,
    required this.obracunPlacanjaList,
    required this.obracunProizvodaList,
    required this.startDate,
    required this.endDate,
  });
  final List<Skladista> vrstaPlacanjaList;
  final Skladista? selectedVrstaPlacanja;
  final List<ObracunPlacanja> obracunPlacanjaList;
  final List<ObracunProizvoda> obracunProizvodaList;
  final DateTime startDate;
  final DateTime endDate;
}

class CalculationByPaymentInitial extends CalculationByPaymentState {
  CalculationByPaymentInitial()
      : super(
          vrstaPlacanjaList: [],
          selectedVrstaPlacanja: null,
          obracunPlacanjaList: [],
          obracunProizvodaList: [],
          startDate: DateTime.now(),
          endDate: DateTime.now(),
        );
}

class CalculationByPaymentLoading extends CalculationByPaymentState {
  CalculationByPaymentLoading({
    required List<Skladista> vrstaPlacanjaList,
    Skladista? selectedVrstaPlacanja,
    required List<ObracunPlacanja> obracunPlacanjaList,
    required List<ObracunProizvoda> obracunProizvodaList,
    required DateTime startDate,
    required DateTime endDate,
  }) : super(
          vrstaPlacanjaList: vrstaPlacanjaList,
          selectedVrstaPlacanja: selectedVrstaPlacanja,
          obracunPlacanjaList: obracunPlacanjaList,
          obracunProizvodaList: obracunProizvodaList,
          startDate: startDate,
          endDate: endDate,
        );
}

class CalculationByPaymentLoaded extends CalculationByPaymentState {
  CalculationByPaymentLoaded({
    required List<Skladista> vrstaPlacanjaList,
    Skladista? selectedVrstaPlacanja,
    required List<ObracunPlacanja> obracunPlacanjaList,
    required List<ObracunProizvoda> obracunProizvodaList,
    required DateTime startDate,
    required DateTime endDate,
  }) : super(
          vrstaPlacanjaList: vrstaPlacanjaList,
          selectedVrstaPlacanja: selectedVrstaPlacanja,
          obracunPlacanjaList: obracunPlacanjaList,
          obracunProizvodaList: obracunProizvodaList,
          startDate: startDate,
          endDate: endDate,
        );
}

class CalculationByPaymentError extends CalculationByPaymentState {
  CalculationByPaymentError({
    required this.errorMessage,
    required List<Skladista> vrstaPlacanjaList,
    Skladista? selectedVrstaPlacanja,
    required List<ObracunPlacanja> obracunPlacanjaList,
    required List<ObracunProizvoda> obracunProizvodaList,
    required DateTime startDate,
    required DateTime endDate,
  }) : super(
          vrstaPlacanjaList: vrstaPlacanjaList,
          selectedVrstaPlacanja: selectedVrstaPlacanja,
          obracunPlacanjaList: obracunPlacanjaList,
          obracunProizvodaList: obracunProizvodaList,
          startDate: startDate,
          endDate: endDate,
        );
  final String errorMessage;
}
