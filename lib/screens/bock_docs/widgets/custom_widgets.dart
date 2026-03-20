// widgets/custom_widgets.dart
import 'package:flutter/material.dart';

// ==================== CUSTOM APP BAR ====================
class BockDocsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;

  const BockDocsAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appBarBg = theme.appBarTheme.backgroundColor ?? colorScheme.surface;
    final appBarFg =
        theme.appBarTheme.foregroundColor ?? colorScheme.onSurface;
    final shadowColor =
        theme.appBarTheme.shadowColor ?? theme.shadowColor.withOpacity(0.2);

    return AppBar(
      backgroundColor: appBarBg,
      elevation: 1,
      shadowColor: shadowColor,
      leading: leading ??
          (showBackButton
              ? IconButton(
                  icon: Icon(Icons.arrow_back, color: appBarFg),
                  onPressed: () => Navigator.pop(context),
                )
              : null),
      automaticallyImplyLeading: showBackButton,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.description, color: colorScheme.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
                  color: appBarFg,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ) ??
                TextStyle(
                  color: appBarFg,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
          ),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// ==================== CUSTOM BUTTON ====================
class BockDocsButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double height;

  const BockDocsButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;
    final onPrimaryColor = colorScheme.onPrimary;
    final secondaryBg = theme.colorScheme.surface;
    final secondaryFg = theme.colorScheme.onSurface;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? primaryColor : secondaryBg,
          foregroundColor: isPrimary ? onPrimaryColor : secondaryFg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(color: theme.dividerColor),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isPrimary ? onPrimaryColor : secondaryFg,
                  ),
                ),
              )
            : icon != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        text,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Text(
                    text,
                    style: theme.textTheme.labelLarge?.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ) ??
                        const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
      ),
    );
  }
}

// ==================== DOCUMENT CARD ====================
class DocumentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback? onMorePressed;
  final bool isStarred;
  final VoidCallback? onStarPressed;
  final IconData icon;
  final Color? iconColor;

  const DocumentCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.onMorePressed,
    this.isStarred = false,
    this.onStarPressed,
    this.icon = Icons.description,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardColor = theme.cardColor;
    final borderColor = theme.dividerColor;
    final textPrimary =
        theme.textTheme.bodyLarge?.color ?? colorScheme.onSurface;
    final textSecondary =
        theme.textTheme.bodyMedium?.color ?? colorScheme.onSurface.withOpacity(0.7);
    final shadowColor = theme.shadowColor.withOpacity(
      theme.brightness == Brightness.dark ? 0.25 : 0.08,
    );
    final resolvedIconColor = iconColor ?? colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: resolvedIconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: resolvedIconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                          fontSize: 15,
                          color: textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 13,
                          color: textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            if (onStarPressed != null)
              IconButton(
                icon: Icon(
                  isStarred ? Icons.star : Icons.star_border,
                  color: isStarred ? Colors.amber : textSecondary,
                ),
                onPressed: onStarPressed,
              ),
            if (onMorePressed != null)
              IconButton(
                icon: Icon(Icons.more_vert, color: textSecondary),
                onPressed: onMorePressed,
              ),
          ],
        ),
      ),
    );
  }
}

// ==================== TEMPLATE CARD ====================
class TemplateCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const TemplateCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = const Color(0xFF9333EA),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final borderColor = theme.dividerColor;
    final textColor =
        theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurface;
    final shadowColor = theme.shadowColor.withOpacity(
      theme.brightness == Brightness.dark ? 0.25 : 0.1,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 140,
        height: 170,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== FOLDER CARD ====================
class FolderCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback? onMorePressed;

  const FolderCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.onTap,
    this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardColor = theme.cardColor;
    final borderColor = theme.dividerColor;
    final textPrimary =
        theme.textTheme.titleSmall?.color ?? colorScheme.onSurface;
    final textSecondary =
        theme.textTheme.bodySmall?.color ?? colorScheme.onSurface.withOpacity(0.7);
    final shadowColor = theme.shadowColor.withOpacity(
      theme.brightness == Brightness.dark ? 0.25 : 0.08,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.tertiary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.folder,
                color: colorScheme.tertiary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleSmall?.copyWith(
                          fontSize: 15,
                          color: textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 13,
                          color: textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            if (onMorePressed != null)
              IconButton(
                icon: Icon(Icons.more_vert, color: textSecondary),
                onPressed: onMorePressed,
              ),
          ],
        ),
      ),
    );
  }
}

// ==================== CUSTOM TEXT FIELD ====================
class BockDocsTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int maxLines;

  const BockDocsTextField({
    super.key,
    required this.controller,
    required this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor =
        theme.textTheme.bodyLarge?.color ?? colorScheme.onSurface;
    final labelColor =
        theme.textTheme.bodyMedium?.color ?? colorScheme.onSurface.withOpacity(0.7);
    final fillColor =
        theme.inputDecorationTheme.fillColor ?? colorScheme.surface;
    final dividerColor = theme.dividerColor;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: labelColor),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: colorScheme.primary)
            : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
      ),
    );
  }
}

