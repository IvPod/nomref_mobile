import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final Widget child;
  final Function onTap;

  const CustomButton({
    this.width = 47,
    @required this.child,
    @required this.onTap,
  });

  factory CustomButton.withIcon({IconData icon, Function onTap}) =>
      CustomButton(child: Icon(icon), onTap: onTap);

  factory CustomButton.withText(
    BuildContext context, {
    double width = 130,
    String text,
    Color textColor,
    Function onTap,
  }) =>
      CustomButton(
        width: width,
        child: _buildTextWidget(context, text, textColor),
        onTap: onTap,
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 47,
        width: width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              spreadRadius: 1,
              offset: Offset(0, 2),
              color: Theme.of(context).shadowColor,
            ),
          ],
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: child,
      ),
    );
  }
}

Widget _buildTextWidget(
  BuildContext context,
  String text,
  Color textColor,
) {
  return Align(
    alignment: Alignment.center,
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor ?? Theme.of(context).primaryColor,
      ),
    ),
  );
}
