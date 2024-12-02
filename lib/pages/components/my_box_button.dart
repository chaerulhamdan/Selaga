import 'package:flutter/material.dart';

class MyBoxButton extends StatelessWidget {
  final String buttonText;
  final Function()? onTap;
  final bool? tapped;
  const MyBoxButton({
    required this.onTap,
    required this.buttonText,
    required this.tapped,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return tapped == false
        ?  InkWell(
            onTap: onTap,
            child: Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.grey[350], borderRadius: BorderRadius.circular(8)),
              child: Center(
                  child: Text(buttonText,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  )
              ),
            ),
          )
        : InkWell(
            onTap: onTap,
            child: Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  width: 2,
                  color: const Color.fromRGBO(76, 76, 220, 1)
                )
              ),
              child: Center(
                  child: Text(buttonText,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  )
              ),
            ),
          );
  }
}

