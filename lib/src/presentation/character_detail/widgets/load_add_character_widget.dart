import 'package:flutter/material.dart';
import 'package:rmapp/src/presentation/character_detail/controllers/character/save_character_state.dart';

class LoadAddCharacterWidget extends StatelessWidget {
  final ValueNotifier<SaveCharacterState> savingController;
  const LoadAddCharacterWidget({
    super.key,
    required this.savingController,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SaveCharacterState>(
      valueListenable: savingController,
      builder: (_, state, __) {
        if (state is LoadingSaveCharacterState) {
          return IgnorePointer(
            ignoring: false,
            child: Material(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Saving the character',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (state is SuccessSaveCharacterState) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Character added to favorites successfully',
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              );
            },
          );
          savingController.value = InitialSaveCharacterState();
        }
        if (state is ErrorSaveCharacterState) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.exception!.customMessage!,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            },
          );
          savingController.value = InitialSaveCharacterState();
        }
        return const SizedBox();
      },
    );
  }
}
