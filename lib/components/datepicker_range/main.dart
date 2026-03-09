import 'package:flutter/material.dart';
import 'package:mobile_dikasa/core/constants/colors.dart';

typedef DateRangeTextBuilder = String Function(DateTimeRange value);

class DateRangePickerField extends StatelessWidget {
  const DateRangePickerField({
    super.key,
    this.label,
    this.hintText = 'Pilih rentang tanggal',
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
    this.rangeTextBuilder,
  });

  final String? label;
  final String hintText;
  final String? helperText;
  final String? errorText;

  final DateTimeRange? initialValue;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? currentDate;

  final ValueChanged<DateTimeRange?>? onChanged;
  final FormFieldValidator<DateTimeRange>? validator;
  final FormFieldSetter<DateTimeRange>? onSaved;
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
  final DateRangeTextBuilder? rangeTextBuilder;

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
          color: AppColors.c707070,
        );

    return FormField<DateTimeRange>(
      initialValue: initialValue,
      validator: validator,
      onSaved: onSaved,
      autovalidateMode: autovalidateMode,
      builder: (FormFieldState<DateTimeRange> state) {
        final DateTime now = DateTime.now();
        final DateTime minDate = firstDate ?? DateTime(now.year - 20, 1, 1);
        final DateTime maxDate = lastDate ?? DateTime(now.year + 20, 12, 31);

        final DateTimeRange? selectedRange = state.value;
        final bool showHint = selectedRange == null;

        final String displayedText = selectedRange == null
            ? hintText
            : (rangeTextBuilder?.call(selectedRange) ??
                  _defaultRangeText(selectedRange));

        final String? effectiveErrorText = errorText ?? state.errorText;

        Future<void> onTapPicker() async {
          if (!enabled) {
            return;
          }

          DateTimeRange? initialRange = selectedRange;

          if (initialRange != null) {
            DateTime start = initialRange.start;
            DateTime end = initialRange.end;

            if (start.isBefore(minDate)) {
              start = minDate;
            }
            if (end.isAfter(maxDate)) {
              end = maxDate;
            }
            if (end.isBefore(start)) {
              end = start;
            }

            initialRange = DateTimeRange(start: start, end: end);
          }

          final DateTimeRange? pickedRange = await showDateRangePicker(
            context: context,
            firstDate: minDate,
            lastDate: maxDate,
            currentDate: currentDate,
            initialDateRange: initialRange,
            helpText: label,
          );

          if (pickedRange == null) {
            return;
          }

          state.didChange(pickedRange);
          onChanged?.call(pickedRange);
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
                isEmpty: selectedRange == null,
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
                    icon ?? Icon(Icons.date_range, color: AppColors.c707070),
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

  String _defaultRangeText(DateTimeRange value) {
    final String start = _defaultDateText(value.start);
    final String end = _defaultDateText(value.end);
    return '$start - $end';
  }

  String _defaultDateText(DateTime value) {
    final String day = value.day.toString().padLeft(2, '0');
    final String month = value.month.toString().padLeft(2, '0');
    final String year = value.year.toString();
    return '$day/$month/$year';
  }
}
