class LevelStateDefinition {
  int state;
  int portId;
  bool value;
  String? name;

  LevelStateDefinition({
    required this.state,
    required this.portId,
    required this.value,
    this.name,
  });
}
