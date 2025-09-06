enum SystemTables {
  collectionReason('st_motivocoleta');

  final String name;
  const SystemTables(this.name);

  static bool isSystemTable(String tableName) {
    return SystemTables.values.any((element) => element.name == tableName);
  }
}
