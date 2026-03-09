import 'package:flutter/material.dart';
import 'package:mobile_dikasa/core/constants/colors.dart';

class TableFieldColumn<T> {
  const TableFieldColumn({
    required this.title,
    required this.valueBuilder,
    this.width = 160,
    this.headerTextAlign = TextAlign.left,
    this.cellTextAlign = TextAlign.left,
    this.headerTextStyle,
    this.cellTextStyle,
  });

  final String title;
  final String Function(T row) valueBuilder;
  final double width;
  final TextAlign headerTextAlign;
  final TextAlign cellTextAlign;
  final TextStyle? headerTextStyle;
  final TextStyle? cellTextStyle;
}

class TableField<T> extends StatelessWidget {
  const TableField({
    super.key,
    required this.columns,
    required this.rows,
    this.label,
    this.emptyText = 'Data belum tersedia',
    this.onRowTap,
    this.headerBackgroundColor,
    this.rowBackgroundColor,
    this.borderColor,
    this.headerTextStyle,
    this.cellTextStyle,
    this.labelStyle,
    this.horizontalMargin = 12,
    this.columnSpacing = 8,
    this.rowHeight = 52,
    this.headingRowHeight = 48,
    this.borderRadius = 12,
  });

  final List<TableFieldColumn<T>> columns;
  final List<T> rows;
  final String? label;
  final String emptyText;
  final ValueChanged<T>? onRowTap;

  final Color? headerBackgroundColor;
  final Color? rowBackgroundColor;
  final Color? borderColor;

  final TextStyle? headerTextStyle;
  final TextStyle? cellTextStyle;
  final TextStyle? labelStyle;

  final double horizontalMargin;
  final double columnSpacing;
  final double rowHeight;
  final double headingRowHeight;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final Color resolvedHeaderBackground =
        headerBackgroundColor ?? AppColors.cF8F8F8;
    final Color resolvedRowBackground = rowBackgroundColor ?? AppColors.cFFFFFF;
    final Color resolvedBorderColor = borderColor ?? AppColors.cD9D9D9;

    final TextStyle resolvedHeaderTextStyle =
        headerTextStyle ??
        const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        );

    final TextStyle resolvedCellTextStyle =
        cellTextStyle ??
        const TextStyle(
          fontSize: 13,
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

    final double minTableWidth = columns.fold<double>(0, (
      double sum,
      TableFieldColumn<T> col,
    ) {
      return sum + col.width;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (label != null && label!.trim().isNotEmpty) ...<Widget>[
          Text(label!, style: resolvedLabelStyle),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: resolvedRowBackground,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: resolvedBorderColor),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: rows.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        emptyText,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.c707070,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: minTableWidth),
                      child: DataTable(
                        horizontalMargin: horizontalMargin,
                        columnSpacing: columnSpacing,
                        headingRowHeight: headingRowHeight,
                        dataRowMinHeight: rowHeight,
                        dataRowMaxHeight: rowHeight,
                        headingRowColor: WidgetStatePropertyAll<Color>(
                          resolvedHeaderBackground,
                        ),
                        dataRowColor: WidgetStatePropertyAll<Color>(
                          resolvedRowBackground,
                        ),
                        dividerThickness: 0.6,
                        columns: columns
                            .map(
                              (TableFieldColumn<T> column) => DataColumn(
                                label: SizedBox(
                                  width: column.width,
                                  child: Align(
                                    alignment: _toAlignment(
                                      column.headerTextAlign,
                                    ),
                                    child: Text(
                                      column.title,
                                      textAlign: column.headerTextAlign,
                                      style:
                                          column.headerTextStyle ??
                                          resolvedHeaderTextStyle,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(growable: false),
                        rows: rows
                            .map(
                              (T row) => DataRow(
                                onSelectChanged: onRowTap == null
                                    ? null
                                    : (_) => onRowTap!(row),
                                cells: columns
                                    .map(
                                      (TableFieldColumn<T> column) => DataCell(
                                        SizedBox(
                                          width: column.width,
                                          child: Align(
                                            alignment: _toAlignment(
                                              column.cellTextAlign,
                                            ),
                                            child: Text(
                                              column.valueBuilder(row),
                                              textAlign: column.cellTextAlign,
                                              style:
                                                  column.cellTextStyle ??
                                                  resolvedCellTextStyle,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(growable: false),
                              ),
                            )
                            .toList(growable: false),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Alignment _toAlignment(TextAlign textAlign) {
    switch (textAlign) {
      case TextAlign.center:
        return Alignment.center;
      case TextAlign.right:
      case TextAlign.end:
        return Alignment.centerRight;
      case TextAlign.left:
      case TextAlign.start:
      case TextAlign.justify:
        return Alignment.centerLeft;
    }
  }
}
