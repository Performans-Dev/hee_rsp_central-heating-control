import 'dart:io';

import 'package:central_heating_control/app/data/models/shell_command.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';

class ShellTestScreen extends StatefulWidget {
  const ShellTestScreen({super.key});

  @override
  State<ShellTestScreen> createState() => _ShellTestScreenState();
}

class _ShellTestScreenState extends State<ShellTestScreen> {
  String stdOut = '';
  String stdErr = '';

  List<ShellCommand> updateCommands = [
    ShellCommand(command: 'whoami'),
    ShellCommand(
      command: 'git',
      arguments: ['checkout', '.'],
      workingDirectory:
          '/home/pi/Heethings/cc-source/hee_rsp_central-heating-control',
    ),
    ShellCommand(
      command: 'git',
      arguments: [
        'clean',
        '-fd',
      ],
    ),
    ShellCommand(
      command: 'gh',
      arguments: [
        'repo',
        'sync',
      ],
    ),
    ShellCommand(
      command: 'sudo',
      arguments: [
        'rm',
        '-rf',
        '.dart_tool',
      ],
    ),
    ShellCommand(
      command: 'sudo',
      arguments: [
        'chown',
        '-R',
        '\$(whoami)',
        '/home/pi/Heethings/cc-source',
      ],
    ),
    ShellCommand(
      command: 'flutter',
      arguments: [
        'doctor',
        '-v',
      ],
    ),
    ShellCommand(
      command: 'sudo',
      arguments: [
        '-u',
        'pi',
        'flutter',
        'clean',
      ],
    ),
    ShellCommand(
      command: 'sudo',
      arguments: [
        '-u',
        'pi',
        'flutter',
        'pub',
        'get',
      ],
    ),
    ShellCommand(
      command: 'sudo',
      arguments: [
        '-u',
        'pi',
        'flutter',
        'build',
        'linux',
        '--release',
      ],
    ),
    ShellCommand(
      command: 'cp',
      arguments: [
        '-r',
        '/home/pi/Heethings/cc-source/hee_rsp_central-heating-control/build/linux/arm64/release/bundle/*',
        '/home/pi/Heethings/cc-app',
      ],
    ),
    ShellCommand(
      command: 'sudo',
      arguments: [
        'reboot',
        'now',
      ],
    ),
  ];

  List<int> commandResults = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commandResults = List.generate(updateCommands.length, (e) => -1);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: ListView.separated(
        itemBuilder: (context, index) => ListTile(
          title: Text(
            '${updateCommands[index].command} '
            '${updateCommands[index].arguments?.join(' ')}',
          ),
          subtitle: Text(
              '${updateCommands[index].output}\n${updateCommands[index].error}'),
          trailing: IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              try {
                final result = await Process.run(
                  updateCommands[index].command,
                  updateCommands[index].arguments ?? [],
                  workingDirectory: updateCommands[index].workingDirectory,
                );
                setState(() {
                  commandResults[index] = result.exitCode;
                  updateCommands[index].output = result.stdout;
                  updateCommands[index].error = result.stderr;
                });
              } on Exception catch (e) {
                setState(() {
                  commandResults[index] = 99;
                  updateCommands[index].error = e.toString();
                });
              }
            },
          ),
          leading: CircleAvatar(
            child: Text('${commandResults[index]}'),
          ),
        ),
        itemCount: updateCommands.length,
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }
}
