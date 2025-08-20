import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constant/colors.dart';
import '../constant/sizes.dart';

class InformationSlider extends ConsumerStatefulWidget {
  const InformationSlider({
    super.key,
    required this.imageList,
    required this.isHaveInformation,
  });

  final List<String> imageList;
  final bool isHaveInformation;

  @override
  ConsumerState<InformationSlider> createState() => _InformationSlider();
}

class _InformationSlider extends ConsumerState<InformationSlider> {
  int _currentIndex = 0;
  final _controller = CarouselSliderController();
  late List<String> _informationHomeScreenImage;

  @override
  void initState() {
    super.initState();
    _informationHomeScreenImage = widget.imageList;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {},
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Carousel Slider
              CarouselSlider(
                items: _informationHomeScreenImage
                    .map(
                      (item) => ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(12),
                        child: Image.asset(item, width: 350, fit: BoxFit.cover),
                      ),
                    )
                    .toList(),
                carouselController: _controller,
                options: CarouselOptions(
                  viewportFraction: 1.0,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayInterval: const Duration(seconds: 5),
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),

              if (widget.isHaveInformation)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsetsGeometry.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadiusGeometry.only(
                        bottomRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'title',
                          textAlign: TextAlign.center,
                          style: textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: TSizes.smallSpace / 2),
                        Text(
                          'author',
                          textAlign: TextAlign.center,
                          style: textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: TSizes.smallSpace),
        // Indikator Titik (Dots)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _informationHomeScreenImage.asMap().entries.map((entry) {
            final index = entry.key;
            return GestureDetector(
              onTap: () => _controller.animateToPage(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: _currentIndex == index ? 24.0 : 8.0,
                // Lebar berubah saat aktif
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: TColors.primaryColor.withOpacity(
                    _currentIndex == index ? 1 : 0.5,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
