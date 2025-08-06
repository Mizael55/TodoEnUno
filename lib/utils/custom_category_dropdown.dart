import 'package:flutter/material.dart';
import 'package:store/constants/categories.dart';

class CustomCategoryDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final String label;
  final bool showIcon;

  const CustomCategoryDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: showIcon
            ? Icon(
                Icons.category_rounded,
                color: colors.primary,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down_rounded,
            color: colors.onSurface.withOpacity(0.6),
          ),
          style: theme.textTheme.bodyLarge,
          dropdownColor: colors.surface,
          borderRadius: BorderRadius.circular(12),
          items: productCategories.map((category) {
            return DropdownMenuItem<String>(
              value: category.value,
              child: Row(
                children: [
                  Icon(
                    category.icon,
                    size: 20,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(category.label),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}