import 'dart:ui';

class ButtonDefinition {
  final String id;
  final String name;
  final String functionDescription;

  const ButtonDefinition({
    required this.id,
    required this.name,
    required this.functionDescription,
  });
}

class ButtonLayout {
  final ButtonDefinition definition;
  final Path hitArea;
  final Offset centerPoint;

  const ButtonLayout({
    required this.definition,
    required this.hitArea,
    required this.centerPoint,
  });
}
