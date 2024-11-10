import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../widgets/product_card.dart';

class ProductCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> products;

  const ProductCarousel({super.key, required this.products});

  @override
  _ProductCarouselState createState() => _ProductCarouselState();
}

class _ProductCarouselState extends State<ProductCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.products.length,
          itemBuilder: (context, index, realIndex) {
            final product = widget.products[index];
            final isHighlighted = _current == index; // Producto central
            return ProductCard(
              id: product['id'],
              title: product['title'],
              price: product['price'],
              imageUrl: product['imageUrl'],
              isHighlighted: isHighlighted,
            );
          },
          options: CarouselOptions(
            height: 450.0,
            autoPlay: true,
            enlargeCenterPage: true,
            // aspectRatio: 16 / 9,
            aspectRatio: 16 / 9,
            autoPlayInterval: const Duration(seconds: 6),
            autoPlayAnimationDuration: const Duration(milliseconds: 1000),
            viewportFraction: 0.6,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        // Indicadores del carrusel
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.products.map((product) {
            int index = widget.products.indexOf(product);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? const Color.fromRGBO(0, 0, 0, 0.9)
                    : const Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
