// ignore_for_file: avoid_print

import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:flutter/foundation.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/models/app_user/app_user.dart';
import 'package:central_heating_control/app/data/models/device/device.dart';
import 'package:central_heating_control/app/data/models/group/group.dart';
import 'package:central_heating_control/app/data/models/group/group_inputs.dart';
import 'package:central_heating_control/app/data/models/input_outputs/analog_input.dart';
import 'package:central_heating_control/app/data/models/input_outputs/digital_input.dart';
import 'package:central_heating_control/app/data/models/input_outputs/digital_output.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DbProvider {
  DbProvider._();
  static final DbProvider db = DbProvider._();
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDb();
    return _database;
  }

  Future<Database?> initDb() async {
    try {
      var dbFactory = databaseFactoryFfi;
      final dbPath = await getDbPath();
      if (dbPath == null) return null;
      debugPrint('Database path: $dbPath');
      return await dbFactory.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
          onOpen: (db) async {
            try {
              await db.execute('PRAGMA foreign_keys = ON');
              final result = await db.rawQuery('PRAGMA foreign_keys');
              debugPrint('Foreign keys enabled: ${result.first.values.first == 1}');
            } catch (e) {
              debugPrint('Error enabling foreign keys: $e');
            }
          },
          onCreate: (db, version) async {
            try {
              await db.execute('PRAGMA foreign_keys = ON');
              await createDbStructure(db);
            } catch (e) {
              debugPrint('Error in onCreate: $e');
            }
          },
          onUpgrade: (db, oldVersion, newVersion) async {
            try {
              // TODO: Handle backup
              await createDbStructure(db);
              // TODO: Handle restore
            } catch (e) {
              debugPrint('Error in onUpgrade: $e');
            }
          },
          singleInstance: true,
          version: Keys.databaseVersion,
        ),
      );
    } catch (e) {
      debugPrint('Error initializing database: $e');
      return null;
    }
  }

  Future<String?> getDbPath() async {
    try {
      String dbPath = p.join(
        Box.documentsDirectoryPath,
        Keys.databasePath,
        Keys.databaseName,
      );
      return dbPath;
    } catch (e) {
      debugPrint('Error getting database path: $e');
      return null;
    }
  }

  //#region MARK: Database
  Future<void> createDbStructure(Database db) async {
    try {
      // users
      await db.execute(Keys.dropTableAppUsers);
      await db.execute(Keys.createTableAppUsers);
      await db.execute(Keys.populateTableAppUsers);

      // heaters

      // digital outputs
      await db.execute(Keys.dropTableDigitalOutputs);
      await db.execute(Keys.createTableDigitalOutputs);
      await db.execute(Keys.populateTableDigitalOutputs);

      // digital inputs
      await db.execute(Keys.dropTableDigitalInputs);
      await db.execute(Keys.createTableDigitalInputs);
      await db.execute(Keys.populateTableDigitalInputs);

      // analog inputs
      await db.execute(Keys.dropTableAnalogInputs);
      await db.execute(Keys.createTableAnalogInputs);
      await db.execute(Keys.populateTableAnalogInputs);

      // groups
      await db.execute(Keys.dropTableGroups);
      await db.execute(Keys.createTableGroups);
      await db.execute(Keys.populateTableGroups);

      await db.execute(Keys.dropTableGroupInputs);
      await db.execute(Keys.createTableGroupInputs);

      await db.execute(Keys.dropTableGroupUsers);
      await db.execute(Keys.createTableGroupUsers);

      // devices
      await db.execute(Keys.dropTableDevices);
      await db.execute(Keys.createTableDevices);

      // device inputs
      await db.execute(Keys.dropTableDeviceInputs);
      await db.execute(Keys.createTableDeviceInputs);

      // device outputs
      await db.execute(Keys.dropTableDeviceOutputs);
      await db.execute(Keys.createTableDeviceOutputs);

      // device states
      await db.execute(Keys.dropTableDeviceStates);
      await db.execute(Keys.createTableDeviceStates);

      // device levels
      await db.execute(Keys.dropTableDeviceLevels);
      await db.execute(Keys.createTableDeviceLevels);
    } catch (e) {
      debugPrint('Error creating database structure: $e');
    }
  }
  //#endregion

  //#region MARK: Input Outputs
  Future<List<AnalogInput>> getAnalogInputs() async {
    try {
      final db = await database;
      if (db == null) return [];
      final rows = await db.query(Keys.tableAnalogInputs);
      return rows.map((row) => AnalogInput.fromMap(row)).toList();
    } catch (e) {
      debugPrint('Error getting analog inputs: $e');
      return [];
    }
  }

  Future<int> saveAnalogInput(AnalogInput analogInput) async {
    try {
      final db = await database;
      if (db == null) return 0;
      return await db.update(
          Keys.tableAnalogInputs,
          where: 'id = ?',
          whereArgs: [analogInput.id],
          analogInput.toMap());
    } catch (e) {
      debugPrint('Error saving analog input: $e');
      return 0;
    }
  }

  Future<List<DigitalInput>> getDigitalInputs() async {
    try {
      final db = await database;
      if (db == null) return [];
      final rows = await db.query(Keys.tableDigitalInputs);
      return rows.map((row) => DigitalInput.fromMap(row)).toList();
    } catch (e) {
      debugPrint('Error getting digital inputs: $e');
      return [];
    }
  }

  Future<DigitalInput?> getDigitalInputById(int id) async {
    try {
      final db = await database;
      if (db == null) return null;
      final rows = await db
          .query(Keys.tableDigitalInputs, where: 'id = ?', whereArgs: [id]);
      return rows.isNotEmpty ? DigitalInput.fromMap(rows.first) : null;
    } catch (e) {
      debugPrint('Error getting digital input by id: $e');
      return null;
    }
  }

  Future<int> saveDigitalInput(DigitalInput digitalInput) async {
    try {
      final db = await database;
      if (db == null) return 0;
      return await db.update(
          Keys.tableDigitalInputs,
          where: 'id = ?',
          whereArgs: [digitalInput.id],
          digitalInput.toMap());
    } catch (e) {
      debugPrint('Error saving digital input: $e');
      return 0;
    }
  }

  Future<List<DigitalOutput>> getDigitalOutputs() async {
    try {
      final db = await database;
      if (db == null) return [];
      final rows = await db.query(Keys.tableDigitalOutputs);
      return rows.map((row) => DigitalOutput.fromMap(row)).toList();
    } catch (e) {
      debugPrint('Error getting digital outputs: $e');
      return [];
    }
  }

  Future<int> saveDigitalOutput(DigitalOutput digitalOutput) async {
    try {
      final db = await database;
      if (db == null) return 0;
      return await db.update(
          Keys.tableDigitalOutputs,
          where: 'id = ?',
          whereArgs: [digitalOutput.id],
          digitalOutput.toMap());
    } catch (e) {
      debugPrint('Error saving digital output: $e');
      return 0;
    }
  }
  //#endregion

  //#region MARK: AppUsers
  Future<List<AppUser>> getAppUsers() async {
    try {
      final db = await database;
      if (db == null) return [];
      final rows = await db.query(Keys.tableAppUsers);
      return rows.map((row) => AppUser.fromMap(row)).toList();
    } catch (e) {
      debugPrint('Error getting app users: $e');
      return [];
    }
  }

  Future<int> saveAppUser(AppUser appUser) async {
    try {
      final db = await database;
      if (db == null) return 0;
      return await db.update(
          Keys.tableAppUsers,
          where: 'id = ?',
          whereArgs: [appUser.id],
          appUser.toMap());
    } catch (e) {
      debugPrint('Error saving app user: $e');
      return 0;
    }
  }

  Future<int> insertUser(AppUser appUser) async {
    try {
      final db = await database;
      if (db == null) return 0;
      return await db.insert(Keys.tableAppUsers, appUser.toMap());
    } catch (e) {
      debugPrint('Error inserting app user: $e');
      return 0;
    }
  }

  Future<int> deleteUser(int id) async {
    try {
      final db = await database;
      if (db == null) return 0;
      return await db
          .delete(Keys.tableAppUsers, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint('Error deleting app user: $e');
      return 0;
    }
  }
  //#endregion

  //#region MARK: Groups
  Future<List<GroupDefinition>> getGroupList() async {
    try {
      final db = await database;
      if (db == null) return [];
      
      // Get all groups
      final groupRows = await db.query(Keys.tableGroups);
      final List<GroupDefinition> groups = [];
      
      // For each group, fetch its inputs and users
      for (final groupRow in groupRows) {
        try {
          final groupId = groupRow['id'] as int;
          
          // Get group inputs with join to get the digital input details
          final inputRows = await db.rawQuery('''
            SELECT gi.id as gi_id, gi.groupId, gi.digitalInputId, gi.triggerValue, 
                  di.id as di_id, di.hwId, di.pinIndex, di.name, di.value 
            FROM ${Keys.tableGroupInputs} gi
            JOIN ${Keys.tableDigitalInputs} di ON gi.digitalInputId = di.id
            WHERE gi.groupId = ?
          ''', [groupId]);
          
          // Map to GroupInput objects
          final inputs = inputRows.map((row) {
            try {
              // Create DigitalInput from the joined data
              final digitalInput = DigitalInput(
                id: row['di_id'] as int,
                hwId: row['hwId'] as int,
                pinIndex: row['pinIndex'] as int,
                name: row['name'] as String,
                value: (row['value'] as int) == 1,
              );
              
              return GroupInput(
                id: row['gi_id'] as int,
                groupId: groupId,
                digitalInput: digitalInput,
                triggerValue: row['triggerValue'] == 1,
              );
            } catch (e) {
              debugPrint('Error mapping group input: $e');
              // Return a default GroupInput to avoid breaking the list
              return GroupInput(
                id: 0,
                groupId: groupId,
                digitalInput: DigitalInput(
                  id: 0,
                  hwId: 0,
                  pinIndex: 0,
                  name: 'Error',
                  value: false,
                ),
                triggerValue: false,
              );
            }
          }).toList();
          
          // Get group users with join to get the user details
          final userRows = await db.rawQuery('''
            SELECT gu.id as gu_id, gu.groupId, gu.userId, 
                  au.id as au_id, au.name, au.pinCode, au.level 
            FROM ${Keys.tableGroupUsers} gu
            JOIN ${Keys.tableAppUsers} au ON gu.userId = au.id
            WHERE gu.groupId = ?
          ''', [groupId]);
          
          // Map to AppUser objects
          final users = userRows.map((row) {
            try {
              return AppUser(
                id: row['au_id'] as int,
                name: row['name'] as String,
                pinCode: row['pinCode'] as String,
                level: row['level'] as int,
              );
            } catch (e) {
              debugPrint('Error mapping group user: $e');
              // Return a default AppUser to avoid breaking the list
              return AppUser(
                id: 0,
                name: 'Error',
                pinCode: '000000',
                level: 0,
              );
            }
          }).toList();
          
          // Create GroupDefinition with the fetched inputs and users
          groups.add(GroupDefinition(
            id: groupId,
            name: groupRow['name'] as String? ?? '',
            color: groupRow['color'] as String? ?? '',
            inputs: inputs,
            users: users,
            adjustedLevel: groupRow['adjustedLevel'] as int? ?? 0,
            schedulePlan: groupRow['schedulePlan'] as int?,
            thermostatTemperature: groupRow['thermostatTemperature'] as double? ?? 0.0,
            intervalOn: groupRow['intervalOn'] as int?,
            intervalOff: groupRow['intervalOff'] as int?,
            cooldownTime: groupRow['cooldownTime'] as int? ?? 0,
          ));
        } catch (e) {
          debugPrint('Error processing group: $e');
          // Continue to the next group instead of breaking the entire function
        }
      }
      
      return groups;
    } catch (e) {
      debugPrint('Error getting group list: $e');
      return [];
    }
  }

  Future<int> saveGroup(GroupDefinition group) async {
    try {
      final db = await database;
      if (db == null) return 0;
      
      // Start a transaction to ensure all operations succeed or fail together
      return await db.transaction((txn) async {
        try {
          // 1. Update the main group information
          final groupMap = {
            'name': group.name,
            'color': group.color,
            'schedulePlan': group.schedulePlan,
            'thermostatTemperature': group.thermostatTemperature,
            'intervalOn': group.intervalOn,
            'intervalOff': group.intervalOff,
            'cooldownTime': group.cooldownTime,
            'adjustedLevel': group.adjustedLevel,
          };
          
          await txn.update(
            Keys.tableGroups,
            groupMap,
            where: 'id = ?',
            whereArgs: [group.id],
          );
          
          // 2. Delete existing relationships
          await txn.delete(
            Keys.tableGroupInputs,
            where: 'groupId = ?',
            whereArgs: [group.id],
          );
          
          await txn.delete(
            Keys.tableGroupUsers,
            where: 'groupId = ?',
            whereArgs: [group.id],
          );
          
          // 3. Insert new group inputs
          for (final input in group.inputs) {
            await txn.insert(Keys.tableGroupInputs, {
              'groupId': group.id,
              'digitalInputId': input.digitalInput.id,
              'triggerValue': input.triggerValue ? 1 : 0,
            });
          }
          
          // 4. Insert new group users
          for (final user in group.users) {
            await txn.insert(Keys.tableGroupUsers, {
              'groupId': group.id,
              'userId': user.id,
            });
          }
          
          return group.id;
        } catch (e) {
          debugPrint('Error in saveGroup transaction: $e');
          rethrow; // Rethrow to trigger transaction rollback
        }
      });
    } catch (e) {
      debugPrint('Error saving group: $e');
      return 0;
    }
  }

  Future<int> insertGroup(GroupDefinition group) async {
    try {
      final db = await database;
      if (db == null) return 0;
      
      // Start a transaction to ensure all operations succeed or fail together
      return await db.transaction((txn) async {
        try {
          // 1. Insert the main group information
          final groupMap = {
            'name': group.name,
            'color': group.color,
            'schedulePlan': group.schedulePlan,
            'thermostatTemperature': group.thermostatTemperature,
            'intervalOn': group.intervalOn,
            'intervalOff': group.intervalOff,
            'cooldownTime': group.cooldownTime,
            'adjustedLevel': group.adjustedLevel,
          };
          
          final id = await txn.insert(Keys.tableGroups, groupMap);
          
          // 2. Insert group inputs
          for (final input in group.inputs) {
            await txn.insert(Keys.tableGroupInputs, {
              'groupId': id,
              'digitalInputId': input.digitalInput.id,
              'triggerValue': input.triggerValue ? 1 : 0,
            });
          }
          
          // 3. Insert group users
          for (final user in group.users) {
            await txn.insert(Keys.tableGroupUsers, {
              'groupId': id,
              'userId': user.id,
            });
          }
          
          return id;
        } catch (e) {
          debugPrint('Error in insertGroup transaction: $e');
          rethrow; // Rethrow to trigger transaction rollback
        }
      });
    } catch (e) {
      debugPrint('Error inserting group: $e');
      return 0;
    }
  }

  Future<int> deleteGroup(int id) async {
    try {
      final db = await database;
      if (db == null) return 0;
      
      // Use a transaction to ensure all operations succeed or fail together
      return await db.transaction((txn) async {
        try {
          // 1. Delete devices associated with this group
          // Note: This will cascade delete device inputs, outputs, states, and levels
          // due to the ON DELETE CASCADE constraints on those tables
          await txn.delete(
            Keys.tableDevices,
            where: 'groupId = ?',
            whereArgs: [id],
          );
          
          // 2. Delete the group itself
          // Note: This will cascade delete group inputs and users
          // due to the ON DELETE CASCADE constraints on those tables
          return await txn.delete(
            Keys.tableGroups,
            where: 'id = ?',
            whereArgs: [id],
          );
        } catch (e) {
          debugPrint('Error in deleteGroup transaction: $e');
          rethrow; // Rethrow to trigger transaction rollback
        }
      });
    } catch (e) {
      debugPrint('Error deleting group: $e');
      return 0;
    }
  }

  //#endregion

  //#region MARK: Devices
  Future<List<Device>> getDevices() async {
    try {
      final db = await database;
      if (db == null) return [];

      final deviceRows = await db.query(Keys.tableDevices);

      List<Device> devices = [];

      for (final row in deviceRows) {
        try {
          final deviceId = row['id'] as int;

          final results = await Future.wait([
            db.query(Keys.tableDeviceInputs,
                where: 'deviceId = ?', whereArgs: [deviceId]),
            db.query(Keys.tableDeviceOutputs,
                where: 'deviceId = ?', whereArgs: [deviceId]),
            db.query(Keys.tableDeviceStates,
                where: 'deviceId = ?', whereArgs: [deviceId]),
            db.query(Keys.tableDeviceLevels,
                where: 'deviceId = ?', whereArgs: [deviceId]),
          ]);

          final inputs = results[0] as List<Map<String, dynamic>>;
          final outputs = results[1] as List<Map<String, dynamic>>;
          final states = results[2] as List<Map<String, dynamic>>;
          final levels = results[3] as List<Map<String, dynamic>>;

          try {
            final device = Device.fromMap(row).copyWith(
              deviceInputs: inputs.map((e) {
                try {
                  return DeviceInput.fromMap(e);
                } catch (e) {
                  debugPrint('Error mapping device input: $e');
                  // Create a default DeviceInput with minimal data
                  return DeviceInput(
                    id: 0,
                    deviceId: 0,
                    inputId: 0,
                    priority: 0,
                    indexNumber: 0,
                    description: 'Error',
                  );
                }
              }).toList(),
              deviceOutputs: outputs.map((e) {
                try {
                  return DeviceOutput.fromMap(e);
                } catch (e) {
                  debugPrint('Error mapping device output: $e');
                  // Create a default DeviceOutput with minimal data
                  return DeviceOutput(
                    id: 0,
                    deviceId: 0,
                    outputId: 0,
                    priority: 0,
                    indexNumber: 0,
                    description: 'Error',
                  );
                }
              }).toList(),
              states: states.map((e) {
                try {
                  return DeviceState.fromMap(e);
                } catch (e) {
                  debugPrint('Error mapping device state: $e');
                  // Create a default DeviceState with minimal data
                  return DeviceState(
                    id: 0,
                    deviceId: 0,
                    level: 0,
                    value: false,
                    isFeedback: false,
                    indexNumber: 0,
                  );
                }
              }).toList(),
              levels: levels.map((e) {
                try {
                  return DeviceLevel.fromMap(e);
                } catch (e) {
                  debugPrint('Error mapping device level: $e');
                  // Create a default DeviceLevel with minimal data
                  return DeviceLevel(
                    level: 0,
                    name: 'Error',
                  );
                }
              }).toList(),
            );

            devices.add(device);
          } catch (e) {
            debugPrint('Error creating device from map: $e');
          }
        } catch (e) {
          debugPrint('Error processing device: $e');
          // Continue to the next device instead of breaking the entire function
        }
      }

      return devices;
    } catch (e) {
      debugPrint('Error getting devices: $e');
      return [];
    }
  }

  Future<Device?> getDevice(int id) async {
    try {
      final db = await database;
      if (db == null) return null;

      final rows =
          await db.query(Keys.tableDevices, where: 'id = ?', whereArgs: [id]);
      if (rows.isEmpty) return null;

      try {
        final device = Device.fromMap(rows.first);

        // Optionally fetch child tables if needed:
        final results = await Future.wait([
          db.query(Keys.tableDeviceInputs, where: 'deviceId = ?', whereArgs: [id]),
          db.query(Keys.tableDeviceOutputs, where: 'deviceId = ?', whereArgs: [id]),
          db.query(Keys.tableDeviceStates, where: 'deviceId = ?', whereArgs: [id]),
          db.query(Keys.tableDeviceLevels, where: 'deviceId = ?', whereArgs: [id]),
        ]);

        final inputs = results[0] as List<Map<String, dynamic>>;
        final outputs = results[1] as List<Map<String, dynamic>>;
        final states = results[2] as List<Map<String, dynamic>>;
        final levels = results[3] as List<Map<String, dynamic>>;

        return device.copyWith(
          deviceInputs: inputs.map((e) {
            try {
              return DeviceInput.fromMap(e);
            } catch (e) {
              debugPrint('Error mapping device input: $e');
              return DeviceInput(
                id: 0,
                deviceId: id,
                inputId: 0,
                priority: 0,
                indexNumber: 0,
                description: 'Error',
              );
            }
          }).toList(),
          deviceOutputs: outputs.map((e) {
            try {
              return DeviceOutput.fromMap(e);
            } catch (e) {
              debugPrint('Error mapping device output: $e');
              return DeviceOutput(
                id: 0,
                deviceId: id,
                outputId: 0,
                priority: 0,
                indexNumber: 0,
                description: 'Error',
              );
            }
          }).toList(),
          states: states.map((e) {
            try {
              return DeviceState.fromMap(e);
            } catch (e) {
              debugPrint('Error mapping device state: $e');
              return DeviceState(
                id: 0,
                deviceId: id,
                level: 0,
                value: false,
                isFeedback: false,
                indexNumber: 0,
              );
            }
          }).toList(),
          levels: levels.map((e) {
            try {
              return DeviceLevel.fromMap(e);
            } catch (e) {
              debugPrint('Error mapping device level: $e');
              return DeviceLevel(
                level: 0,
                name: 'Error',
              );
            }
          }).toList(),
        );
      } catch (e) {
        debugPrint('Error processing device details: $e');
        return null;
      }
    } catch (e) {
      debugPrint('Error getting device: $e');
      return null;
    }
  }

  Future<int> updateDevice(Device device) async {
    final db = await database;
    if (db == null) return 0;

    final deviceMap = device.toMap();
    if (device.id == -1) {
      deviceMap.remove('id'); // Let DB auto-generate
    }
    deviceMap.remove('states');
    deviceMap.remove('levels');
    deviceMap.remove('deviceInputs');
    deviceMap.remove('deviceOutputs');
    deviceMap['modifiedOn'] = DateTime.now().millisecondsSinceEpoch;

    // Update the main device record
    final updatedCount = await db.update(
      Keys.tableDevices,
      deviceMap,
      where: 'id = ?',
      whereArgs: [device.id],
    );

    // Update related tables if necessary
    if (updatedCount > 0) {
      await _updateDeviceInputs(device.id, device.deviceInputs);
      await _updateDeviceOutputs(device.id, device.deviceOutputs);
      await _updateDeviceLevels(device.id, device.levels);
      await _updateDeviceStates(device.id, device.states);
    }

    return updatedCount;
  }

  Future<void> _updateDeviceInputs(
      int deviceId, List<DeviceInput> inputs) async {
    final db = await database;
    if (db == null) return;
    await db.delete(Keys.tableDeviceInputs,
        where: 'deviceId = ?', whereArgs: [deviceId]);
    for (final input in inputs) {
      await db.insert(Keys.tableDeviceInputs, {
        ...input.toMap(),
        'deviceId': deviceId,
      });
    }
  }

  Future<void> _updateDeviceOutputs(
      int deviceId, List<DeviceOutput> outputs) async {
    final db = await database;
    if (db == null) return;
    await db.delete(Keys.tableDeviceOutputs,
        where: 'deviceId = ?', whereArgs: [deviceId]);
    for (final output in outputs) {
      await db.insert(Keys.tableDeviceOutputs, {
        ...output.toMap(),
        'deviceId': deviceId,
      });
    }
  }

  Future<void> _updateDeviceLevels(
      int deviceId, List<DeviceLevel> levels) async {
    final db = await database;
    if (db == null) return;
    await db.delete(Keys.tableDeviceLevels,
        where: 'deviceId = ?', whereArgs: [deviceId]);
    for (final level in levels) {
      await db.insert(Keys.tableDeviceLevels, {
        ...level.toMap(),
        'deviceId': deviceId,
      });
    }
  }

  Future<void> _updateDeviceStates(
      int deviceId, List<DeviceState> states) async {
    final db = await database;
    if (db == null) return;
    await db.delete(Keys.tableDeviceStates,
        where: 'deviceId = ?', whereArgs: [deviceId]);
    for (final state in states) {
      await db.insert(Keys.tableDeviceStates, {
        ...state.toMap(),
        'deviceId': deviceId,
      });
    }
  }

  Future<int> insertDevice(Device device) async {
    final db = await database;
    if (db == null) return 0;

    final deviceMap = device.toMap();
    if (device.id == -1) {
      deviceMap.remove('id'); // Let DB auto-generate
    }
    deviceMap.remove('states');
    deviceMap.remove('levels');
    deviceMap.remove('deviceInputs');
    deviceMap.remove('deviceOutputs');

    final insertedId = await db.insert(Keys.tableDevices, deviceMap);

    // Insert inputs
    for (final input in device.deviceInputs) {
      await db.insert(Keys.tableDeviceInputs, {
        ...input.toMap(),
        'deviceId': insertedId,
      });
    }

    // Insert outputs
    for (final output in device.deviceOutputs) {
      await db.insert(Keys.tableDeviceOutputs, {
        ...output.toMap(),
        'deviceId': insertedId,
      });
    }

    // Insert states
    for (final state in device.states) {
      await db.insert(Keys.tableDeviceStates, {
        ...state.toMap(),
        'deviceId': insertedId,
      });
    }

    // Insert levels
    for (final level in device.levels) {
      await db.insert(Keys.tableDeviceLevels, {
        ...level.toMap(),
        'deviceId': insertedId,
      });
    }

    return insertedId;
  }

  Future<int> deleteDevice(int deviceId) async {
    final db = await database;
    if (db == null) return 0;

    return await db
        .delete(Keys.tableDevices, where: 'id = ?', whereArgs: [deviceId]);
  }

  //#endregion
}
