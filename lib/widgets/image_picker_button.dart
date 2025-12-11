import 'package:flutter/material.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';

class ImagePickerButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? btnColor;

  const ImagePickerButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.btnColor,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoCard(
      splashColor: Color.fromRGBO(161, 217, 155, 1.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            btnColor ?? Color.fromRGBO(116, 196, 118, 1.0),
            btnColor ?? Color.fromRGBO(65, 171, 93, 1.0),
            btnColor ?? Color.fromRGBO(35, 139, 69, 1.0),
            btnColor ?? Color.fromRGBO(0, 90, 50, 1.0),
          ],
        ),
      ),
      elevation: 8.0,
      radius: const BorderRadius.all(Radius.circular(30.0)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(0),
      onPressed: onPressed,
      child: SizedBox(
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
