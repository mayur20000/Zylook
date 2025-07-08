class Outfit {
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  Outfit({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory Outfit.fromJson(Map<String, dynamic> json) {
    return Outfit(
      name: json['name'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['imageUrl'],
    );
  }
}