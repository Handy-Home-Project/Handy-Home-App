import 'package:flutter/material.dart';

class SelectItemBottomSheet<T> extends StatelessWidget {
  const SelectItemBottomSheet({super.key, required this.title, required this.itemList});

  final String title;

  final Map<String, T> itemList;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.close),
              ),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              SizedBox(width: 20)
            ],
          ),
          SizedBox(height: 20),
          ...itemList.entries.map((e) => _buildSortItem(context, e.key, e.value))
        ],
      ),
    );
  }

  Widget _buildSortItem(BuildContext context, String title, T item) => GestureDetector(
    onTap: () => Navigator.of(context).pop(item),
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      child: Text(title, style: Theme.of(context).textTheme.bodyMedium),
    ),
  );
}
