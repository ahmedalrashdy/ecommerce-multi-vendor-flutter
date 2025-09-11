import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsSwitchTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  bool value;
  final ValueChanged<bool> onChanged;
  final Color? iconColor;

  SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.iconColor,
  });

  @override
  State<SettingsSwitchTile> createState() => _SettingsSwitchTileState();
}

class _SettingsSwitchTileState extends State<SettingsSwitchTile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      leading: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: widget.iconColor ?? theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          widget.icon,
          color: widget.iconColor != null
              ? theme.colorScheme.onError
              : theme.colorScheme.primary,
          size: 24,
        ),
      ),
      title: Text(
        widget.title,
        style:
            theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: widget.subtitle != null
          ? Text(
              widget.subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            )
          : null,
      trailing: Switch.adaptive(
        value: widget.value,
        onChanged: widget.onChanged,
      ),
      onTap: () {
        widget.onChanged(!widget.value);
      }, // Allow tapping the whole tile to toggle
    );
  }
}
