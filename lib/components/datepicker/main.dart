import 'package:flutter/material.dart';
import 'package:mobile_dikasa/core/constants/colors.dart';

typedef DateTextBuilder = String Function(DateTime value);

class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    this.label,
    this.hintText = 'Pilih tanggal',
    this.helperText,
    this.errorText,
    this.initialValue,
    this.firstDate,
    this.lastDate,
    this.currentDate,
    this.onChanged,
    this.validator,
    this.onSaved,
    this.autovalidateMode,
    this.enabled = true,
    this.isRequired = false,
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
    this.dateTextBuilder,
  });

  final String? label;
  final String hintText;
  final String? helperText;
  final String? errorText;

  final DateTime? initialValue;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? currentDate;

  final ValueChanged<DateTime?>? onChanged;
  final FormFieldValidator<DateTime>? validator;
  final FormFieldSetter<DateTime>? onSaved;
  final AutovalidateMode? autovalidateMode;

  final bool enabled;
  final bool isRequired;
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
  final DateTextBuilder? dateTextBuilder;

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

    return FormField<DateTime>(
      initialValue: initialValue,
      validator: validator,
      onSaved: onSaved,
      autovalidateMode: autovalidateMode,
      builder: (FormFieldState<DateTime> state) {
        final DateTime now = DateTime.now();
        final DateTime minDate = firstDate ?? DateTime(now.year - 20, 1, 1);
        final DateTime maxDate = lastDate ?? DateTime(now.year + 20, 12, 31);

        final DateTime? selectedDate = state.value;
        final bool showHint = selectedDate == null;

        final String displayedText = selectedDate == null
            ? hintText
            : (dateTextBuilder?.call(selectedDate) ?? _defaultDateText(selectedDate));

        final String? effectiveErrorText = errorText ?? state.errorText;

        Future<void> onTapPicker() async {
          if (!enabled) {
            return;
          }

          DateTime initialPickerDate = selectedDate ?? currentDate ?? now;

          if (initialPickerDate.isBefore(minDate)) {
            initialPickerDate = minDate;
          }
          if (initialPickerDate.isAfter(maxDate)) {
            initialPickerDate = maxDate;
          }

          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: initialPickerDate,
            firstDate: minDate,
            lastDate: maxDate,
            currentDate: currentDate,
            helpText: label,
          );

          if (pickedDate == null) {
            return;
          }

          state.didChange(pickedDate);
          onChanged?.call(pickedDate);
        }

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
            InkWell(
              focusNode: focusNode,
              borderRadius: BorderRadius.circular(borderRadius),
              onTap: enabled ? onTapPicker : null,
              child: InputDecorator(
                isEmpty: selectedDate == null,
                decoration: InputDecoration(
                  enabled: enabled,
                  helperText: helperText,
                  errorText: effectiveErrorText,
                  filled: true,
                  fillColor: resolvedBackgroundColor,
                  contentPadding: contentPadding,
                  enabledBorder: _buildBorder(resolvedBorderColor),
                  focusedBorder: _buildBorder(resolvedFocusedBorderColor),
                  disabledBorder: _buildBorder(resolvedBorderColor),
                  errorBorder: _buildBorder(resolvedErrorBorderColor),
                  focusedErrorBorder: _buildBorder(resolvedErrorBorderColor),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        displayedText,
                        style: showHint ? resolvedHintStyle : resolvedTextStyle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    icon ?? Icon(Icons.calendar_today, color: AppColors.c707070),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: color, width: 1),
    );
  }

  String _defaultDateText(DateTime value) {
    final String day = value.day.toString().padLeft(2, '0');
    final String month = value.month.toString().padLeft(2, '0');
    final String year = value.year.toString();
    return '$day/$month/$year';
  }
}


