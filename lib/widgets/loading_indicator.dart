import 'package:flutter/material.dart';

/// A Widget wrapping a [CircularProgressIndicator] in [Center].
class LoadingIndicator extends StatelessWidget {
  final Color color;

  const LoadingIndicator(this.color);

  @override
  Widget build(BuildContext context) => Center(
          child: Padding(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        padding: const EdgeInsets.all(16.0),
      ));
}

class CircularLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22.0,
      width: 22.0,
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xffff2d55)),
      ),
    );
  }
}
