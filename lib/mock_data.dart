import 'package:flutter_best_practices/models/product.dart';

class MockData {
  static List<Product> products = [];

  /// When [minimal] is true, only the values that are always present on the server side are generated,
  /// like US States and Project Types.
  static void generate() {
    _generateProducts();
  }

  static void _generateProducts() {
    products = [
      Product(
        id: 1,
        name: 'Premium Interior Paint',
        description:
            'High-quality interior paint with excellent coverage and durability.',
        avgRating: 4.5,
      ),
      Product(
        id: 2,
        name: 'Eco-Friendly Exterior Paint',
        description:
            'Low-VOC exterior paint that is safe for the environment and provides long-lasting protection.',
      ),
      Product(
        id: 3,
        name: 'Professional Paint Brush Set',
        description:
            'Set of high-quality paint brushes for smooth application and precision.',
      ),
      Product(
        id: 4,
        name: 'Heavy-Duty Drop Cloths',
        description:
            'Durable drop cloths to protect floors and furniture during painting projects.',
      ),
    ];
  }
}
