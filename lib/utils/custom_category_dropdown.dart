import 'package:flutter/material.dart';
import 'package:store/constants/categories.dart';
import 'package:store/theme/app_colors.dart';

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
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: showIcon
            ? Icon(Icons.category_rounded, color: AppColors.textPrimary)
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
            color: AppColors.textPrimary,
          ),
          style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
          dropdownColor: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          items: productCategories.map((category) {
            return DropdownMenuItem<String>(
              value: category.value,
              child: Row(
                children: [
                  Icon(category.icon, size: 20, color: AppColors.textPrimary),
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
