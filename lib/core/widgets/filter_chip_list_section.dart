import 'package:ecommerce/core/models/filter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FilterChipListSection extends StatefulWidget {
  const FilterChipListSection({
    super.key,
    required this.listItems,
    required this.initialSelectedId,
    required this.onSelected,
  });
  final List<FilterModel> listItems;
  final String? initialSelectedId;
  final Function(String selectedId) onSelected;
  @override
  State<FilterChipListSection> createState() => _FilterChipListSectionState();
}

class _FilterChipListSectionState extends State<FilterChipListSection> {
  late String? selectedId;
  @override
  void initState() {
    super.initState();
    selectedId = widget.initialSelectedId;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.listItems.length,
        itemBuilder: (context, index) {
          final category = widget.listItems[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(category.name),
              selected: selectedId == category.id,
              onSelected: (selected) {
                setState(() {
                  selectedId = category.id;
                });
                widget.onSelected(category.id);
              },
            ),
          );
        },
      ),
    );
  }
}
