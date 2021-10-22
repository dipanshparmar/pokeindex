// model for the pokemon
class Pokemon {
  final int id;
  final String name;
  final List types;
  final String? imageUrl;
  final int hp;
  final int attack;
  final int defense;
  final int specialAttack;
  final int specialDefense;
  final int speed;
  final int weight;
  final List abilities;
  final List moves;
  final List heldItems;

  Pokemon({
    required this.id,
    required this.name,
    required this.types,
    required this.imageUrl,
    required this.hp,
    required this.attack,
    required this.defense,
    required this.specialAttack,
    required this.specialDefense,
    required this.speed,
    required this.weight,
    required this.abilities,
    required this.moves,
    required this.heldItems,
  });
}
