import 'package:flutter/material.dart';
import 'package:comicvault/models/sort_option.dart';

class SortButton extends StatelessWidget {
  final SortOption selectedSort;
  final ValueChanged<SortOption> onSortSelected;

  const SortButton({
    super.key,
    required this.selectedSort,
    required this.onSortSelected,
  });

  String _getSortLabel(SortOption option) {
    switch (option) {
      case SortOption.alphabetical:
        return "Alphabetical (A–Z)";
      case SortOption.releaseDate:
        return "Release Date (Newest)";
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<SortOption>(
      value: selectedSort,
      onChanged: (SortOption? newValue) {
        if (newValue != null) onSortSelected(newValue);
      },
      icon: const Icon(Icons.arrow_drop_down),
      underline: const SizedBox(),
      items:
          SortOption.values.map((option) {
            return DropdownMenuItem<SortOption>(
              value: option,
              child: Text(_getSortLabel(option)),
            );
          }).toList(),
    );
  }
}
