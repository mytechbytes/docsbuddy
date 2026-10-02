import 'package:docsbuddy/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

/// [AppTextField] with the controller it needs, owned and disposed with it, so
/// use cases can place a working field without managing one.
class DemoTextField extends StatefulWidget {
  const DemoTextField({
    super.key,
    required this.label,
    this.hint,
    this.text = '',
    this.errorText,
    this.icon,
    this.obscure = false,
    this.keyboardType,
  });

  final String label;
  final String? hint;
  final String text;
  final String? errorText;
  final IconData? icon;
  final bool obscure;
  final TextInputType? keyboardType;

  @override
  State<DemoTextField> createState() => _DemoTextFieldState();
}

class _DemoTextFieldState extends State<DemoTextField> {
  late final _controller = TextEditingController(text: widget.text);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      controller: _controller,
      hint: widget.hint,
      errorText: widget.errorText,
      icon: widget.icon,
      obscure: widget.obscure,
      keyboardType: widget.keyboardType,
    );
  }
}
