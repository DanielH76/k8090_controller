import 'package:flutter/material.dart';

class AsyncFilledButton extends StatefulWidget {
  final Future future;
  final Widget child;
  final Color foregroundColor;
  final Color backgroundColor;
  const AsyncFilledButton({
    super.key,
    required this.future,
    required this.child,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  @override
  State<AsyncFilledButton> createState() => _AsyncFilledButtonState();
}

class _AsyncFilledButtonState extends State<AsyncFilledButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(widget.foregroundColor),
        backgroundColor: WidgetStatePropertyAll(widget.backgroundColor),
      ),
      onPressed: _action,
      child: switch (loading) {
        true => SizedBox(
          height: 10,
          width: 25,
          child: CircularProgressIndicator(color: Colors.white),
        ),
        false => widget.child,
      },
    );
  }

  Future<void> _action() async {
    if (!loading) {
      setState(() => loading = true);
      await widget.future;
      setState(() => loading = false);
    }
  }
}
