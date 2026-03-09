import 'package:flutter/material.dart';
import 'package:mobile_dikasa/core/constants/colors.dart';

class SearchableSelectOption<T> {
  const SearchableSelectOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.enabled = true,
  });

  final T value;
  final String label;
  final String? subtitle;
  final bool enabled;
}

class SearchableSelectField<T> extends StatelessWidget {
  const SearchableSelectField({
    super.key,
    required this.options,
    this.initialValue,
    this.onChanged,
    this.label,
    this.hintText = 'Pilih data',
    this.helperText,
    this.errorText,
    this.validator,
    this.onSaved,
    this.autovalidateMode,
    this.enabled = true,
    this.isRequired = false,
    this.searchHintText = 'Cari data',
    this.emptySearchText = 'Data tidak ditemukan',
    this.sheetTitle,
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

  final List<SearchableSelectOption<T>> options;
  final T? initialValue;
  final ValueChanged<T?>? onChanged;

  final String? label;
  final String hintText;
  final String? helperText;
  final String? errorText;

  final FormFieldValidator<T>? validator;
  final FormFieldSetter<T>? onSaved;
  final AutovalidateMode? autovalidateMode;

  final bool enabled;
  final bool isRequired;

  final String searchHintText;
  final String emptySearchText;
  final String? sheetTitle;

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

    return FormField<T>(
      initialValue: initialValue,
      validator: validator,
      onSaved: onSaved,
      autovalidateMode: autovalidateMode,
      builder: (FormFieldState<T> state) {
        final SearchableSelectOption<T>? selectedOption = _findOptionByValue(
          state.value,
        );

        final bool showHint = selectedOption == null;
        final String displayedText = selectedOption?.label ?? hintText;
        final String? effectiveErrorText = errorText ?? state.errorText;

        Future<void> onTapSelector() async {
          if (!enabled) {
            return;
          }

          final SearchableSelectOption<T>? selected =
              await _showSearchBottomSheet(context);

          if (selected == null) {
            return;
          }

          state.didChange(selected.value);
          onChanged?.call(selected.value);
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
              onTap: enabled ? onTapSelector : null,
              child: InputDecorator(
                isEmpty: selectedOption == null,
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
                    icon ?? Icon(Icons.search, color: AppColors.c707070),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  SearchableSelectOption<T>? _findOptionByValue(T? value) {
    for (final SearchableSelectOption<T> option in options) {
      if (option.value == value) {
        return option;
      }
    }
    return null;
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: color, width: 1),
    );
  }

  Future<SearchableSelectOption<T>?> _showSearchBottomSheet(
    BuildContext context,
  ) {
    return showModalBottomSheet<SearchableSelectOption<T>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cFFFFFF,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext sheetContext) {
        String query = '';

        return StatefulBuilder(
          builder:
              (
                BuildContext context,
                void Function(void Function()) setSheetState,
              ) {
                final String normalizedQuery = query.trim().toLowerCase();
                final List<SearchableSelectOption<T>> filteredOptions = options
                    .where((SearchableSelectOption<T> option) {
                      final String searchableText =
                          '${option.label} ${option.subtitle ?? ''}'
                              .toLowerCase();
                      return searchableText.contains(normalizedQuery);
                    })
                    .toList(growable: false);

                return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      16,
                      16,
                      16 + MediaQuery.viewInsetsOf(context).bottom,
                    ),
                    child: SizedBox(
                      height: 420,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (sheetTitle != null &&
                              sheetTitle!.trim().isNotEmpty) ...<Widget>[
                            Text(
                              sheetTitle!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          TextField(
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: searchHintText,
                              filled: true,
                              fillColor: AppColors.cF8F8F8,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              enabledBorder: _buildBorder(AppColors.cD9D9D9),
                              focusedBorder: _buildBorder(AppColors.c097BC2),
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppColors.c707070,
                              ),
                            ),
                            onChanged: (String value) {
                              setSheetState(() {
                                query = value;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: filteredOptions.isEmpty
                                ? Center(
                                    child: Text(
                                      emptySearchText,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.c707070,
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: filteredOptions.length,
                                    separatorBuilder: (_, __) => Divider(
                                      height: 1,
                                      color: AppColors.cEDEDED,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                          final SearchableSelectOption<T>
                                          option = filteredOptions[index];

                                          return ListTile(
                                            enabled: option.enabled,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 4,
                                                  vertical: 2,
                                                ),
                                            title: Text(
                                              option.label,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            subtitle: option.subtitle == null
                                                ? null
                                                : Text(
                                                    option.subtitle!,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors.c707070,
                                                    ),
                                                  ),
                                            onTap: option.enabled
                                                ? () => Navigator.of(
                                                    sheetContext,
                                                  ).pop(option)
                                                : null,
                                          );
                                        },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
        );
      },
    );
  }
}
