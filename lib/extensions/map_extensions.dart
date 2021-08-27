extension InvertMap on Map {
  Map getInverted() {
    List<MapEntry> entries = <MapEntry>[];
    this.forEach((key, value) {
      entries.add(MapEntry(value, key));
    });
    return Map.fromEntries(entries);
  }
}
