import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardTextField extends StatelessWidget {
  final String title;
  final bool bold;
  final String hint;
  final TextInputType textInputType;
  final List<TextInputFormatter> inputFormatters;
  final FormFieldValidator<String> validator;
  final TextAlign textAlign;
  final FocusNode focusNode;
  final Function(String) onSubmitted;
  final Function(String) onChanged;

  CardTextField(
      {this.title,
      this.bold = false,
      this.hint,
      this.textInputType,
      this.inputFormatters,
      this.validator,
      this.textAlign = TextAlign.start,
      this.focusNode,
      this.onSubmitted,
      this.onChanged
      });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${this.title ?? ''}',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          TextFormField(
            style: TextStyle(
                color: Colors.white,
                fontWeight: this.bold ? FontWeight.bold : FontWeight.w500),
            decoration: InputDecoration(
              hintText: this.hint,
              hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
              border: InputBorder.none,
              isDense: true,
            ),
            cursorColor: Colors.white,
            keyboardType: this.textInputType,
            inputFormatters: this.inputFormatters,
            validator: this.validator,
            textAlign: this.textAlign,
            focusNode: this.focusNode,
            onChanged: this.onChanged,
            onFieldSubmitted: this.onSubmitted,
          )
        ],
      ),
    );
  }
}
