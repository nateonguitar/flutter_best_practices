import 'package:flutter/material.dart';
import 'package:flutter_best_practices/themes/core_theme.dart';

class ConfirmDialog extends StatefulWidget {
  final Widget title;
  final Widget body;
  final Axis responseButtonsFlexDirection;
  final VoidCallback onConfirmPressed;
  final String? confirmText;
  final VoidCallback? onCancelPressed;
  final String? cancelText;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.body,
    this.responseButtonsFlexDirection = Axis.horizontal,
    required this.onConfirmPressed,
    this.confirmText,
    this.onCancelPressed,
    this.cancelText,
  });

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    final widthConstraint = BoxConstraints(
      maxWidth: CoreTheme.dialogMaxWidth,
    );
    return SimpleDialog(
      title: widget.title,
      titlePadding: CoreTheme.dialogTitlePadding,
      contentPadding: CoreTheme.dialogContentPadding,
      children: [
        ConstrainedBox(constraints: widthConstraint, child: widget.body),
        const SizedBox(height: 20.0),
        ConstrainedBox(
          constraints: widthConstraint,
          child: Flex(
            direction: widget.responseButtonsFlexDirection,
            mainAxisAlignment: switch (widget.responseButtonsFlexDirection) {
              Axis.horizontal => MainAxisAlignment.end,
              Axis.vertical => MainAxisAlignment.center,
            },
            spacing: switch (widget.responseButtonsFlexDirection) {
              Axis.horizontal => CoreTheme.betweenButtonsSpacing.width,
              Axis.vertical => CoreTheme.betweenButtonsSpacing.height,
            },
            children: switch (widget.responseButtonsFlexDirection) {
              Axis.horizontal => [
                _cancelButton(),
                _confirmButton(),
              ],
              Axis.vertical => [
                _confirmButton(),
                _cancelButton(),
              ],
            },
          ),
        ),
      ],
    );
  }

  Widget _confirmButton() {
    final confirmText = widget.confirmText ?? 'Ok';
    return ElevatedButton(
      key: const ValueKey('confirm|button|confirm'),
      child: Text(confirmText),
      onPressed: () {
        Navigator.of(context).pop();
        widget.onConfirmPressed();
      },
    );
  }

  Widget _cancelButton() {
    final cancelText = widget.cancelText ?? 'Cancel';
    return TextButton(
      key: const ValueKey('confirm|button|cancel'),
      child: Text(cancelText),
      onPressed: () {
        Navigator.of(context).pop();
        if (widget.onCancelPressed != null) {
          widget.onCancelPressed!();
        }
      },
    );
  }
}
