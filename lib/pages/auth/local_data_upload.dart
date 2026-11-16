import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grade_app/data/session.dart';

// After signing in, offer to move grades saved in local mode to the account
Future<void> offerLocalDataUpload(BuildContext context) async {
  if (!await Session.local.hasData() || !context.mounted) return;

  final upload = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text("Upload grades from this device?"),
      content: const Text(
          "You have grades saved on this device. Upload them to your account "
          "so they sync? If you skip, they stay on this device only."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Skip"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text("Upload"),
        ),
      ],
    ),
  );
  if (upload != true) return;

  try {
    await Session.repository.importAll(
      await Session.local.getSemesters(),
      await Session.local.getCourses(),
    );
    await Session.local.clear();
    Fluttertoast.showToast(msg: "Grades uploaded to your account");
  } catch (e) {
    log('Upload failed: $e');
    Fluttertoast.showToast(
        msg: "Upload failed, your grades are still on this device");
  }
}
