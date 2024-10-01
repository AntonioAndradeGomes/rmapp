enum StatusEnum {
  all(label: 'All'),
  alive(label: 'Alive'),
  dead(label: 'Dead'),
  unknown(label: 'Unknown');

  final String label;

  const StatusEnum({
    required this.label,
  });
}

enum SpecieEnum {
  all(label: 'All'),
  alien(label: 'Alien'),
  human(label: 'Human'),
  unknown(label: 'Unknown');

  final String label;

  const SpecieEnum({
    required this.label,
  });
}

enum GenderEnum {
  all(label: 'All'),
  female(label: 'Female'),
  male(label: 'Male'),
  genderless(label: 'Genderless'),
  unknown(label: 'Unknown');

  final String label;

  const GenderEnum({
    required this.label,
  });
}
