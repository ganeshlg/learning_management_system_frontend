import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context, {String message = 'Please wait...'}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Flexible(
              child: Text(message),
            ),
          ],
        ),
      ),
    ),
  );
}