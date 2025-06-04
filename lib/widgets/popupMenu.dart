import 'package:flutter/material.dart';

class CustomPopupMenuButton extends StatelessWidget {
  final Function fns;

  const CustomPopupMenuButton({
    super.key,
    required this.fns,
  });

  final double _currentSliderValue = 5.0;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: Offset(0, 45), // SET THE (X,Y) POSITION
      iconSize: 30,
      icon: Icon(
        Icons.filter_alt_rounded, // CHOOSE YOUR CUSTOM ICON
        color: Colors.white,
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            enabled: false, // DISABLED THIS ITEM
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // WRITE YOUR CODE HERE
                Slider(
                  value: _currentSliderValue,
                  max: 100,
                  divisions: 5,
                  label: _currentSliderValue.round().toString(),
                  onChanged: (double value) {
                    fns(value);
                  },
                ),
              ],
            ),
          ),
        ];
      },
    );
  }
}
