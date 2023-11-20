import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomsoft_app/src/data/artikl.dart';
import 'package:tomsoft_app/src/features/artikli/cubit/artikli_cubit.dart';
import 'package:tomsoft_app/src/features/artikli/cubit/artikli_state.dart';
import 'package:tomsoft_app/src/injectable/injectable.dart';

class ArtikliContentView extends StatelessWidget {
  const ArtikliContentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Injector.locateService<ArtikliCubit>()..loadItems(),
      child: _ArtikliContentView(),
    );
  }
}

class _ArtikliContentView extends StatefulWidget {
  @override
  State<_ArtikliContentView> createState() => _ArtikliContentViewState();
}

class _ArtikliContentViewState extends State<_ArtikliContentView> {
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<ArtikliCubit>();
    return BlocConsumer<ArtikliCubit, ArtikliState>(
      listener: (context, state) {
        if (state is ArtikliError) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(state.error),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      cubit.toggleErrorState();
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
        if (state is ArtikliLoading) {
          return const CircularProgressIndicator();
        } else if (state is ArtikliLoaded) {
          return _buildContent(state.items);
        } else if (state is ArtikliError) {
          return Text('Error: ${state.error}');
        } else {
          return const Text('Unexpected state');
        }
      },
    );
  }

  Widget _buildContent(List<Artikl> items) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: editingController,
              onEditingComplete: () {
                String searchText = editingController.text;
                context.read<ArtikliCubit>().loadItems(searchText: searchText);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search',
                prefixIcon: GestureDetector(
                    onTap: () {
                      String searchText = editingController.text;
                      context
                          .read<ArtikliCubit>()
                          .loadItems(searchText: searchText);
                    },
                    child: const Icon(Icons.search)),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: items.isNotEmpty
                ? ListView.builder(
                    restorationId: 'sampleItemListView',
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = items[index];
                      return ListTile(
                        title: Text(' ${item.name}'),
                        subtitle: Text(' ${item.id}'),
                      );
                    },
                  )
                : const Center(child: Text('No items found')),
          ),
        ],
      ),
    );
  }
}
