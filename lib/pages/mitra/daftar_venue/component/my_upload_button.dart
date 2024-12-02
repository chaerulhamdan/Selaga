import 'package:flutter/material.dart';

class MyUploadVenueButton extends StatelessWidget {
  final Function()? onTap;
  final String hint;
  const MyUploadVenueButton({
    super.key,
    required bool isSending,
    this.onTap,
    required this.hint,
  }) : _isSending = isSending;

  final bool _isSending;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(76, 76, 220, 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: _isSending
              ? const SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Text(
                  hint,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}
