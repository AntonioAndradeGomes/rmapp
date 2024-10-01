import 'package:flutter/material.dart';
import 'package:rmapp/src/dependencies/dependencies_injector.dart';
import 'package:rmapp/src/domain/character/entities/enums.dart';
import 'package:rmapp/src/domain/character/entities/filter_character_entity.dart';
import 'package:rmapp/src/presentation/home/controllers/filter/filter_controller.dart';

class FilterDialogWidget extends StatefulWidget {
  final FilterCharacter activeFilter;
  const FilterDialogWidget({
    super.key,
    required this.activeFilter,
  });

  @override
  State<FilterDialogWidget> createState() => _FilterDialogWidgetState();
}

class _FilterDialogWidgetState extends State<FilterDialogWidget> {
  final _controller = injector<FilterController>();

  @override
  void initState() {
    _controller.setFilter(
      widget.activeFilter,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 350,
          maxHeight: 450,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              child: Text(
                'Filter',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _controller,
              builder: (_, state, __) {
                return Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    children: [
                      Text(
                        'Status',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Wrap(
                        spacing: 5,
                        children: StatusEnum.values
                            .map(
                              (e) => FilterChip(
                                label: Text(e.label),
                                onSelected: (value) {
                                  if (value) {
                                    _controller.setStatus(e);
                                  }
                                },
                                selected: e == state.statusEnum,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Species',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Wrap(
                        spacing: 5,
                        children: SpecieEnum.values
                            .map(
                              (e) => FilterChip(
                                label: Text(e.label),
                                onSelected: (value) {
                                  if (value) {
                                    _controller.setSpecie(e);
                                  }
                                },
                                selected: e == state.specieEnum,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Gender',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Wrap(
                        spacing: 5,
                        children: GenderEnum.values
                            .map(
                              (e) => FilterChip(
                                label: Text(e.label),
                                onSelected: (value) {
                                  if (value) {
                                    _controller.setGender(e);
                                  }
                                },
                                selected: e == state.genderEnum,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop(_controller.value);
                },
                child: Text(
                  'Apply',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
