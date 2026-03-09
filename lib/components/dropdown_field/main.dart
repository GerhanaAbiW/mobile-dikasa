import 'package:flutter/material.dart';
import 'package:mobile_dikasa/core/constants/colors.dart';

class DropdownFieldOption<T> {
  const DropdownFieldOption({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final T value;
  final String label;
  final bool enabled;
}

class DropdownField<T> extends StatelessWidget {
  const DropdownField({
    super.key,
    required this.options,
    this.initialValue,
    this.onChanged,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.validator,
    this.onSaved,
    this.autovalidateMode,
    this.enabled = true,
    this.isRequired = false,
    this.isExpanded = true,
    this.menuMaxHeight,
    this.focusNode,
    this.icon,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),
    this.borderRadius = 12,
  });

  final List<DropdownFieldOption<T>> options;
  final T? initialValue;
  final ValueChanged<T?>? onChanged;

  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;

  final FormFieldValidator<T>? validator;
  final FormFieldSetter<T>? onSaved;
  final AutovalidateMode? autovalidateMode;

  final bool enabled;
  final bool isRequired;
  final bool isExpanded;

  final double? menuMaxHeight;
  final FocusNode? focusNode;
  final Widget? icon;

  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;

  final Color? backgroundColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;

  final EdgeInsetsGeometry contentPadding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final Color resolvedBackgroundColor = backgroundColor ?? AppColors.cEEEEEE;
    final Color resolvedBorderColor = borderColor ?? AppColors.cD9D9D9;
    final Color resolvedFocusedBorderColor =
        focusedBorderColor ?? AppColors.c097BC2;
    final Color resolvedErrorBorderColor = errorBorderColor ?? AppColors.c9D1414;

    final TextStyle resolvedTextStyle = textStyle ??
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        );

    final TextStyle resolvedLabelStyle = labelStyle ??
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        );

    final TextStyle resolvedHintStyle = hintStyle ??
        TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.c707070,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (label != null && label!.trim().isNotEmpty) ...<Widget>[
          RichText(
            text: TextSpan(
              text: label,
              style: resolvedLabelStyle,
              children: isRequired
                  ? const <InlineSpan>[
                      TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
                    ]
                  : const <InlineSpan>[],
            ),
          ),
          const SizedBox(height: 8),
        ],
        DropdownButtonFormField<T>(
          focusNode: focusNode,
          initialValue: initialValue,
          onChanged: enabled ? onChanged : null,
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: autovalidateMode,
          isExpanded: isExpanded,
          menuMaxHeight: menuMaxHeight,
          icon: icon ?? Icon(Icons.keyboard_arrow_down, color: AppColors.c707070),
          hint: hintText == null ? null : Text(hintText!, style: resolvedHintStyle),
          style: resolvedTextStyle,
          decoration: InputDecoration(
            helperText: helperText,
            errorText: errorText,
            filled: true,
            fillColor: resolvedBackgroundColor,
            contentPadding: contentPadding,
            enabledBorder: _buildBorder(resolvedBorderColor),
            focusedBorder: _buildBorder(resolvedFocusedBorderColor),
            disabledBorder: _buildBorder(resolvedBorderColor),
            errorBorder: _buildBorder(resolvedErrorBorderColor),
            focusedErrorBorder: _buildBorder(resolvedErrorBorderColor),
          ),
          items: options
              .map(
                (DropdownFieldOption<T> option) => DropdownMenuItem<T>(
                  value: option.value,
                  enabled: option.enabled,
                  child: Text(option.label, style: resolvedTextStyle),
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: color, width: 1),
    );
  }
}

