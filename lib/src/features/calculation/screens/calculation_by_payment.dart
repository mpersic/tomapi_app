import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tomsoft_app/src/data/data.dart';
import 'package:tomsoft_app/src/features/calculation/cubit/calculation_by_payment_cubit.dart';
import 'package:tomsoft_app/src/features/calculation/cubit/calculation_by_payment_state.dart';
import 'package:tomsoft_app/src/injectable/injectable.dart';

class CalculationByPaymentScreen extends StatelessWidget {
  const CalculationByPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          Injector.locateService<CalculationByPaymentCubit>()..loadItems(),
      child: const _CalculationByPaymentScreen(),
    );
  }
}

class _CalculationByPaymentScreen extends StatelessWidget {
  const _CalculationByPaymentScreen();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocConsumer<CalculationByPaymentCubit, CalculationByPaymentState>(
        listener: (context, state) {
          if (state is CalculationByPaymentError) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: Text(state.errorMessage),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context
                            .read<CalculationByPaymentCubit>()
                            .toggleErrorState();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _buildDropdownButton(context, state),
              const SizedBox(height: 16),
              _buildDateSelectionRow(context, state),
              const SizedBox(height: 16),
              _buildCalculationButton(
                label: 'Calculate by payment type',
                onPressed: () {
                  context
                      .read<CalculationByPaymentCubit>()
                      .getObracunPlacanja();
                },
              ),
              _buildCalculationButton(
                label: 'Calculate by products',
                onPressed: () {
                  context
                      .read<CalculationByPaymentCubit>()
                      .getObracunProizvoda();
                },
              ),
              const SizedBox(height: 16),
              _buildResultList(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDropdownButton(
      BuildContext context, CalculationByPaymentState state) {
    return DropdownButton<Skladista>(
      value: state.selectedVrstaPlacanja,
      items: state.vrstaPlacanjaList.map((vrstaPlacanja) {
        return DropdownMenuItem<Skladista>(
          value: vrstaPlacanja,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              vrstaPlacanja.name ?? '',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      }).toList(),
      onChanged: (selectedVrstaPlacanja) {
        context
            .read<CalculationByPaymentCubit>()
            .updateSelectedVrstaPlacanja(selectedVrstaPlacanja);
      },
      hint: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Select a warehouse',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildDateSelectionRow(
      BuildContext context, CalculationByPaymentState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildDateSelection(
          context: context,
          labelText: 'Start Date',
          selectedDate: state.startDate,
          onPressed: (picked) {
            context.read<CalculationByPaymentCubit>().updateStartDate(picked);
          },
        ),
        _buildDateSelection(
          context: context,
          labelText: 'End Date',
          selectedDate: state.endDate,
          onPressed: (picked) {
            context.read<CalculationByPaymentCubit>().updateEndDate(picked);
          },
        ),
      ],
    );
  }

  Widget _buildDateSelection({
    required BuildContext context,
    required String labelText,
    required DateTime selectedDate,
    required Function(DateTime) onPressed,
  }) {
    final DateFormat dateFormat = DateFormat('dd.MM.yyyy');
    return Column(
      children: [
        Text(
          '$labelText: ${dateFormat.format(selectedDate.toLocal())}',
          style: const TextStyle(fontSize: 14),
        ),
        ElevatedButton(
          onPressed: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (picked != null && picked != selectedDate) {
              onPressed(picked);
            }
          },
          child: Text(
            'Select $labelText',
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildCalculationButton(
      {required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildResultList(CalculationByPaymentState state) {
    return BlocBuilder<CalculationByPaymentCubit, CalculationByPaymentState>(
      builder: (context, state) {
        return SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: state.obracunPlacanjaList.length +
                state.obracunProizvodaList.length,
            itemBuilder: (BuildContext context, int index) {
              if (index < state.obracunPlacanjaList.length) {
                final item = state.obracunPlacanjaList[index];
                return _buildResultItem(
                    item.name ?? '', 'Iznos: ${item.iznos ?? ''}');
              } else {
                final item = state.obracunProizvodaList[
                    index - state.obracunPlacanjaList.length];
                return _buildResultItem(
                  item.name ?? '',
                  'Iznos: ${item.iznos ?? ''}\nKolicina: ${item.kolicina ?? ''}\nUsluga: ${item.usluga ?? ''}',
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildResultItem(String title, String subtitle) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
    );
  }
}
