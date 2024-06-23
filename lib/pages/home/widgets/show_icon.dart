import 'package:flutter/material.dart';
import 'package:weather_app_riverpod/constants/constants.dart';

class ShowIcon extends StatelessWidget {
  const ShowIcon({super.key, required this.icon});

  final String icon;

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/images/loading.gif',
      image: 'https://$kIconHost/img/wn/$icon@4x.png',
      height: 96,
      width: 96,
      imageErrorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/no_image_icon.png',
        height: 96,
        width: 96,
      ),
    );
  }
}
