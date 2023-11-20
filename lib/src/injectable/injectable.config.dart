// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../api/api.dart' as _i3;
import '../features/artikli/cubit/artikli_cubit.dart' as _i4;
import '../features/calculation/cubit/calculation_by_payment_cubit.dart' as _i5;

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.factory<_i3.Api>(() => _i3.Api());
  gh.factory<_i4.ArtikliCubit>(() => _i4.ArtikliCubit(api: gh<_i3.Api>()));
  gh.factory<_i5.CalculationByPaymentCubit>(
      () => _i5.CalculationByPaymentCubit(api: gh<_i3.Api>()));
  return getIt;
}