// ==================== LOADING INDICATOR ====================
class BockDocsLoadingIndicator extends StatelessWidget {
  final String? message;

  const BockDocsLoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textSecondary =
        theme.textTheme.bodyMedium?.color ?? colorScheme.onSurface.withOpacity(0.7);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: theme.textTheme.bodySmall?.copyWith(
                    color: textSecondary,
                    fontSize: 14,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

// ==================== EMPTY STATE ====================
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionText;
  final VoidCallback? onActionPressed;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionText,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        );
    final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
          fontSize: 14,
        );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: subtitleStyle,
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onActionPressed != null) ...[
              const SizedBox(height: 24),
              BockDocsButton(
                text: actionText!,
                onPressed: onActionPressed!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ==================== CONTEXT MENU ====================
class ContextMenu extends StatelessWidget {
  final List<ContextMenuItem> items;

  const ContextMenu({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardColor = theme.cardColor;
    final dividerColor = theme.dividerColor;
    final textPrimary =
        theme.textTheme.bodyMedium?.color ?? colorScheme.onSurface;
    final textSecondary = textPrimary.withOpacity(0.7);
    final shadowColor = theme.shadowColor.withOpacity(
      theme.brightness == Brightness.dark ? 0.4 : 0.15,
    );

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items.map((item) {
          if (item.isDivider) {
            return Divider(height: 1, thickness: 1, color: dividerColor);
          }
          return InkWell(
            onTap: () {
              Navigator.pop(context);
              item.onTap?.call();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    size: 20,
                    color: item.isDestructive
                        ? colorScheme.error
                        : textSecondary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 14,
                        color: item.isDestructive
                            ? colorScheme.error
                            : textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  static void show(BuildContext context, List<ContextMenuItem> items,
      {Offset? position}) {
    showMenu(
      context: context,
      position: position != null
          ? RelativeRect.fromLTRB(
              position.dx, position.dy, position.dx, position.dy)
          : const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: items.map<PopupMenuEntry<dynamic>>((item) {
        if (item.isDivider) {
          return const PopupMenuDivider();
        }
        return PopupMenuItem(
          onTap: item.onTap,
          child: Row(
            children: [
              Icon(
                item.icon,
                size: 20,
                color: item.isDestructive
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.7),
              ),
              const SizedBox(width: 12),
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 14,
                  color: item.isDestructive
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class ContextMenuItem {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isDestructive;
  final bool isDivider;

  ContextMenuItem({
    required this.title,
    required this.icon,
    this.onTap,
    this.isDestructive = false,
  }) : isDivider = false;

  ContextMenuItem.divider()
      : title = '',
        icon = Icons.remove,
        onTap = null,
        isDestructive = false,
        isDivider = true;
}

// ==================== DIALOG HELPERS ====================
class DialogHelper {
  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
        ),
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              cancelText,
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.7),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDestructive
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  static Future<String?> showInputDialog(
    BuildContext context, {
    required String title,
    String? initialValue,
    String hint = '',
    String confirmText = 'Save',
    String cancelText = 'Cancel',
  }) {
    final controller = TextEditingController(text: initialValue);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              cancelText,
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.7),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: duration,
      ),
    );
  }
}

// ==================== SEARCH BAR ====================
class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const SearchBar({
    super.key,
    required this.controller,
    this.hint = 'Search documents...',
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor =
        theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurface;
    final hintColor = textColor.withOpacity(0.6);
    final fillColor =
        theme.inputDecorationTheme.fillColor ?? theme.colorScheme.surface;
    final borderColor = theme.dividerColor;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: hintColor),
          prefixIcon: Icon(Icons.search, color: hintColor),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: hintColor),
                  onPressed: () {
                    controller.clear();
                    onClear?.call();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

// ==================== CHIP WIDGET ====================
class BockDocsChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const BockDocsChip({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedColor = color ?? theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: resolvedColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: resolvedColor,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: resolvedColor,
              ),
            ),
            if (onDelete != null) ...[
              const SizedBox(width: 4),
              InkWell(
                onTap: onDelete,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: resolvedColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ==================== AVATAR ====================
class BockDocsAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final VoidCallback? onTap;

  const BockDocsAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 40,
    this.onTap,
  });

  String _getInitials() {
    if (name == null || name!.isEmpty) return 'U';
    List<String> names = name!.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name![0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.colorScheme.primary;
    final textColor = theme.colorScheme.onPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: bgColor,
        backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
        child: imageUrl == null
            ? Text(
                _getInitials(),
                style: TextStyle(
                  color: textColor,
                  fontSize: size / 2.5,
                  fontWeight: FontWeight.w600,
                ),
              )
            : null,
      ),
    );
  }
}