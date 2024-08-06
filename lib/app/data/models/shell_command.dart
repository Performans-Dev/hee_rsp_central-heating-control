import 'dart:convert';

class ShellCommand {
  String command;
  List<String>? arguments;
  String? workingDirectory;
  String? output;
  String? error;
  ShellCommand({
    required this.command,
    this.arguments,
    this.workingDirectory,
    this.output,
    this.error,
  });

  Map<String, dynamic> toMap() {
    return {
      'command': command,
      'arguments': arguments,
      'workingDirectory': workingDirectory,
      'output': output,
      'error': error,
    };
  }

  factory ShellCommand.fromMap(Map<String, dynamic> map) {
    return ShellCommand(
      command: map['command'] ?? '',
      arguments: List<String>.from(map['arguments']),
      workingDirectory: map['workingDirectory'] ?? '',
      output: map['output'],
      error: map['error'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ShellCommand.fromJson(String source) =>
      ShellCommand.fromMap(json.decode(source));
}
