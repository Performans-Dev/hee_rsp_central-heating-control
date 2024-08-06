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
      command: 'runuser',
      arguments: [
        '-u',
        'pi',
        '-c'
            '\'whoami\'',
      ],
    ),
    ShellCommand(
      command: 'runuser',
      arguments: [
        '-u',
        'pi',
        'git',
        'checkout',
        '.',
      ],
      workingDirectory:
          '/home/pi/Heethings/cc-source/hee_rsp_central-heating-control',
    ),
    ShellCommand(
      command: 'runuser',
      arguments: [
        '-u',
        'pi',
        'git',
        'clean',
        '-fd',
      ],
      workingDirectory:
          '/home/pi/Heethings/cc-source/hee_rsp_central-heating-control',
    ),
    ShellCommand(
      command: 'runuser',
      arguments: [
        '-u',
        'pi',
        'gh',
        'repo',
        'sync',
      ],
      workingDirectory:
          '/home/pi/Heethings/cc-source/hee_rsp_central-heating-control',
    ),
    ShellCommand(
      command: 'sudo',
      arguments: [
        'rm',
        '-rf',
        '.dart_tool',
      ],
      workingDirectory:
          '/home/pi/Heethings/cc-source/hee_rsp_central-heating-control',
    ),
    ShellCommand(
      command: 'sudo',
      arguments: [
        'chown',
        '-R',
        '\$(whoami)',
        '/home/pi/Heethings/cc-source/',
      ],
      workingDirectory:
          '/home/pi/Heethings/cc-source/hee_rsp_central-heating-control',
    ),
    ShellCommand(
      command: 'sudo',
      arguments: [
        'chown',
        '-R',
        'pi',
        '/home/pi/Heethings/cc-source/',
      ],
      workingDirectory:
          '/home/pi/Heethings/cc-source/hee_rsp_central-heating-control',
    ),
    ShellCommand(
      command: 'runuser',
      arguments: [
        '-u',
        'pi',
        '-c',
        '\'flutter doctor -v\'',
      ],
      workingDirectory:
          '/home/pi/Heethings/cc-source/hee_rsp_central-heating-control',
    ),
    ShellCommand(
      command: 'runuser',
      arguments: [
        '-u',
        'pi',
        'flutter',
        'clean',
      ],
    ),
    ShellCommand(
      command: 'runuser',
      arguments: [
        '-u',
        'pi',
        'flutter',
        'pub',
        'get',
      ],
      workingDirectory:
          '/home/pi/Heethings/cc-source/hee_rsp_central-heating-control',
    ),
    ShellCommand(
      command: 'runuser',
      arguments: [
        '-u',
        'pi',
        'flutter',
        'build',
        'linux',
        '--release',
      ],
      workingDirectory:
          '/home/pi/Heethings/cc-source/hee_rsp_central-heating-control',
    ),
    ShellCommand(
      command: 'cp',
      arguments: [
        '-r',
        '/home/pi/Heethings/cc-source/hee_rsp_central-heating-control/build/linux/arm64/release/bundle/*',
        '/home/pi/Heethings/cc-app',
      ],
      workingDirectory:
          '/home/pi/Heethings/cc-source/hee_rsp_central-heating-control',
    ),
    ShellCommand(
      command: 'sudo',
      arguments: [
        'reboot',
        'now',
      ],
      workingDirectory:
          '/home/pi/Heethings/cc-source/hee_rsp_central-heating-control',
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
