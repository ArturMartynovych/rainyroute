import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomErrorMessage extends StatelessWidget {
  const CustomErrorMessage({super.key, required this.errorText});

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          height: 90,
          decoration: const BoxDecoration(
            color: Color(0xFFC72C41),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 48),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'O, cholera!',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                      child: Text(
                        errorText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
            ),
            child: Stack(
              children: [
                SvgPicture.asset(
                  'assets/svg/bubbles.svg',
                  height: 48,
                  width: 40,
                  color: const Color(0xFF801336),
                  colorBlendMode: BlendMode.srcIn,
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: -22,
          left: 0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                'assets/svg/pin2.svg',
                height: 45,
                color: const Color(0xFF801336),
                colorBlendMode: BlendMode.srcIn,
              ),
              Positioned(
                top: 10,
                left: 12,
                child: SvgPicture.asset(
                  'assets/svg/close3.svg',
                  height: 20,
                  color: const Color(0xFF801336),
                  colorBlendMode: BlendMode.srcIn,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
