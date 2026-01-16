import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:lottie/lottie.dart';

typedef CommandSuccessBuilder<T> =
    Widget Function(BuildContext context, T value);
typedef CommandFailureBuilder =
    Widget Function(BuildContext context, Object? error);

class CommandBuilder<T extends Object> extends StatelessWidget {
  final Command<T> command;
  final Widget? idle;
  final Widget? loading;
  final CommandSuccessBuilder<T> success;
  final CommandFailureBuilder? error;

  const CommandBuilder({
    super.key,
    required this.command,
    required this.success,
    this.error,
    this.idle,
    this.loading,
  });

  // command_builder.dart
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: command,
      builder: (context, _) {
        final value = command.value;

        if (value is IdleCommand) return idle ?? const SizedBox.shrink();

        if (value is RunningCommand) {
          return loading ??
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Garante que não tente ocupar a tela toda
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: Lottie.asset(
                        'assets/animations/lottie/loading.json',
                        repeat: true,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Buscando Pokémons...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
        }

        if (value is SuccessCommand<T>) return success(context, value.value);

        if (value is FailureCommand<T>) {
          if (error != null) return error!(context, value.error);
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text('Erro: ${value.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => (command as dynamic).execute(),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
