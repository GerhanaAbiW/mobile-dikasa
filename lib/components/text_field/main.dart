import 'package:flutter/material.dart';
import 'package:mobile_dikasa/core/constants/colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.onFieldSubmitted,
    this.autovalidateMode,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.enabled = true,
    this.readOnly = false,
    this.isRequired = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.prefixIcon,
    this.suffixIcon,
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
  }) : assert(
         controller == null || initialValue == null,
         'Cannot provide both controller and initialValue.',
       );

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;

  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onFieldSubmitted;
  final AutovalidateMode? autovalidateMode;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;

  final bool enabled;
  final bool readOnly;
  final bool isRequired;
  final bool obscureText;

  final int maxLines;
  final int? minLines;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

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
    final Color resolvedErrorBorderColor =
        errorBorderColor ?? AppColors.c9D1414;

    final TextStyle resolvedTextStyle =
        textStyle ??
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        );

    final TextStyle resolvedLabelStyle =
        labelStyle ??
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        );

    final TextStyle resolvedHintStyle =
        hintStyle ??
        TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.c707070.withAlpha(140),
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
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                    ]
                  : const <InlineSpan>[],
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          initialValue: initialValue,
          validator: validator,
          onChanged: onChanged,
          onSaved: onSaved,
          onFieldSubmitted: onFieldSubmitted,
          autovalidateMode: autovalidateMode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          enabled: enabled,
          readOnly: readOnly,
          obscureText: obscureText,
          maxLines: maxLines,
          minLines: minLines,
          style: resolvedTextStyle,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: resolvedHintStyle,
            helperText: helperText,
            errorText: errorText,
            filled: true,
            fillColor: resolvedBackgroundColor,
            contentPadding: contentPadding,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            enabledBorder: _buildBorder(resolvedBorderColor),
            focusedBorder: _buildBorder(resolvedFocusedBorderColor),
            disabledBorder: _buildBorder(resolvedBorderColor),
            errorBorder: _buildBorder(resolvedErrorBorderColor),
            focusedErrorBorder: _buildBorder(resolvedErrorBorderColor),
          ),
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
