import 'package:flutter/material.dart';
import '../palettes/app_colors.dart' hide Colors;

class NotificationModal {
  void showNotificModal(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        right: 10,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            decoration:  BoxDecoration(
                color: colors.umber,
                borderRadius: BorderRadius.circular(10)
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.notifications_active_outlined, color: Colors.white,),
                const SizedBox(width: 10),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 30,),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 15),
                  onPressed: () {
                    overlayEntry.remove();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(minutes: 1), () {
      overlayEntry.remove();
    });
  }
}
final NotificationModal notificationModal = new NotificationModal();