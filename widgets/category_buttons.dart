import 'package:flutter/material.dart';

class CategoryButtons extends StatelessWidget {
  final List<String> categories;
  final Function(String) onCategorySelected;

  CategoryButtons({required this.categories, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              onPressed: () => onCategorySelected(category),
              icon: Icon(Icons.category, color: Colors.white),
              label: Text(
                category,
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown, // Cambia el color del botón
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
